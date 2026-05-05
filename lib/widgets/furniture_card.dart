import 'package:flutter/material.dart';
import '../models/furniture_item.dart';
import 'star_rating.dart';

class FurnitureCard extends StatelessWidget {
  final FurnitureItem item;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;

  const FurnitureCard({
    super.key,
    required this.item,
    required this.onFavorite,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image — top ~55%
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'product_${item.id}',
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceContainerHighest,
                      child: Icon(Icons.image_not_supported,
                          size: 40, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
                // Favorite
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                      ),
                      color: item.isFavorite ? cs.error : cs.onPrimary,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.25),
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                  ),
                ),
                // Price badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.isOnSale
                          ? Colors.orange.shade700
                          : cs.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '\$${item.displayPrice.toStringAsFixed(0)}',
                      style: tt.labelMedium?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Sale badge
                if (item.isOnSale)
                  Positioned(
                    top: 6,
                    right: 38,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${item.discountPercent}%',
                        style: tt.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Details — bottom ~45%
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: tt.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(item.description,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  StarRating(rating: item.rating, size: 13),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: FilledButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Cart'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(0, 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
