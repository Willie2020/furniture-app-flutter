import 'package:equatable/equatable.dart';

class FurnitureItem extends Equatable {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;
  final bool isFavorite;

  const FurnitureItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
    this.isFavorite = false,
  });

  FurnitureItem copyWith({
    int? id,
    String? name,
    double? price,
    String? image,
    String? description,
    String? category,
    double? rating,
    bool? isFavorite,
  }) {
    return FurnitureItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, price, image, description, category, rating, isFavorite];
}

/// Sample furniture data
List<FurnitureItem> sampleFurniture = [
  FurnitureItem(
    id: 1,
    name: 'Modern Sofa',
    price: 599,
    image: 'https://place-hold.it/300x200/teal/white?text=Modern+Sofa',
    description: 'Comfortable 3-seater velvet sofa',
    category: 'Sofa',
    rating: 4.5,
  ),
  FurnitureItem(
    id: 2,
    name: 'Dining Table',
    price: 399,
    image: 'https://place-hold.it/300x200/brown/white?text=Dining+Table',
    description: 'Solid oak 6-seater dining table',
    category: 'Table',
    rating: 4.2,
  ),
  FurnitureItem(
    id: 3,
    name: 'Queen Bed Frame',
    price: 699,
    image: 'https://place-hold.it/300x200/navy/white?text=Bed+Frame',
    description: 'Upholstered queen size bed frame',
    category: 'Bed',
    rating: 4.8,
  ),
  FurnitureItem(
    id: 4,
    name: 'Bookshelf',
    price: 249,
    image: 'https://place-hold.it/300x200/slate/white?text=Bookshelf',
    description: '5-tier industrial wooden bookshelf',
    category: 'Cabinet',
    rating: 4.0,
  ),
  FurnitureItem(
    id: 5,
    name: 'Desk Lamp',
    price: 89,
    image: 'https://place-hold.it/300x200/gold/black?text=Desk+Lamp',
    description: 'Adjustable LED architect desk lamp',
    category: 'Lighting',
    rating: 4.6,
  ),
  FurnitureItem(
    id: 6,
    name: 'Wooden Cabinet',
    price: 449,
    image: 'https://place-hold.it/300x200/maroon/white?text=Cabinet',
    description: 'Vintage 3-drawer wooden cabinet',
    category: 'Cabinet',
    rating: 4.3,
  ),
  FurnitureItem(
    id: 7,
    name: 'Office Desk',
    price: 529,
    image: 'https://place-hold.it/300x200/indigo/white?text=Office+Desk',
    description: 'Spacious L-shaped corner work desk',
    category: 'Desk',
    rating: 4.4,
  ),
  FurnitureItem(
    id: 8,
    name: 'Accent Chair',
    price: 299,
    image: 'https://place-hold.it/300x200/coral/white?text=Accent+Chair',
    description: 'Mid-century modern accent lounge chair',
    category: 'Chair',
    rating: 4.7,
  ),
  FurnitureItem(
    id: 9,
    name: 'Coffee Table',
    price: 199,
    image: 'https://place-hold.it/300x200/olive/white?text=Coffee+Table',
    description: 'Minimalist glass-top coffee table',
    category: 'Table',
    rating: 4.1,
  ),
  FurnitureItem(
    id: 10,
    name: 'Wardrobe',
    price: 799,
    image: 'https://place-hold.it/300x200/charcoal/white?text=Wardrobe',
    description: 'Sliding-door 3-door mirrored wardrobe',
    category: 'Cabinet',
    rating: 4.5,
  ),
];
