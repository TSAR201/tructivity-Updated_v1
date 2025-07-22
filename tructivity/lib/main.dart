import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:tructivity/theme/theme.dart';
import 'package:tructivity/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  initializeNotificationChannel();
  runApp(
    ChangeNotifierProvider(
        child: MyApp(),
        create: (_) {
          bool? isDark = prefs.getBool('isDark');
          if (isDark == null) {
            isDark = false;
            prefs.setBool('isDark', false);
          }
          return ThemeProvider(isDark: isDark);
        }),
  );
}

void initializeNotificationChannel() {
  AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
      ///ff_log channel description added, mandatory in updated package
      channelDescription: "Notification",
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      // defaultColor: Colors.blue,
      defaultColor: Colors.transparent,
      ledColor: Colors.transparent,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      enableVibration: true,
    ),
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvder, child) {
        return MaterialApp(
          theme: Provider.of<ThemeProvider>(context, listen: false).getTheme,
          debugShowCheckedModeBanner: false,
          title: 'Tructivity',
          initialRoute: '/',
          routes: {
            '/': (context) => Wrapper(),
          },
        );
      },
    );
  }
}
