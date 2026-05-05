import 'package:equatable/equatable.dart';
import '../../models/furniture_item.dart';

enum FurnitureStatus { initial, loading, loaded, error }

class FurnitureState extends Equatable {
  final FurnitureStatus status;
  final List<FurnitureItem> items;
  final List<FurnitureItem> filteredItems;
  final List<FurnitureItem> cartItems;
  final String selectedCategory;
  final String searchQuery;

  const FurnitureState({
    this.status = FurnitureStatus.initial,
    this.items = const [],
    this.filteredItems = const [],
    this.cartItems = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  FurnitureState copyWith({
    FurnitureStatus? status,
    List<FurnitureItem>? items,
    List<FurnitureItem>? filteredItems,
    List<FurnitureItem>? cartItems,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return FurnitureState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      cartItems: cartItems ?? this.cartItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int get cartItemCount => cartItems.length;

  // ── Seller / inventory helpers ──
  List<FurnitureItem> get activeItems =>
      items.where((i) => i.isActive).toList();

  int get totalProducts => items.length;
  int get activeProductCount => items.where((i) => i.isActive).length;
  int get outOfStockCount =>
      items.where((i) => i.isActive && i.stockQuantity == 0).length;
  int get lowStockCount => items
      .where((i) => i.isActive && i.stockQuantity > 0 && i.stockQuantity <= 5)
      .length;
  int get onSaleCount => items.where((i) => i.isActive && i.isOnSale).length;
  double get totalInventoryValue =>
      items.fold(0, (sum, i) => sum + (i.displayPrice * i.stockQuantity));

  @override
  List<Object?> get props =>
      [status, items, filteredItems, cartItems, selectedCategory, searchQuery];
}
