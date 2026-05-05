import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageCtrl =
      TextEditingController(text: 'https://place-hold.it/300x200');
  final _descCtrl = TextEditingController();
  String _category = 'Sofa';
  double _rating = 4.0;

  final _categories = [
    'Sofa',
    'Chair',
    'Table',
    'Bed',
    'Cabinet',
    'Desk',
    'Lighting',
    'Decor'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<FurnitureBloc>().add(AddNewProduct(
          name: _nameCtrl.text.trim(),
          price: double.parse(_priceCtrl.text.trim()),
          image: _imageCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          category: _category,
          rating: _rating,
        ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_nameCtrl.text} added to shop!')),
    );

    _nameCtrl.clear();
    _priceCtrl.clear();
    _imageCtrl.text = 'https://place-hold.it/300x200';
    _descCtrl.clear();
    setState(() {
      _category = 'Sofa';
      _rating = 4.0;
    });
  }

  void _deleteProduct(int id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Remove "$name" from the shop?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<FurnitureBloc>().add(DeleteProduct(id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"$name" removed')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Seller Dashboard', style: tt.titleLarge)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  Icon(Icons.storefront, size: 48, color: cs.onPrimary),
                  const SizedBox(height: 12),
                  Text('List Your Product',
                      style: tt.headlineMedium?.copyWith(color: cs.onPrimary)),
                  const SizedBox(height: 4),
                  Text(
                      'Fill in the details below to add your furniture to the shop',
                      style: tt.bodySmall?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.7)),
                      textAlign: TextAlign.center),
                ]),
              ),
              const SizedBox(height: 24),

              // Name
              Text('Product Name', style: tt.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                    hintText: 'e.g. Vintage Armchair',
                    prefixIcon: Icon(Icons.chair)),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Price
              Text('Price (\$)', style: tt.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'e.g. 299', prefixIcon: Icon(Icons.attach_money)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null)
                    return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category dropdown
              Text('Category', style: tt.titleSmall),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _category,
                decoration:
                    const InputDecoration(prefixIcon: Icon(Icons.category)),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),

              // Rating slider
              Text('Rating: ${_rating.toStringAsFixed(1)}',
                  style: tt.titleSmall),
              const SizedBox(height: 6),
              Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 10,
                label: _rating.toStringAsFixed(1),
                onChanged: (v) => setState(() => _rating = v),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('1', style: tt.bodySmall),
                Text('5', style: tt.bodySmall),
              ]),
              const SizedBox(height: 16),

              // Image URL
              Text('Image URL', style: tt.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(
                    hintText: 'https://...', prefixIcon: Icon(Icons.image)),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              // Preview
              if (_imageCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imageCtrl.text,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: cs.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Description
              Text('Description', style: tt.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: 'Describe your product...',
                    prefixIcon: Icon(Icons.description)),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              // Submit
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Publish Product'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54)),
              ),
              const SizedBox(height: 16),

              // My products section
              BlocBuilder<FurnitureBloc, FurnitureState>(
                builder: (_, state) {
                  // Products with ids beyond the sample data are user-added
                  final myProducts =
                      state.items.where((i) => i.id > 10).toList();
                  if (myProducts.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 32),
                      Text('My Listed Products (${myProducts.length})',
                          style: tt.titleMedium),
                      const SizedBox(height: 8),
                      ...myProducts.map((p) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(p.image,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                        Icons.image,
                                        color: cs.onSurfaceVariant)),
                              ),
                              title: Text(p.name, style: tt.titleSmall),
                              subtitle: Text(
                                  '\$${p.price.toStringAsFixed(0)} • ${p.category}',
                                  style: tt.bodySmall),
                              trailing: IconButton(
                                icon:
                                    Icon(Icons.delete_outline, color: cs.error),
                                onPressed: () => _deleteProduct(p.id, p.name),
                              ),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
