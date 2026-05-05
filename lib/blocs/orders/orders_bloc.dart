import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';
import '../../services/orders_database.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersDatabase _db = OrdersDatabase.instance;

  OrdersBloc() : super(const OrdersState()) {
    on<LoadOrders>(_onLoad);
    on<PlaceOrder>(_onPlaceOrder);
    on<CancelOrder>(_onCancelOrder);
    on<UpdateOrderStatus>(_onUpdateStatus);
  }

  Future<void> _onLoad(LoadOrders event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(status: OrdersLoadStatus.loading));
    try {
      final orders = await _db.getAllOrders();
      emit(state.copyWith(status: OrdersLoadStatus.loaded, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: 'Failed to load orders: $e',
      ));
    }
  }

  Future<void> _onPlaceOrder(
      PlaceOrder event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(status: OrdersLoadStatus.loading));
    try {
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: event.items,
        subtotal: event.subtotal,
        shipping: event.shipping,
        tax: event.tax,
        total: event.total,
        status: OrderStatus.pending,
        orderDate: DateTime.now(),
        customerName: event.customerName,
        shippingAddress: event.shippingAddress,
        paymentMethod: event.paymentMethod,
      );

      await _db.insertOrder(order);

      // Reload all orders
      final orders = await _db.getAllOrders();
      emit(state.copyWith(status: OrdersLoadStatus.loaded, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: 'Failed to place order: $e',
      ));
    }
  }

  Future<void> _onCancelOrder(
      CancelOrder event, Emitter<OrdersState> emit) async {
    try {
      await _db.updateOrderStatus(event.orderId, OrderStatus.cancelled.name);
      final orders = await _db.getAllOrders();
      emit(state.copyWith(status: OrdersLoadStatus.loaded, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: 'Failed to cancel order: $e',
      ));
    }
  }

  Future<void> _onUpdateStatus(
      UpdateOrderStatus event, Emitter<OrdersState> emit) async {
    try {
      await _db.updateOrderStatus(event.orderId, event.status.name);
      final orders = await _db.getAllOrders();
      emit(state.copyWith(status: OrdersLoadStatus.loaded, orders: orders));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersLoadStatus.error,
        errorMessage: 'Failed to update order: $e',
      ));
    }
  }
}
