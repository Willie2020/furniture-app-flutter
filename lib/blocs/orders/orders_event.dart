import 'package:equatable/equatable.dart';
import '../../models/order.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class PlaceOrder extends OrdersEvent {
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String? customerName;
  final String? shippingAddress;
  final String? paymentMethod;

  const PlaceOrder({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    this.customerName,
    this.shippingAddress,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        items,
        subtotal,
        shipping,
        tax,
        total,
        customerName,
        shippingAddress,
        paymentMethod,
      ];
}

class CancelOrder extends OrdersEvent {
  final String orderId;

  const CancelOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final OrderStatus status;

  const UpdateOrderStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}
