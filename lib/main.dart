import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/furniture/furniture_bloc.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'styles/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => FurnitureBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Furniture Gallery',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (_) => const HomePage(),
          '/auth': (_) => const AuthPage(),
        },
      ),
    );
  }
}
