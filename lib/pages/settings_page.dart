import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _section('Appearance', cs),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text('Switch between light and dark theme',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            value: false,
            onChanged: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dark mode coming soon! 🌙')),
              );
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const Divider(indent: 72),
          _section('Notifications', cs),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: Text('Get alerts for new deals and order updates',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            value: true,
            onChanged: (_) {},
            secondary: const Icon(Icons.notifications_outlined),
          ),
          SwitchListTile(
            title: const Text('Email Updates'),
            subtitle: Text('Receive weekly newsletter and promotions',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            value: false,
            onChanged: (_) {},
            secondary: const Icon(Icons.email_outlined),
          ),
          const Divider(indent: 72),
          _section('About', cs),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: Text('1.0.0',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms page coming soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy page coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _section(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: cs.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
