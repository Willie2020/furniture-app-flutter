import 'package:equatable/equatable.dart';

abstract class FurnitureEvent extends Equatable {
  const FurnitureEvent();

  @override
  List<Object?> get props => [];
}

class LoadFurniture extends FurnitureEvent {}

class FilterByCategory extends FurnitureEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ToggleFavorite extends FurnitureEvent {
  final int itemId;

  const ToggleFavorite(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class SearchFurniture extends FurnitureEvent {
  final String query;

  const SearchFurniture(this.query);

  @override
  List<Object?> get props => [query];
}

class AddToCart extends FurnitureEvent {
  final int itemId;

  const AddToCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class RemoveFromCart extends FurnitureEvent {
  final int itemId;

  const RemoveFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class AddNewProduct extends FurnitureEvent {
  final String name;
  final double price;
  final double? salePrice;
  final String image;
  final List<String> images;
  final String description;
  final String category;
  final double rating;
  final int stockQuantity;
  final String? materials;
  final String? dimensions;
  final String? color;

  const AddNewProduct({
    required this.name,
    required this.price,
    this.salePrice,
    required this.image,
    this.images = const [],
    required this.description,
    required this.category,
    required this.rating,
    this.stockQuantity = 10,
    this.materials,
    this.dimensions,
    this.color,
  });

  @override
  List<Object?> get props => [
        name,
        price,
        salePrice,
        image,
        images,
        description,
        category,
        rating,
        stockQuantity,
        materials,
        dimensions,
        color,
      ];
}

class UpdateProduct extends FurnitureEvent {
  final int itemId;
  final String? name;
  final double? price;
  final double? salePrice;
  final bool? clearSalePrice;
  final String? image;
  final List<String>? images;
  final String? description;
  final String? category;
  final double? rating;
  final int? stockQuantity;
  final bool? isActive;
  final String? materials;
  final String? dimensions;
  final String? color;

  const UpdateProduct({
    required this.itemId,
    this.name,
    this.price,
    this.salePrice,
    this.clearSalePrice,
    this.image,
    this.images,
    this.description,
    this.category,
    this.rating,
    this.stockQuantity,
    this.isActive,
    this.materials,
    this.dimensions,
    this.color,
  });

  @override
  List<Object?> get props => [
        itemId,
        name,
        price,
        salePrice,
        clearSalePrice,
        image,
        images,
        description,
        category,
        rating,
        stockQuantity,
        isActive,
        materials,
        dimensions,
        color,
      ];
}

class DeleteProduct extends FurnitureEvent {
  final int itemId;

  const DeleteProduct(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ToggleProductActive extends FurnitureEvent {
  final int itemId;

  const ToggleProductActive(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class DuplicateProduct extends FurnitureEvent {
  final int itemId;

  const DuplicateProduct(this.itemId);

  @override
  List<Object?> get props => [itemId];
}
