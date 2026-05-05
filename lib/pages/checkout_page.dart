import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  String _paymentMethod = 'Credit Card';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<FurnitureBloc, FurnitureState>(
      builder: (_, state) {
        final cartItems = state.cartItems;
        if (cartItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: cs.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: tt.titleMedium),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Shop'),
                  ),
                ],
              ),
            ),
          );
        }

        final subtotal =
            cartItems.fold<double>(0, (s, i) => s + i.displayPrice);
        final shipping = 29.99;
        final tax = subtotal * 0.08;
        final total = subtotal + shipping + tax;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep += 1);
                    } else {
                      _placeOrder(cartItems);
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    }
                  },
                  controlsBuilder: (_, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: Text(
                                _currentStep == 2 ? 'Place Order' : 'Continue'),
                          ),
                          if (_currentStep > 0) ...[
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: Text('Shipping Address', style: tt.titleSmall),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _addressCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Street Address',
                              prefixIcon: Icon(Icons.home_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cityCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'City',
                                    prefixIcon:
                                        Icon(Icons.location_city_outlined),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 120,
                                child: TextFormField(
                                  controller: _zipCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'ZIP Code',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: Text('Payment Method', style: tt.titleSmall),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          ...[
                            'Credit Card',
                            'PayPal',
                            'Apple Pay'
                          ].map((method) => RadioListTile<String>(
                                title: Text(method),
                                value: method,
                                groupValue: _paymentMethod,
                                onChanged: (v) =>
                                    setState(() => _paymentMethod = v!),
                                contentPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                          if (_paymentMethod == 'Credit Card') ...[
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Card Number',
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'MM/YY'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    decoration:
                                        const InputDecoration(labelText: 'CVV'),
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Step(
                      title: Text('Order Summary', style: tt.titleSmall),
                      isActive: _currentStep >= 2,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...cartItems.map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.image,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 40,
                                          height: 40,
                                          color: cs.surfaceContainerHighest,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(item.name,
                                          style: tt.bodyMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                        '\$${item.displayPrice.toStringAsFixed(0)}',
                                        style: tt.labelLarge),
                                  ],
                                ),
                              )),
                          const Divider(height: 24),
                          _summaryRow(tt, 'Subtotal',
                              '\$${subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 4),
                          _summaryRow(tt, 'Shipping',
                              '\$${shipping.toStringAsFixed(2)}'),
                          const SizedBox(height: 4),
                          _summaryRow(
                              tt, 'Tax (8%)', '\$${tax.toStringAsFixed(2)}'),
                          const Divider(height: 16),
                          _summaryRow(
                              tt, 'Total', '\$${total.toStringAsFixed(2)}',
                              isTotal: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom total bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  border: Border(
                      top: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.3))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${cartItems.length} item(s)',
                        style:
                            tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: tt.titleLarge?.copyWith(
                            color: cs.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _placeOrder(List items) {
    // Clear cart items
    for (final item in items) {
      context.read<FurnitureBloc>().add(RemoveFromCart(item.id));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Order placed successfully! 🎉'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
    Navigator.pop(context);
  }

  Widget _summaryRow(TextTheme tt, String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isTotal ? tt.titleMedium : tt.bodyMedium,
            textAlign: TextAlign.start),
        Text(value,
            style: (isTotal ? tt.titleMedium : tt.bodyMedium)?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.end),
      ],
    );
  }
}
