import 'package:equatable/equatable.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class OrderItem extends Equatable {
  final int productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        productId: map['productId'] as int,
        productName: map['productName'] as String,
        productImage: map['productImage'] as String,
        unitPrice: (map['unitPrice'] as num).toDouble(),
        quantity: map['quantity'] as int? ?? 1,
      );

  @override
  List<Object?> get props =>
      [productId, productName, productImage, unitPrice, quantity];
}

class Order extends Equatable {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime orderDate;
  final String? customerName;
  final String? shippingAddress;
  final String? paymentMethod;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    this.status = OrderStatus.pending,
    required this.orderDate,
    this.customerName,
    this.shippingAddress,
    this.paymentMethod,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  Order copyWith({
    String? id,
    List<OrderItem>? items,
    double? subtotal,
    double? shipping,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? orderDate,
    String? customerName,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shipping: shipping ?? this.shipping,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      customerName: customerName ?? this.customerName,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'items': items.map((i) => i.toMap()).toList(),
        'subtotal': subtotal,
        'shipping': shipping,
        'tax': tax,
        'total': total,
        'status': status.name,
        'orderDate': orderDate.toIso8601String(),
        'customerName': customerName,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
      };

  factory Order.fromMap(Map<String, dynamic> map) {
    final itemsList = (map['items'] as List<dynamic>?)
            ?.map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [];

    return Order(
      id: map['id'] as String,
      items: itemsList,
      subtotal: (map['subtotal'] as num).toDouble(),
      shipping: (map['shipping'] as num).toDouble(),
      tax: (map['tax'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(map['orderDate'] as String),
      customerName: map['customerName'] as String?,
      shippingAddress: map['shippingAddress'] as String?,
      paymentMethod: map['paymentMethod'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        subtotal,
        shipping,
        tax,
        total,
        status,
        orderDate,
        customerName,
        shippingAddress,
        paymentMethod,
      ];
}
