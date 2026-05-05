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
  final String image;
  final String description;
  final String category;
  final double rating;

  const AddNewProduct({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
  });

  @override
  List<Object?> get props =>
      [name, price, image, description, category, rating];
}

class DeleteProduct extends FurnitureEvent {
  final int itemId;

  const DeleteProduct(this.itemId);

  @override
  List<Object?> get props => [itemId];
}
