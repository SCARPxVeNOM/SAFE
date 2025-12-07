import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';

/// Firebase Cloud Messaging Service
class FCMService {
  FCMService({
    required this.apiClient,
    FirebaseMessaging? firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  final SafeBillApiClient apiClient;
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _fcmTokenKey = 'fcm_token';

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    // Request notification permissions
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveToken(token);
        await _sendTokenToBackend(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _saveToken(newToken);
        _sendTokenToBackend(newToken);
      });

      // Configure local notifications for foreground messages
      await _configureLocalNotifications();

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages (when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    }
  }

  /// Configure local notifications for foreground messages
  Future<void> _configureLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'safebill_notifications',
      'SafeBill Notifications',
      description: 'Notifications for warranty reminders and updates',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Handle foreground messages (when app is open)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'SafeBill',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'safebill_notifications',
          'SafeBill Notifications',
          channelDescription: 'Notifications for warranty reminders',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Handle background messages (when app is in background)
  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle notification tap - navigate to relevant screen
    // This will be handled by the app router
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Navigate to relevant screen based on notification data
    // This can be enhanced with deep linking
  }

  /// Save FCM token locally
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
  }

  /// Get stored FCM token
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      await apiClient.post('/notifications/register', data: {
        'fcmToken': token,
      });
    } catch (e) {
      // Token registration failed - will retry later
      print('Failed to register FCM token: $e');
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print('Handling background message: ${message.messageId}');
}

