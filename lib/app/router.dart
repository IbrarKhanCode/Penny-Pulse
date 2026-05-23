import 'package:go_router/go_router.dart';

import '../features/expenses/data/models/expense.dart';
import '../features/expenses/presentation/screens/add_expense_screen.dart';
import '../features/expenses/presentation/screens/expense_detail_screen.dart';
import 'main_shell_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
