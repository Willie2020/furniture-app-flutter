import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/social_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showSocialSnackBar(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider sign-in coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primary, cs.tertiary],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.isSignInMode
                          ? 'Signed in!'
                          : 'Account created!'),
                      backgroundColor: cs.tertiary,
                    ),
                  );
                  Navigator.pop(context);
                } else if (state.status == AuthStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Error'),
                      backgroundColor: cs.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isSignIn = state.isSignInMode;
                final loading = state.status == AuthStatus.loading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      isSignIn ? 'Welcome back' : 'Join us',
                      style: tt.headlineMedium?.copyWith(color: cs.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSignIn
                          ? 'Sign in to your account'
                          : 'Create an account to start',
                      style: tt.bodyMedium?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.7)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _field(
                        ctrl: _emailCtrl,
                        hint: 'Email',
                        icon: Icons.email_outlined),
                    const SizedBox(height: 14),
                    _field(
                      ctrl: _passCtrl,
                      hint: 'Password',
                      icon: Icons.lock_outlined,
                      hide: _hidePass,
                      suffix: IconButton(
                        icon: Icon(_hidePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() => _hidePass = !_hidePass),
                      ),
                    ),
                    if (!isSignIn) ...[
                      const SizedBox(height: 14),
                      _field(
                        ctrl: _confirmCtrl,
                        hint: 'Confirm password',
                        icon: Icons.lock_outlined,
                        hide: _hideConfirm,
                        suffix: IconButton(
                          icon: Icon(_hideConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: loading
                          ? null
                          : () {
                              final e = _emailCtrl.text.trim();
                              final p = _passCtrl.text.trim();
                              if (e.isEmpty || p.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Fill all fields')),
                                );
                                return;
                              }
                              if (!isSignIn && p != _confirmCtrl.text.trim()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Passwords do not match')),
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(isSignIn
                                  ? SignInRequested(email: e, password: p)
                                  : SignUpRequested(email: e, password: p));
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : Text(isSignIn ? 'Sign In' : 'Sign Up'),
                    ),
                    const SizedBox(height: 28),
                    Row(children: [
                      Expanded(
                          child: Divider(
                              color: cs.onPrimary.withValues(alpha: 0.3))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('or',
                            style: tt.bodySmall?.copyWith(
                                color: cs.onPrimary.withValues(alpha: 0.6))),
                      ),
                      Expanded(
                          child: Divider(
                              color: cs.onPrimary.withValues(alpha: 0.3))),
                    ]),
                    const SizedBox(height: 20),
                    SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        color: const Color(0xFFDB4437),
                        onTap: () => _showSocialSnackBar(context, 'Google')),
                    const SizedBox(height: 10),
                    SocialButton(
                        icon: Icons.apple,
                        label: 'Apple',
                        color: Colors.white,
                        onTap: () => _showSocialSnackBar(context, 'Apple')),
                    const SizedBox(height: 10),
                    SocialButton(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        onTap: () => _showSocialSnackBar(context, 'Facebook')),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSignIn ? "No account? " : "Have an account? ",
                          style: tt.bodySmall?.copyWith(
                              color: cs.onPrimary.withValues(alpha: 0.7)),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.read<AuthBloc>().add(ToggleAuthMode()),
                          child: Text(
                            isSignIn ? 'Sign Up' : 'Sign In',
                            style: tt.labelMedium?.copyWith(
                              color: cs.onPrimary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    bool hide = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: hide,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        hintStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
