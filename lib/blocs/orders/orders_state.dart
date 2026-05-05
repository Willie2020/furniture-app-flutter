import 'package:equatable/equatable.dart';
import '../../models/order.dart';

enum OrdersLoadStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  final OrdersLoadStatus status;
  final List<Order> orders;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersLoadStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  // ── Computed helpers ──
  List<Order> get pendingOrders =>
      orders.where((o) => o.status == OrderStatus.pending).toList();

  List<Order> get confirmedOrders =>
      orders.where((o) => o.status == OrderStatus.confirmed).toList();

  List<Order> get shippedOrders =>
      orders.where((o) => o.status == OrderStatus.shipped).toList();

  List<Order> get deliveredOrders =>
      orders.where((o) => o.status == OrderStatus.delivered).toList();

  List<Order> get cancelledOrders =>
      orders.where((o) => o.status == OrderStatus.cancelled).toList();

  int get totalOrderCount => orders.length;

  double get totalRevenue => orders
      .where((o) => o.status != OrderStatus.cancelled)
      .fold(0, (sum, o) => sum + o.total);

  double get pendingRevenue => pendingOrders.fold(0, (sum, o) => sum + o.total);

  OrdersState copyWith({
    OrdersLoadStatus? status,
    List<Order>? orders,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
