import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import '../models/order.dart';

class OrdersDatabase {
  OrdersDatabase._();
  static final OrdersDatabase instance = OrdersDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'orders.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            items TEXT NOT NULL,
            subtotal REAL NOT NULL,
            shipping REAL NOT NULL,
            tax REAL NOT NULL,
            total REAL NOT NULL,
            status TEXT NOT NULL DEFAULT 'pending',
            orderDate TEXT NOT NULL,
            customerName TEXT,
            shippingAddress TEXT,
            paymentMethod TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      {
        'id': order.id,
        'items': jsonEncode(order.items.map((i) => i.toMap()).toList()),
        'subtotal': order.subtotal,
        'shipping': order.shipping,
        'tax': order.tax,
        'total': order.total,
        'status': order.status.name,
        'orderDate': order.orderDate.toIso8601String(),
        'customerName': order.customerName,
        'shippingAddress': order.shippingAddress,
        'paymentMethod': order.paymentMethod,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order>> getAllOrders() async {
    final db = await database;
    final results = await db.query('orders', orderBy: 'orderDate DESC');
    return results.map((row) {
      final itemsJson = jsonDecode(row['items'] as String) as List<dynamic>;
      final items = itemsJson
          .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
          .toList();

      return Order(
        id: row['id'] as String,
        items: items,
        subtotal: (row['subtotal'] as num).toDouble(),
        shipping: (row['shipping'] as num).toDouble(),
        tax: (row['tax'] as num).toDouble(),
        total: (row['total'] as num).toDouble(),
        status: OrderStatus.values.firstWhere(
          (s) => s.name == row['status'],
          orElse: () => OrderStatus.pending,
        ),
        orderDate: DateTime.parse(row['orderDate'] as String),
        customerName: row['customerName'] as String?,
        shippingAddress: row['shippingAddress'] as String?,
        paymentMethod: row['paymentMethod'] as String?,
      );
    }).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<void> deleteOrder(String orderId) async {
    final db = await database;
    await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
  }
}
