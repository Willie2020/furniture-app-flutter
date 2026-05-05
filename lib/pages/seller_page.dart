import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/furniture/furniture_bloc.dart';
import '../blocs/furniture/furniture_event.dart';
import '../blocs/furniture/furniture_state.dart';
import '../models/furniture_item.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  // ── Add / Edit form controllers ──
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _imageCtrl =
      TextEditingController(text: 'https://place-hold.it/300x200');
  final _descCtrl = TextEditingController();
  final _materialsCtrl = TextEditingController();
  final _dimensionsCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '10');
  String _category = 'Sofa';
  double _rating = 4.0;
  String _color = 'Natural';

  // Editing state
  int? _editingId;

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
  final _colorOptions = [
    'Natural',
    'White',
    'Black',
    'Brown',
    'Gray',
    'Blue',
    'Green',
    'Red'
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _salePriceCtrl.dispose();
    _imageCtrl.dispose();
    _descCtrl.dispose();
    _materialsCtrl.dispose();
    _dimensionsCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _priceCtrl.clear();
    _salePriceCtrl.clear();
    _imageCtrl.text = 'https://place-hold.it/300x200';
    _descCtrl.clear();
    _materialsCtrl.clear();
    _dimensionsCtrl.clear();
    _stockCtrl.text = '10';
    setState(() {
      _category = 'Sofa';
      _rating = 4.0;
      _color = 'Natural';
      _editingId = null;
    });
  }

  void _populateForEdit(FurnitureItem item) {
    _editingId = item.id;
    _nameCtrl.text = item.name;
    _priceCtrl.text = item.price.toStringAsFixed(0);
    _salePriceCtrl.text = item.salePrice?.toStringAsFixed(0) ?? '';
    _imageCtrl.text = item.image;
    _descCtrl.text = item.description;
    _materialsCtrl.text = item.materials ?? '';
    _dimensionsCtrl.text = item.dimensions ?? '';
    _stockCtrl.text = item.stockQuantity.toString();
    setState(() {
      _category = item.category;
      _rating = item.rating;
      _color = item.color ?? 'Natural';
    });
    _tabCtrl.animateTo(1); // Switch to Add/Edit tab
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<FurnitureBloc>();
    final price = double.parse(_priceCtrl.text.trim());
    final salePrice = _salePriceCtrl.text.trim().isNotEmpty
        ? double.tryParse(_salePriceCtrl.text.trim())
        : null;
    final stock = int.tryParse(_stockCtrl.text.trim()) ?? 10;

    if (_editingId != null) {
      bloc.add(UpdateProduct(
        itemId: _editingId!,
        name: _nameCtrl.text.trim(),
        price: price,
        salePrice: salePrice,
        clearSalePrice: _salePriceCtrl.text.trim().isEmpty,
        image: _imageCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        rating: _rating,
        stockQuantity: stock,
        materials: _materialsCtrl.text.trim().isNotEmpty
            ? _materialsCtrl.text.trim()
            : null,
        dimensions: _dimensionsCtrl.text.trim().isNotEmpty
            ? _dimensionsCtrl.text.trim()
            : null,
        color: _color,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_nameCtrl.text} updated!')),
      );
    } else {
      bloc.add(AddNewProduct(
        name: _nameCtrl.text.trim(),
        price: price,
        salePrice: salePrice,
        image: _imageCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        rating: _rating,
        stockQuantity: stock,
        materials: _materialsCtrl.text.trim().isNotEmpty
            ? _materialsCtrl.text.trim()
            : null,
        dimensions: _dimensionsCtrl.text.trim().isNotEmpty
            ? _dimensionsCtrl.text.trim()
            : null,
        color: _color,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_nameCtrl.text} added to shop!')),
      );
    }
    _clearForm();
  }

  void _deleteProduct(int id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        bottom: TabBar(
          controller: _tabCtrl,
          // Ensure unselected tabs keep enough contrast on the primary
          // background by using onPrimary at full opacity for the indicator
          // and a slightly higher opacity for unselected labels.
          indicatorColor: cs.onPrimary,
          labelColor: cs.onPrimary,
          unselectedLabelColor: cs.onPrimary.withValues(alpha: 0.8),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.add_circle), text: 'Add / Edit'),
            Tab(icon: Icon(Icons.list_alt), text: 'My Products'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildDashboardTab(cs, tt),
          _buildAddEditTab(cs, tt),
          _buildProductsTab(cs, tt),
        ],
      ),
    );
  }

  // ── Tab 0: Dashboard ─────────────────────────────────────────
  Widget _buildDashboardTab(ColorScheme cs, TextTheme tt) {
    return BlocBuilder<FurnitureBloc, FurnitureState>(
      builder: (_, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.storefront_rounded,
                        size: 52, color: cs.onPrimary),
                    const SizedBox(height: 12),
                    Text('Your Store',
                        style:
                            tt.headlineMedium?.copyWith(color: cs.onPrimary)),
                    const SizedBox(height: 4),
                    Text(
                      'Manage inventory, track sales, and grow your business',
                      style: tt.bodySmall?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.7)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stat cards grid
              Text('Quick Stats', style: tt.titleMedium),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _statCard(cs, tt, Icons.inventory_2, 'Total Products',
                      '${state.totalProducts}', cs.primary),
                  _statCard(cs, tt, Icons.check_circle, 'Active',
                      '${state.activeProductCount}', cs.tertiary),
                  _statCard(cs, tt, Icons.sell, 'On Sale',
                      '${state.onSaleCount}', cs.tertiaryContainer,
                      iconColor: cs.onTertiaryContainer),
                  _statCard(cs, tt, Icons.inventory, 'Low Stock',
                      '${state.lowStockCount}', cs.secondaryContainer,
                      iconColor: cs.onSecondaryContainer),
                  _statCard(cs, tt, Icons.error_outline, 'Out of Stock',
                      '${state.outOfStockCount}', cs.error),
                  _statCard(
                      cs,
                      tt,
                      Icons.account_balance_wallet,
                      'Inventory Value',
                      '\$${state.totalInventoryValue.toStringAsFixed(0)}',
                      cs.primaryContainer,
                      iconColor: cs.onPrimaryContainer),
                ],
              ),

              const SizedBox(height: 24),
              Text('Quick Actions', style: tt.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      cs,
                      tt,
                      Icons.add_circle_outline,
                      'Add Product',
                      'List a new item',
                      () {
                        _clearForm();
                        _tabCtrl.animateTo(1);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      cs,
                      tt,
                      Icons.list_alt_outlined,
                      'View Products',
                      'Manage your listings',
                      () => _tabCtrl.animateTo(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(ColorScheme cs, TextTheme tt, IconData icon, String label,
      String value, Color accent,
      {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? accent, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _actionCard(ColorScheme cs, TextTheme tt, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: cs.primary, size: 28),
            const SizedBox(height: 8),
            Text(title, style: tt.titleSmall),
            const SizedBox(height: 2),
            Text(subtitle,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  // ── Tab 1: Add / Edit ────────────────────────────────────────
  Widget _buildAddEditTab(ColorScheme cs, TextTheme tt) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section: Basic info
            _sectionHeader(tt, Icons.info_outline,
                _editingId != null ? 'Edit Product' : 'New Product'),
            const SizedBox(height: 12),

            Text('Product Name *', style: tt.titleSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                  hintText: 'e.g. Scandinavian Armchair',
                  prefixIcon: Icon(Icons.chair)),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Price row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Regular Price (\$) *', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: '299',
                            prefixIcon: Icon(Icons.attach_money)),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (double.tryParse(v.trim()) == null) {
                            return 'Enter a number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sale Price (\$)', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _salePriceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: '249', prefixIcon: Icon(Icons.discount)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category & Color
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category *', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _category,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category)),
                        items: _categories
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Color', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _color,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.palette)),
                        items: _colorOptions
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _color = v!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rating & Stock
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stock', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _stockCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: '10',
                            prefixIcon: Icon(Icons.inventory_2)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section: Details
            _sectionHeader(tt, Icons.description_outlined, 'Product Details'),
            const SizedBox(height: 12),

            Text('Description *', style: tt.titleSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: 'Describe the product...',
                  prefixIcon: Icon(Icons.description)),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            Text('Materials', style: tt.titleSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _materialsCtrl,
              decoration: const InputDecoration(
                  hintText: 'e.g. Solid oak, velvet upholstery',
                  prefixIcon: Icon(Icons.texture)),
            ),
            const SizedBox(height: 16),

            Text('Dimensions', style: tt.titleSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _dimensionsCtrl,
              decoration: const InputDecoration(
                  hintText: 'e.g. 80 × 90 × 100 cm',
                  prefixIcon: Icon(Icons.straighten)),
            ),
            const SizedBox(height: 24),

            // Section: Image
            _sectionHeader(tt, Icons.image_outlined, 'Product Image'),
            const SizedBox(height: 12),

            Text('Image URL *', style: tt.titleSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _imageCtrl,
              decoration: const InputDecoration(
                  hintText: 'https://...', prefixIcon: Icon(Icons.link)),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
              onChanged: (_) => setState(() {}),
            ),
            if (_imageCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  _imageCtrl.text,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.broken_image,
                        size: 48, color: cs.onSurfaceVariant),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Submit button
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(_editingId != null ? Icons.save : Icons.rocket_launch),
              label:
                  Text(_editingId != null ? 'Save Changes' : 'Publish Product'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54)),
            ),
            if (_editingId != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _clearForm,
                child: const Text('Cancel Editing'),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(TextTheme tt, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: tt.titleMedium),
      ],
    );
  }

  // ── Tab 2: My Products ───────────────────────────────────────
  Widget _buildProductsTab(ColorScheme cs, TextTheme tt) {
    return BlocBuilder<FurnitureBloc, FurnitureState>(
      builder: (_, state) {
        final products = state.items;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 72, color: cs.onSurfaceVariant),
                const SizedBox(height: 16),
                Text('No products yet', style: tt.titleMedium),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => _tabCtrl.animateTo(1),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Your First Product'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Search / filter bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${products.length} products',
                        style: tt.titleMedium),
                  ),
                  Text('${state.activeProductCount} active',
                      style:
                          tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return _productListTile(cs, tt, p);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _productListTile(ColorScheme cs, TextTheme tt, FurnitureItem p) {
    final bool isInactive = !p.isActive;
    final bool lowStock = p.stockQuantity <= 5 && p.stockQuantity > 0;
    final bool outOfStock = p.stockQuantity == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Opacity(
                opacity: isInactive ? 0.4 : 1.0,
                child: Image.network(
                  p.image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: cs.surfaceContainerHighest,
                    child: Icon(Icons.image_not_supported,
                        color: cs.onSurfaceVariant),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: tt.titleSmall?.copyWith(
                            color: isInactive ? cs.onSurfaceVariant : null,
                            decoration:
                                isInactive ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (p.isOnSale)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color:
                                  cs.tertiaryContainer.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text('-${p.discountPercent}%',
                              style: tt.labelSmall
                                  ?.copyWith(color: cs.onTertiaryContainer)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (p.isOnSale) ...[
                        Text('\$${p.salePrice!.toStringAsFixed(0)}',
                            style: tt.labelLarge?.copyWith(color: cs.primary)),
                        const SizedBox(width: 6),
                        Text('\$${p.price.toStringAsFixed(0)}',
                            style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                decoration: TextDecoration.lineThrough)),
                      ] else ...[
                        Text('\$${p.price.toStringAsFixed(0)}',
                            style: tt.labelLarge?.copyWith(color: cs.primary)),
                      ],
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(p.category,
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ),
                      if (outOfStock) ...[
                        const SizedBox(width: 6),
                        Text('Out of stock',
                            style: tt.bodySmall?.copyWith(color: cs.error)),
                      ] else if (lowStock) ...[
                        const SizedBox(width: 6),
                        Text('${p.stockQuantity} left',
                            style: tt.bodySmall?.copyWith(color: cs.error)),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: cs.onSurfaceVariant),
              onSelected: (action) {
                switch (action) {
                  case 'edit':
                    _populateForEdit(p);
                    break;
                  case 'duplicate':
                    context.read<FurnitureBloc>().add(DuplicateProduct(p.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${p.name} duplicated!')),
                    );
                    break;
                  case 'toggle':
                    context
                        .read<FurnitureBloc>()
                        .add(ToggleProductActive(p.id));
                    break;
                  case 'delete':
                    _deleteProduct(p.id, p.name);
                    break;
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'edit', child: _PopupItem(Icons.edit, 'Edit')),
                const PopupMenuItem(
                    value: 'duplicate',
                    child: _PopupItem(Icons.content_copy, 'Duplicate')),
                PopupMenuItem(
                  value: 'toggle',
                  child: _PopupItem(
                    p.isActive ? Icons.visibility_off : Icons.visibility,
                    p.isActive ? 'Deactivate' : 'Activate',
                  ),
                ),
                const PopupMenuItem(
                    value: 'delete',
                    child: _PopupItem(Icons.delete_outline, 'Delete',
                        isDestructive: true)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Small helper for popup menu items
class _PopupItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _PopupItem(this.icon, this.label, {this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = isDestructive ? cs.error : null;
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
