import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';
import '../models/furniture_item.dart';
import '../widgets/star_rating.dart';

class ProductDetailPage extends StatelessWidget {
  final FurnitureItem item;
  const ProductDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${item.id}',
                child: Image.network(item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: cs.surfaceContainerHighest)),
              ),
            ),
            actions: [
              BlocBuilder<FurnitureBloc, FurnitureState>(
                builder: (_, state) {
                  final isFav =
                      state.items.any((i) => i.id == item.id && i.isFavorite);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? cs.error : cs.onPrimary),
                    onPressed: () => context
                        .read<FurnitureBloc>()
                        .add(ToggleFavorite(item.id)),
                  );
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.name, style: tt.headlineMedium),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (item.isOnSale) ...[
                            Text(
                              '\$${item.price.toStringAsFixed(0)}',
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '\$${item.displayPrice.toStringAsFixed(0)}',
                              style:
                                  tt.headlineMedium?.copyWith(color: cs.error),
                            ),
                          ] else ...[
                            Text(
                              '\$${item.displayPrice.toStringAsFixed(0)}',
                              style: tt.headlineMedium
                                  ?.copyWith(color: cs.primary),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    StarRating(rating: item.rating, size: 18),
                    const SizedBox(width: 8),
                    Text(item.rating.toString(), style: tt.bodyMedium),
                    const SizedBox(width: 4),
                    Text('• ${item.category}',
                        style: tt.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant)),
                    if (item.color != null) ...[
                      const SizedBox(width: 4),
                      Text('• ${item.color}',
                          style: tt.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ]),
                  if (item.isOnSale)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.discountPercent}% off — Save \$${(item.price - item.displayPrice).toStringAsFixed(0)}',
                          style: tt.labelMedium
                              ?.copyWith(color: Colors.orange.shade700),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description', style: tt.titleMedium),
                  const SizedBox(height: 8),
                  Text(item.description,
                      style:
                          tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 20),

                  // Specs table
                  Text('Specifications', style: tt.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      _specRow(cs, tt, 'Category', item.category),
                      if (item.materials != null) ...[
                        const Divider(height: 20),
                        _specRow(cs, tt, 'Materials', item.materials!),
                      ],
                      if (item.dimensions != null) ...[
                        const Divider(height: 20),
                        _specRow(cs, tt, 'Dimensions', item.dimensions!),
                      ],
                      if (item.color != null) ...[
                        const Divider(height: 20),
                        _specRow(cs, tt, 'Color', item.color!),
                      ],
                      const Divider(height: 20),
                      _specRow(cs, tt, 'Rating', '${item.rating}/5'),
                      const Divider(height: 20),
                      _specRow(
                          cs,
                          tt,
                          'Stock',
                          item.stockQuantity > 0
                              ? '${item.stockQuantity} in stock'
                              : 'Out of stock'),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // "View in Room" mock
                  Text('Experience it', style: tt.titleMedium),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _showARDialog(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: cs.primaryContainer,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.view_in_ar,
                                size: 48, color: cs.onPrimaryContainer),
                            const SizedBox(height: 8),
                            Text('View in Your Room',
                                style: tt.titleMedium
                                    ?.copyWith(color: cs.onPrimaryContainer)),
                            Text('See how it fits in your space',
                                style: tt.bodySmall
                                    ?.copyWith(color: cs.onPrimaryContainer)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80), // FAB space
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: () {
                context.read<FurnitureBloc>().add(AddToCart(item.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} added to cart!')),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: () =>
                  context.read<FurnitureBloc>().add(ToggleFavorite(item.id)),
              icon: const Icon(Icons.favorite_border),
              label: const Text('Save'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _showARDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.view_in_ar, color: cs.primary),
            const SizedBox(width: 10),
            Text('AR View', style: tt.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: cs.surfaceContainerHighest,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        size: 48, color: cs.onSurfaceVariant),
                    const SizedBox(height: 8),
                    Text('Camera preview',
                        style: tt.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Point your camera at an open area to see how ${item.name} fits in your space.',
              style: tt.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('AR experience launching soon! 🚀'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Launch AR'),
          ),
        ],
      ),
    );
  }

  Widget _specRow(ColorScheme cs, TextTheme tt, String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
      Text(value, style: tt.bodyMedium),
    ]);
  }
}
