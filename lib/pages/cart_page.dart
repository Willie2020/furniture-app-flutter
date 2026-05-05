import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<FurnitureBloc, FurnitureState>(
      builder: (_, state) {
        if (state.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 72, color: cs.onSurfaceVariant),
                const SizedBox(height: 16),
                Text('Your cart is empty', style: tt.titleMedium),
                const SizedBox(height: 6),
                Text('Add items from the shop',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          );
        }

        final total =
            state.cartItems.fold<double>(0, (s, i) => s + i.displayPrice);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                itemCount: state.cartItems.length,
                itemBuilder: (_, i) {
                  final item = state.cartItems[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 56,
                                height: 56,
                                color: cs.surfaceContainerHighest,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    style: tt.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(
                                    '\$${item.displayPrice.toStringAsFixed(0)}',
                                    style: tt.labelLarge
                                        ?.copyWith(color: cs.primary)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: cs.error),
                            onPressed: () => context
                                .read<FurnitureBloc>()
                                .add(RemoveFromCart(item.id)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(
                    top: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.5))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total',
                          style: tt.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant)),
                      Text('\$${total.toStringAsFixed(0)}',
                          style: tt.titleLarge?.copyWith(color: cs.primary)),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    ),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Checkout'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
