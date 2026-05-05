import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/furniture_item.dart';
import 'furniture_event.dart';
import 'furniture_state.dart';

class FurnitureBloc extends Bloc<FurnitureEvent, FurnitureState> {
  FurnitureBloc() : super(const FurnitureState()) {
    on<LoadFurniture>(_onLoad);
    on<FilterByCategory>(_onFilter);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchFurniture>(_onSearch);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<AddNewProduct>(_onAddNewProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ToggleProductActive>(_onToggleActive);
    on<DuplicateProduct>(_onDuplicateProduct);
  }

  void _onLoad(LoadFurniture event, Emitter<FurnitureState> emit) {
    emit(state.copyWith(
      status: FurnitureStatus.loaded,
      items: sampleFurniture,
      filteredItems: sampleFurniture,
    ));
  }

  void _onFilter(FilterByCategory event, Emitter<FurnitureState> emit) {
    final filtered = event.category == 'All'
        ? state.items
        : state.items.where((i) => i.category == event.category).toList();

    emit(state.copyWith(
      selectedCategory: event.category,
      filteredItems: filtered,
    ));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<FurnitureState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(isFavorite: !item.isFavorite);
      }
      return item;
    }).toList();

    final updatedFiltered = state.filteredItems.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(isFavorite: !item.isFavorite);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems, filteredItems: updatedFiltered));
  }

  void _onSearch(SearchFurniture event, Emitter<FurnitureState> emit) {
    final query = event.query.toLowerCase();
    final filtered = query.isEmpty
        ? state.items
        : state.items
            .where((i) =>
                i.name.toLowerCase().contains(query) ||
                i.description.toLowerCase().contains(query) ||
                i.category.toLowerCase().contains(query))
            .toList();

    emit(state.copyWith(searchQuery: query, filteredItems: filtered));
  }

  void _onAddToCart(AddToCart event, Emitter<FurnitureState> emit) {
    final item = state.items.firstWhere((i) => i.id == event.itemId);
    final updatedCart = List<FurnitureItem>.from(state.cartItems)..add(item);
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<FurnitureState> emit) {
    final updatedCart =
        state.cartItems.where((i) => i.id != event.itemId).toList();
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onAddNewProduct(AddNewProduct event, Emitter<FurnitureState> emit) {
    final newId = state.items.isEmpty
        ? 1
        : state.items.map((i) => i.id).reduce((a, b) => a > b ? a : b) + 1;
    final newItem = FurnitureItem(
      id: newId,
      name: event.name,
      price: event.price,
      salePrice: event.salePrice,
      image: event.image,
      images: event.images,
      description: event.description,
      category: event.category,
      rating: event.rating,
      stockQuantity: event.stockQuantity,
      materials: event.materials,
      dimensions: event.dimensions,
      color: event.color,
    );
    final updated = [...state.items, newItem];
    emit(state.copyWith(items: updated, filteredItems: updated));
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<FurnitureState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(
          name: event.name,
          price: event.price,
          salePrice: event.salePrice,
          clearSalePrice: event.clearSalePrice ?? false,
          image: event.image,
          images: event.images,
          description: event.description,
          category: event.category,
          rating: event.rating,
          stockQuantity: event.stockQuantity,
          isActive: event.isActive,
          materials: event.materials,
          dimensions: event.dimensions,
          color: event.color,
        );
      }
      return item;
    }).toList();

    final updatedFiltered = state.filteredItems.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(
          name: event.name,
          price: event.price,
          salePrice: event.salePrice,
          clearSalePrice: event.clearSalePrice ?? false,
          image: event.image,
          images: event.images,
          description: event.description,
          category: event.category,
          rating: event.rating,
          stockQuantity: event.stockQuantity,
          isActive: event.isActive,
          materials: event.materials,
          dimensions: event.dimensions,
          color: event.color,
        );
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems, filteredItems: updatedFiltered));
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<FurnitureState> emit) {
    final updated = state.items.where((i) => i.id != event.itemId).toList();
    final updatedFiltered =
        state.filteredItems.where((i) => i.id != event.itemId).toList();
    final updatedCart =
        state.cartItems.where((i) => i.id != event.itemId).toList();
    emit(state.copyWith(
        items: updated,
        filteredItems: updatedFiltered,
        cartItems: updatedCart));
  }

  void _onToggleActive(
      ToggleProductActive event, Emitter<FurnitureState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(isActive: !item.isActive);
      }
      return item;
    }).toList();

    final updatedFiltered = state.filteredItems.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(isActive: !item.isActive);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems, filteredItems: updatedFiltered));
  }

  void _onDuplicateProduct(
      DuplicateProduct event, Emitter<FurnitureState> emit) {
    final original = state.items.firstWhere((i) => i.id == event.itemId);
    final newId =
        state.items.map((i) => i.id).reduce((a, b) => a > b ? a : b) + 1;
    final duplicate = original.copyWith(
      id: newId,
      name: '${original.name} (Copy)',
      dateAdded: DateTime.now(),
    );
    final updated = [...state.items, duplicate];
    emit(state.copyWith(items: updated, filteredItems: updated));
  }
}
