import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../config.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = SafeBillApiClient(baseUrl: AppConfig.apiBaseUrl);
  return AuthService(apiClient: apiClient);
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? userId;
  final String? email;
  final String? name;
  final String? picture;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userId,
    this.email,
    this.name,
    this.picture,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? userId,
    String? email,
    String? name,
    String? picture,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      error: error,
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(AuthState()) {
    _checkAuthStatus();
  }

  final AuthService _authService;

  Future<void> _checkAuthStatus() async {
    final isSignedIn = await _authService.isSignedIn();
    if (isSignedIn) {
      final userId = await _authService.getStoredUserId();
      state = state.copyWith(
        isAuthenticated: true,
        userId: userId,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.signInWithGoogle();

    if (result.success) {
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: result.userId,
        email: result.email,
        name: result.name,
        picture: result.picture,
        error: null,
      );
    } else {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: result.error,
      );
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState();
  }
}

