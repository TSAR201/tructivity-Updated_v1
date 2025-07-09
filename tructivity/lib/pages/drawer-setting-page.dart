import 'package:tructivity/constants.dart';
import 'package:tructivity/models/drawer-item-model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerSettingPage extends StatefulWidget {
  @override
  _DrawerSettingPageState createState() => _DrawerSettingPageState();
}

class _DrawerSettingPageState extends State<DrawerSettingPage> {
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    for (DrawerItemModel item in drawerItems) {
      String key = item.index.toString();
      if (prefs!.getBool(key) == null) {
        prefs!.setBool(key, true);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Page Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: prefs == null ? [] : displayOptions(),
      ),
    );
  }

  List<ListTile> displayOptions() {
    List<ListTile> tiles = [];
    for (DrawerItemModel item in drawerItems) {
      String title = item.text;
      if (title != 'Settings') {
        String key = item.index.toString();
        bool showItem = prefs!.getBool(key)!;
        tiles.add(getTile(showItem: showItem, text: title, key: key));
      }
    }
    return tiles;
  }

  ListTile getTile(
      {required bool showItem, required String text, required String key}) {
    return ListTile(
      leading: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      trailing: Switch.adaptive(
        value: showItem,
        thumbColor: MaterialStateProperty.all(Colors.teal),
        activeTrackColor: Colors.teal,
        inactiveTrackColor: Colors.grey[300],
        inactiveThumbColor: Colors.white,
        onChanged: (value) {
          showItem = value;
          prefs!.setBool(key, value);
          setState(() {});
        },
      ),
    );
  }
}
