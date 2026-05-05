import 'package:equatable/equatable.dart';

class FurnitureCollection extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final String tag;
  final List<int> productIds; // references to furniture_item ids

  const FurnitureCollection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tag,
    required this.productIds,
  });

  @override
  List<Object?> get props => [id, title, subtitle, image, tag, productIds];
}

final List<FurnitureCollection> sampleCollections = [
  FurnitureCollection(
    id: 1,
    title: 'Mid-Century Modern',
    subtitle: 'Clean lines & organic curves',
    image: 'https://place-hold.it/400x300/teal/white?text=Mid-Century',
    tag: 'Trending',
    productIds: [1, 8, 9],
  ),
  FurnitureCollection(
    id: 2,
    title: 'Cozy Minimalist',
    subtitle: 'Less clutter, more calm',
    image: 'https://place-hold.it/400x300/beige/white?text=Minimalist',
    tag: 'New',
    productIds: [4, 5, 7],
  ),
  FurnitureCollection(
    id: 3,
    title: 'Industrial Loft',
    subtitle: 'Raw materials, bold character',
    image: 'https://place-hold.it/400x300/charcoal/white?text=Industrial',
    tag: 'Popular',
    productIds: [6, 10],
  ),
];
