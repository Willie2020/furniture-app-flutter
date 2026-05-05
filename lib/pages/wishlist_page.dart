import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';
import '../widgets/expandable_sliver_header.dart';
import '../widgets/furniture_card.dart';
import 'product_detail_page.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<FurnitureBloc, FurnitureState>(
      builder: (_, state) {
        final favorites = state.items.where((i) => i.isFavorite).toList();

        if (favorites.isEmpty) {
          return CustomScrollView(
            slivers: [
              ExpandableSliverHeader(
                title: 'Wishlist',
                subtitle: 'Your saved favorites',
                icon: Icons.favorite_outline,
                expandedHeight: 170,
              ),
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 72, color: cs.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text('No favorites yet', style: tt.titleMedium),
                      const SizedBox(height: 6),
                      Text('Tap the heart to save items',
                          style: tt.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return CustomScrollView(
          slivers: [
            ExpandableSliverHeader(
              title: 'Wishlist (${favorites.length})',
              subtitle: 'Your saved favorites',
              icon: Icons.favorite_outline,
              expandedHeight: 170,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailPage(item: favorites[i]))),
                    child: FurnitureCard(
                      item: favorites[i],
                      onFavorite: () => context
                          .read<FurnitureBloc>()
                          .add(ToggleFavorite(favorites[i].id)),
                      onAddToCart: () => context
                          .read<FurnitureBloc>()
                          .add(AddToCart(favorites[i].id)),
                    ),
                  ),
                  childCount: favorites.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
