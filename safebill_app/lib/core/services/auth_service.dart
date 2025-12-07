import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../config.dart';

class AuthService {
  AuthService({
    required this.apiClient,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email', 'profile'],
              serverClientId: '146985730052-sbe8qrioitqv6uq15lfej979457i6q82.apps.googleusercontent.com',
            );

  final SafeBillApiClient apiClient;
  final GoogleSignIn _googleSignIn;

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

  // Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return AuthResult.error('Sign in cancelled');
      }

      // Get authentication details
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return AuthResult.error('Failed to get ID token');
      }

      // Send to backend for verification and token generation
      final response = await apiClient.post('/auth/google/mobile', data: {
        'idToken': idToken,
        'accessToken': accessToken,
      });

      if (response.statusCode == 200 && response.data['ok'] == true) {
        final token = response.data['token'] as String;
        final user = response.data['user'] as Map<String, dynamic>;

        // Store token and user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userIdKey, user['userId'] as String);
        await prefs.setString(_userEmailKey, user['email'] as String);

        return AuthResult.success(
          token: token,
          userId: user['userId'] as String,
          email: user['email'] as String,
          name: user['name'] as String?,
          picture: user['picture'] as String?,
        );
      } else {
        return AuthResult.error(response.data['error'] ?? 'Authentication failed');
      }
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }

  // Get stored token
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored user ID
  Future<String?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Check if user is signed in
  Future<bool> isSignedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  // Verify token with backend
  Future<bool> verifyToken(String token) async {
    try {
      final response = await apiClient.post('/auth/verify', data: {
        'token': token,
      });

      return response.statusCode == 200 && response.data['ok'] == true;
    } catch (e) {
      return false;
    }
  }
}

class AuthResult {
  final bool success;
  final String? error;
  final String? token;
  final String? userId;
  final String? email;
  final String? name;
  final String? picture;

  AuthResult.success({
    required this.token,
    required this.userId,
    required this.email,
    this.name,
    this.picture,
  })  : success = true,
        error = null;

  AuthResult.error(this.error)
      : success = false,
        token = null,
        userId = null,
        email = null,
        name = null,
        picture = null;
}
