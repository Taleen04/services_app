import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trasport_ai/src/core/database/cache/shared_pref_helper.dart';
import 'package:trasport_ai/src/feature/auth/data/data_sourse/auth_data_source.dart';
import 'package:trasport_ai/src/feature/auth/domain/usecase/login_usecase.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view/login_screen.dart';
import 'package:trasport_ai/src/feature/auth/presentation/view_model/bloc/log_in_bloc.dart';
import 'package:trasport_ai/src/feature/auth/repo/login_repo.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/view_model/bloc/bloc_nav_bar.dart';
import 'package:trasport_ai/src/feature/home/presentation/view/widget/main_screen.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view/terms_screen.dart';

// Router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/init',
    routes: [
      GoRoute(
        path: '/init',
        builder: (context, state) => const InitialScreen(),
      ),
      GoRoute(
        path: '/login',
        builder:
            (context, state) => BlocProvider(
              create: (_) => LogInBloc(LoginUseCase(LoginRepository(LoginDataSource()))),
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        path: '/home',
        builder:
            (context, state) => BlocProvider(
              create: (context) => NavBloc(),
              child: const MainScreen(),
            ),
      ),
      GoRoute(path: '/terms', builder: (context, state) => const TermsScreen()),
    ],
  );
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    final token = SharedPrefHelper.getString(StorageKeys.token);
    if (token.isNotEmpty && token != 'null') {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class StorageKeys {
  const StorageKeys._();
  static const String token = 'token';
  static const String language = 'Language';
}
