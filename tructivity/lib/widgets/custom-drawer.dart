import 'package:tructivity/constants.dart';
import 'package:tructivity/models/drawer-item-model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final int initialIndex;
  final onItemClick;
  final onSwipe;
  CustomDrawer(
      {required Key key,
      required this.onItemClick,
      required this.onSwipe,
      required this.initialIndex})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    getData();
    selected = widget.initialIndex;
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

  int? selected;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: prefs == null ? null : Column(children: displayDrawerTiles()),
        ),
      ),
    );
  }

  List<Widget> displayDrawerTiles() {
    List<Widget> tiles = [];
    for (DrawerItemModel item in drawerItems) {
      Widget tile = drawerTile(
          text: item.text, iconData: item.iconData, index: item.index);
      if (prefs!.getBool(item.index.toString()) == true) {
        tiles.add(tile);
      }
    }
    return tiles;
  }

  Widget drawerTile(
      {required String text, required IconData iconData, required int index}) {
    bool isSelected = selected == index;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 5, left: 15, right: 15),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Theme.of(context).scaffoldBackgroundColor : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              iconData,
              color: isSelected ? Colors.teal : null,
              size: 22,
            ),
            SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? Colors.teal : null,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        widget.onItemClick(index);
        selected = index;
      },
      onPanUpdate: (details) {
        if (details.delta.dx < 0) {
          widget.onSwipe();
        }
      },
    );
  }

  void changeSelected(int i) {
    selected = i;
  }

  void refreshDrawer() {
    setState(() {});
  }
}
