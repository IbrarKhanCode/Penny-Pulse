import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/expenses/data/models/expense.dart';
import '../features/expenses/presentation/screens/add_expense_screen.dart';
import '../features/expenses/presentation/screens/expense_detail_screen.dart';
import 'main_shell_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // ── Splash ───────────────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // ── Authentication Routes ─────────────────────────────────────────────
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // ── Main shell (Dashboard / Analytics / Transactions tabs) ────────────
    GoRoute(path: '/', builder: (context, state) => const MainShellScreen()),
    // ── Pushed over the shell ─────────────────────────────────────────────
    GoRoute(
      path: '/add-expense',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final expense = state.extra as Expense?;
        if (expense == null) return const MainShellScreen();
        return ExpenseDetailScreen(expense: expense);
      },
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) {
  return appRouter;
});
