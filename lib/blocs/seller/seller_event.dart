import 'package:equatable/equatable.dart';
import '../../models/order.dart';

abstract class SellerEvent extends Equatable {
  const SellerEvent();

  @override
  List<Object?> get props => [];
}

class LoadSellerDashboard extends SellerEvent {
  const LoadSellerDashboard();
}

class SellerUpdateOrderStatus extends SellerEvent {
  final String orderId;
  final OrderStatus status;

  const SellerUpdateOrderStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}
