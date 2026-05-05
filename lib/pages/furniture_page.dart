import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/expandable_sliver_header.dart';
import '../widgets/furniture_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class FurniturePage extends StatefulWidget {
  const FurniturePage({super.key});

  @override
  State<FurniturePage> createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
  final _searchCtrl = TextEditingController();
  final _categories = [
    'All',
    'Sofa',
    'Chair',
    'Table',
    'Bed',
    'Cabinet',
    'Desk',
    'Lighting',
  ];

  @override
  void initState() {
    super.initState();
    context.read<FurnitureBloc>().add(LoadFurniture());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Expandable header — compresses on scroll
          ExpandableSliverHeader(
            title: 'Furniture Gallery',
            subtitle: 'Discover beautiful pieces for your home',
            icon: Icons.chair_outlined,
            expandedHeight: 200,
            actions: [
              BlocBuilder<FurnitureBloc, FurnitureState>(
                builder: (_, state) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      ),
                    ),
                    if (state.cartItemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Badge(
                          label: Text('${state.cartItemCount}'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: CustomSearchBar(
                controller: _searchCtrl,
                onChanged: (q) =>
                    context.read<FurnitureBloc>().add(SearchFurniture(q)),
              ),
            ),
          ),

          // Categories header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text('Categories', style: tt.titleMedium),
            ),
          ),

          // Category chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: BlocBuilder<FurnitureBloc, FurnitureState>(
                builder: (_, state) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) => CategoryChip(
                    label: _categories[i],
                    isSelected: state.selectedCategory == _categories[i],
                    onTap: () => context
                        .read<FurnitureBloc>()
                        .add(FilterByCategory(_categories[i])),
                  ),
                ),
              ),
            ),
          ),

          // Products header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Products', style: tt.titleMedium),
            ),
          ),

          // Grid
          BlocBuilder<FurnitureBloc, FurnitureState>(
            builder: (_, state) {
              if (state.filteredItems.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: cs.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text('No items found',
                            style: tt.bodyLarge
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      final item = state.filteredItems[index];
                      return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailPage(item: item))),
                          child: FurnitureCard(
                            item: item,
                            onFavorite: () => context
                                .read<FurnitureBloc>()
                                .add(ToggleFavorite(item.id)),
                            onAddToCart: () => context
                                .read<FurnitureBloc>()
                                .add(AddToCart(item.id)),
                          ));
                    },
                    childCount: state.filteredItems.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
