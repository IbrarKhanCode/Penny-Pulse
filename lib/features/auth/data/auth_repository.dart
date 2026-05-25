import 'models/auth_user.dart';
import 'models/profile_response.dart';
import 'models/signup_response.dart';

abstract class AuthRepository {
  Future<SignupResponse> signup({required String email, required String password});

  Future<AuthUser> login({required String email, required String password});

  Future<ProfileResponse> profile();

  Future<void> logout();
}
