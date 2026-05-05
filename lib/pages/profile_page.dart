import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../services/auth_database.dart';
import 'addresses_page.dart';
import 'orders_page.dart';
import 'seller_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final state = context.read<AuthBloc>().state;
    if (state.email != null) {
      final name = await AuthDatabase.instance.getUserName(state.email!);
      if (mounted) setState(() => _userName = name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state) {
        final loggedIn = state.status == AuthStatus.authenticated;
        final displayName = _userName?.isNotEmpty == true
            ? _userName!
            : (state.email ?? 'User');

        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: loggedIn
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    child: Icon(
                      loggedIn ? Icons.person : Icons.person_outline,
                      size: 44,
                      color: loggedIn
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loggedIn ? displayName : 'Welcome',
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loggedIn
                        ? 'Enjoy browsing our collection'
                        : 'Sign in to access your profile',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  if (loggedIn) ...[
                    _tile(
                      Icons.storefront,
                      'Seller Dashboard',
                      cs: cs,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SellerPage())),
                    ),
                    _tile(
                      Icons.shopping_bag_outlined,
                      'My Orders',
                      cs: cs,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const OrdersPage())),
                    ),
                    _tile(
                      Icons.favorite_border,
                      'Wishlist',
                      cs: cs,
                      onTap: () {
                        // Wishlist is already accessible from bottom nav
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Wishlist is on the bottom navigation bar')),
                        );
                      },
                    ),
                    _tile(
                      Icons.location_on_outlined,
                      'Addresses',
                      cs: cs,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddressesPage())),
                    ),
                    _tile(
                      Icons.settings_outlined,
                      'Settings',
                      cs: cs,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsPage())),
                    ),
                    const SizedBox(height: 28),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.read<AuthBloc>().add(SignOutRequested()),
                      icon: Icon(Icons.logout, color: cs.error),
                      label:
                          Text('Sign Out', style: TextStyle(color: cs.error)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: BorderSide(color: cs.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ] else ...[
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/auth'),
                      icon: const Icon(Icons.login),
                      label: const Text('Sign In / Sign Up'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tile(
    IconData icon,
    String label, {
    required ColorScheme cs,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: cs.primary),
      title: Text(label),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
