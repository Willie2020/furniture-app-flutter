import 'package:flutter/material.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Addresses', style: tt.titleLarge),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_outlined,
                    size: 44, color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Text('No saved addresses', style: tt.titleMedium),
              const SizedBox(height: 6),
              Text(
                'Add a delivery address for faster checkout',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.add_location_outlined),
                label: const Text('Add Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
