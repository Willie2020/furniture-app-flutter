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

  @override
  List<Object?> get props =>
      [status, items, filteredItems, cartItems, selectedCategory, searchQuery];
}
