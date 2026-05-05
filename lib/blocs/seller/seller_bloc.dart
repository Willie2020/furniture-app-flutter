import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';
import '../../services/orders_database.dart';
import 'seller_event.dart';
import 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final OrdersDatabase _db = OrdersDatabase.instance;

  SellerBloc() : super(const SellerState()) {
    on<LoadSellerDashboard>(_onLoad);
    on<SellerUpdateOrderStatus>(_onUpdateStatus);
  }

  Future<void> _onLoad(
      LoadSellerDashboard event, Emitter<SellerState> emit) async {
    emit(state.copyWith(status: SellerStatus.loading));
    try {
      final orders = await _db.getAllOrders();
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      // Active orders (not cancelled)
      final activeOrders =
          orders.where((o) => o.status != OrderStatus.cancelled).toList();

      final totalRevenue =
          activeOrders.fold<double>(0, (sum, o) => sum + o.total);

      final todayRevenue = activeOrders
          .where((o) => o.orderDate.isAfter(todayStart))
          .fold<double>(0, (sum, o) => sum + o.total);

      final averageOrderValue = activeOrders.isEmpty
          ? 0.0
          : totalRevenue / activeOrders.length.toDouble();

      emit(state.copyWith(
        status: SellerStatus.loaded,
        orders: orders,
        recentOrders: orders.take(10).toList(),
        totalOrders: orders.length,
        pendingOrders:
            orders.where((o) => o.status == OrderStatus.pending).length,
        confirmedOrders:
            orders.where((o) => o.status == OrderStatus.confirmed).length,
        shippedOrders:
            orders.where((o) => o.status == OrderStatus.shipped).length,
        deliveredOrders:
            orders.where((o) => o.status == OrderStatus.delivered).length,
        cancelledOrders:
            orders.where((o) => o.status == OrderStatus.cancelled).length,
        totalRevenue: totalRevenue,
        todayRevenue: todayRevenue,
        averageOrderValue: averageOrderValue,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SellerStatus.error,
        errorMessage: 'Failed to load dashboard: $e',
      ));
    }
  }

  Future<void> _onUpdateStatus(
      SellerUpdateOrderStatus event, Emitter<SellerState> emit) async {
    try {
      await _db.updateOrderStatus(event.orderId, event.status.name);
      // Reload the dashboard to reflect changes
      add(const LoadSellerDashboard());
    } catch (e) {
      emit(state.copyWith(
        status: SellerStatus.error,
        errorMessage: 'Failed to update order: $e',
      ));
    }
  }
}
