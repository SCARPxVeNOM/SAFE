import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, AsyncValue<bool>>(
  (ref) => OnboardingController(),
);

class OnboardingController extends StateNotifier<AsyncValue<bool>> {
  OnboardingController() : super(const AsyncValue.loading()) {
    _load();
  }

  static const _prefKey = 'onboardingComplete';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool(_prefKey) ?? false;
      state = AsyncValue.data(completed);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    state = const AsyncValue.data(true);
  }
}

