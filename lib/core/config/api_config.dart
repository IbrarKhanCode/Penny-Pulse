import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiConfig {
  const ApiConfig({required this.baseUrl});

  final String baseUrl;
}

final apiConfigProvider = Provider<ApiConfig>((ref) {
  // Dev: use 10.0.2.2 for Android emulator, or your machine's LAN IP
  return const ApiConfig(
    // baseUrl: 'https://ibrarflutter-penny-pulse-api.hf.space'
     baseUrl: 'https://user-euphemism-thinner.ngrok-free.dev'
    );
});
