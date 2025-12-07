import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/api/api_client.dart';
import 'core/config.dart';
import 'core/local/local_document_store.dart';
import 'core/local/reminder_scheduler.dart';
import 'core/services/fcm_service.dart';

class AppBootstrap {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize Firebase (if configured)
    try {
      await Firebase.initializeApp();
      
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      
      // Initialize FCM service
      final apiClient = SafeBillApiClient(baseUrl: AppConfig.apiBaseUrl);
      final fcmService = FCMService(apiClient: apiClient);
      await fcmService.initialize();
    } catch (e) {
      // Firebase not configured - continue without push notifications
      print('Firebase not configured: $e');
    }

    // Initialize local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(initializationSettings);
    await LocalDocumentStore.instance.init();
    ReminderScheduler.instance.configure(_notifications);
  }
}

/// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}

