import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../models/collection.dart';
import '../models/deal.dart';
import '../widgets/expandable_sliver_header.dart';
import 'deals_page.dart';
import 'furniture_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        ExpandableSliverHeader(
          title: 'Explore',
          subtitle: 'Trending deals, collections & more',
          icon: Icons.explore_outlined,
          expandedHeight: 190,
        ),

        // Flash Deals section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(children: [
              Icon(Icons.bolt, color: cs.error, size: 20),
              const SizedBox(width: 6),
              Text('Flash Deals', style: tt.titleMedium),
              const Spacer(),
              TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DealsPage())),
                  child: const Text('See all')),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: sampleDeals.length,
              itemBuilder: (_, i) => _DealCard(deal: sampleDeals[i]),
            ),
          ),
        ),

        // Collections section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(children: [
              Icon(Icons.auto_awesome, color: cs.tertiary, size: 20),
              const SizedBox(width: 6),
              Text('Curated Collections', style: tt.titleMedium),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: sampleCollections.length,
              itemBuilder: (_, i) =>
                  _CollectionCard(collection: sampleCollections[i]),
            ),
          ),
        ),

        // Trending search section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(children: [
              Icon(Icons.trending_up, color: cs.primary, size: 20),
              const SizedBox(width: 6),
              Text('Trending Searches', style: tt.titleMedium),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Scandinavian sofa',
                'Velvet armchair',
                'Oak dining table',
                'King bed frame',
                'Standing desk',
                'Bookshelf',
                'Floor lamp',
                'Coffee table',
              ]
                  .map((t) => ActionChip(
                        label: Text(t),
                        onPressed: () {
                          context.read<FurnitureBloc>().add(SearchFurniture(t));
                          _switchToShopTab(context);
                        },
                        avatar: const Icon(Icons.search, size: 14),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  void _switchToShopTab(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FurniturePage()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Search results shown in Shop'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final Deal deal;
  const _DealCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(deal.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: cs.surfaceContainerHighest)),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: cs.error,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('-${deal.discountPercent}%',
                        style: tt.labelSmall?.copyWith(color: cs.onError)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.title,
                      style: tt.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text('\$${deal.dealPrice}',
                        style: tt.titleMedium?.copyWith(
                            color: cs.error, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('\$${deal.originalPrice}',
                        style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough)),
                  ]),
                  const Spacer(),
                  Row(children: [
                    Icon(Icons.access_time, size: 14, color: cs.error),
                    const SizedBox(width: 4),
                    Text('${deal.remainingHours}h left',
                        style: tt.bodySmall?.copyWith(color: cs.error)),
                    const Spacer(),
                    Text('${deal.soldCount} sold', style: tt.bodySmall),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final FurnitureCollection collection;
  const _CollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(collection.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: cs.surfaceContainerHighest)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: cs.tertiary,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(collection.tag,
                    style: tt.labelSmall?.copyWith(color: cs.onTertiary)),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(collection.title,
                      style: tt.titleMedium?.copyWith(color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(collection.subtitle,
                      style: tt.bodySmall?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
