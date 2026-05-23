import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks which bottom-nav tab is currently visible in [MainShellScreen].
/// 0 = Home, 1 = Activity (Transactions), 2 = Budget (Analytics)
final shellTabProvider = StateProvider<int>((ref) => 0);
