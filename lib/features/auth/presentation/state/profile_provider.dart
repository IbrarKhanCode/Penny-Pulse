import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository_impl.dart';
import '../../data/models/profile_response.dart';

final profileProvider = FutureProvider<ProfileResponse>((ref) async {
  return ref.watch(authRepositoryProvider).profile();
});
