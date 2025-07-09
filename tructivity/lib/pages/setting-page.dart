import 'package:tructivity/dialogs/battery-optimization-dialog.dart';
import 'package:tructivity/dialogs/semester-change-dialog.dart';
import 'package:tructivity/pages/drawer-setting-page.dart';
import 'package:tructivity/pages/register-page.dart';
import 'package:tructivity/pages/security-page.dart';
import 'package:tructivity/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool? _isDark;
  late SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    _prefs = await SharedPreferences.getInstance();
    _isDark = _prefs.getBool('isDark')!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(
          Icons.menu_outlined,
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Text(
              'Dark Mode',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            trailing: _isDark == null
                ? null
                : Switch.adaptive(
                    value: _isDark!,
                    thumbColor: MaterialStateProperty.all(Colors.teal),
                    activeTrackColor: Colors.teal,
                    inactiveTrackColor: Colors.grey[300],
                    inactiveThumbColor: Colors.white,
                    onChanged: (value) {
                      _isDark = value;
                      setState(() {});
                      ThemeProvider themeProvider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      themeProvider.swapTheme();
                    },
                  ),
          ),
          SettingTile(
            icon: Icons.pages_outlined,
            text: 'Page Settings',
            ontap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => DrawerSettingPage()));
            },
          ),
          SettingTile(
            icon: Icons.lock_outlined,
            text: 'Security',
            ontap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SecurityPage()));
            },
          ),
          SettingTile(
            icon: Icons.notifications_outlined,
            text: 'Enable Notification',
            ontap: () async {
              await showDialog(
                  context: context,
                  builder: (c) {
                    return BatteryOptimizationDialog();
                  });
            },
          ),
          SettingTile(
            icon: Icons.school_outlined,
            text: 'Select Semester',
            ontap: () async {
              await showDialog(
                  context: context,
                  builder: (c) {
                    return SemesterChangeDialog();
                  });
            },
          ),
          SettingTile(
              icon: Icons.send_outlined,
              text: 'Send Feedback',
              ontap: () async {
                final String url = 'mailto:contact@tructivity.com';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              }),
          SettingTile(
            icon: Icons.reviews_outlined,
            text: 'Write Review',
            ontap: () async {
              String url =
                  'https://play.google.com/store/apps/details?id=com.tructivity.tructivity';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          ),
          SettingTile(
            icon: Icons.payment_outlined,
            text: 'Pay and Upgrade',
            ontap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) {
                return RegisterPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final ontap;
  final String text;
  final IconData icon;
  final Color? iconColor;
  const SettingTile(
      {required this.ontap,
      required this.icon,
      required this.text,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      trailing: IconButton(
        onPressed: ontap,
        icon: Icon(
          icon,
          color: iconColor,
          size: 26,
        ),
      ),
    );
  }
}
