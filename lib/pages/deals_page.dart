import 'package:flutter/material.dart';
import '../models/deal.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flash Deals 🚀', style: tt.titleLarge),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleDeals.length,
        itemBuilder: (_, i) {
          final deal = sampleDeals[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 140,
              child: Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          deal.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: cs.surfaceContainerHighest),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: cs.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('-${deal.discountPercent}%',
                                style:
                                    tt.labelSmall?.copyWith(color: cs.onError)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(deal.title,
                              style: tt.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('\$${deal.dealPrice}',
                                  style: tt.titleLarge?.copyWith(
                                      color: cs.error,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Text('\$${deal.originalPrice}',
                                  style: tt.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      decoration: TextDecoration.lineThrough)),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: cs.error),
                              const SizedBox(width: 4),
                              Text('${deal.remainingHours}h left',
                                  style:
                                      tt.bodySmall?.copyWith(color: cs.error)),
                              const Spacer(),
                              Text('${deal.soldCount} sold',
                                  style: tt.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
