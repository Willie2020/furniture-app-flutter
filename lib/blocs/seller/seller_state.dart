import 'package:equatable/equatable.dart';
import '../../models/order.dart';

enum SellerStatus { initial, loading, loaded, error }

class SellerState extends Equatable {
  final SellerStatus status;
  final List<Order> orders;
  final List<Order> recentOrders;
  final String? errorMessage;

  // ── Aggregated metrics ──
  final int totalOrders;
  final int pendingOrders;
  final int confirmedOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final double totalRevenue;
  final double todayRevenue;
  final double averageOrderValue;

  const SellerState({
    this.status = SellerStatus.initial,
    this.orders = const [],
    this.recentOrders = const [],
    this.errorMessage,
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.confirmedOrders = 0,
    this.shippedOrders = 0,
    this.deliveredOrders = 0,
    this.cancelledOrders = 0,
    this.totalRevenue = 0,
    this.todayRevenue = 0,
    this.averageOrderValue = 0,
  });

  SellerState copyWith({
    SellerStatus? status,
    List<Order>? orders,
    List<Order>? recentOrders,
    String? errorMessage,
    int? totalOrders,
    int? pendingOrders,
    int? confirmedOrders,
    int? shippedOrders,
    int? deliveredOrders,
    int? cancelledOrders,
    double? totalRevenue,
    double? todayRevenue,
    double? averageOrderValue,
  }) {
    return SellerState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      recentOrders: recentOrders ?? this.recentOrders,
      errorMessage: errorMessage,
      totalOrders: totalOrders ?? this.totalOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      confirmedOrders: confirmedOrders ?? this.confirmedOrders,
      shippedOrders: shippedOrders ?? this.shippedOrders,
      deliveredOrders: deliveredOrders ?? this.deliveredOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        recentOrders,
        errorMessage,
        totalOrders,
        pendingOrders,
        confirmedOrders,
        shippedOrders,
        deliveredOrders,
        cancelledOrders,
        totalRevenue,
        todayRevenue,
        averageOrderValue,
      ];
}
