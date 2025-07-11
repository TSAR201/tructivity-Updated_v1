// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// String fontFamily = 'Poppins';
// Color darkTextColor = Colors.grey[400]!;
// Color darkIconColor = Colors.grey[300]!;
// Color primaryDarkColor = Color(0xff201a30);
// Color secondaryDarkColor = Color(0xff38304c);

// class ThemeProvider with ChangeNotifier {
//   late ThemeData _themeData;
//   ThemeProvider({required bool isDark}) {
//     _themeData = isDark ? dark : light;
//   }
//   ThemeData light = ThemeData.light().copyWith(
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.white,
//       titleTextStyle: TextStyle(
//         color: Colors.black,
//         fontFamily: fontFamily,
//       ),
//       actionsIconTheme: IconThemeData(color: Colors.black),
//       iconTheme: IconThemeData(color: Colors.black),
//     ),
//     textTheme: TextTheme(
//       bodyText1: TextStyle(
//         color: Colors.black87,
//         fontFamily: fontFamily,
//       ),
//       bodyText2: TextStyle(
//         color: Colors.black87,
//         fontFamily: fontFamily,
//       ),
//       subtitle1: TextStyle(
//         color: Colors.black87,
//         fontFamily: fontFamily,
//       ),
//       headline6: TextStyle(
//         color: Colors.black87,
//         fontFamily: fontFamily,
//       ),
//     ),
//     cardColor: Colors.grey[300],
//     floatingActionButtonTheme:
//         FloatingActionButtonThemeData(backgroundColor: Colors.teal),
//     colorScheme: ColorScheme.light().copyWith(
//       secondary: Colors.teal,
//       primary: Colors.teal,
//     ),
//     scaffoldBackgroundColor: Colors.white,
//   );

//   ThemeData dark = ThemeData.dark().copyWith(
//     backgroundColor: primaryDarkColor,
//     canvasColor: primaryDarkColor,
//     appBarTheme: AppBarTheme(
//       backgroundColor: primaryDarkColor,
//       titleTextStyle: TextStyle(
//         color: darkTextColor,
//         fontFamily: fontFamily,
//       ),
//       actionsIconTheme: IconThemeData(color: Colors.grey[400]),
//       iconTheme: IconThemeData(
//         color: darkIconColor,
//       ),
//     ),
//     cardColor: secondaryDarkColor,
//     textTheme: TextTheme(
//       bodyText1: TextStyle(
//         color: darkTextColor,
//         fontFamily: fontFamily,
//       ),
//       bodyText2: TextStyle(
//         color: darkTextColor,
//         fontFamily: fontFamily,
//       ),
//       subtitle1: TextStyle(
//         color: darkTextColor,
//         fontFamily: fontFamily,
//       ),
//     ),
//     iconTheme: IconThemeData(color: darkIconColor),
//     bottomNavigationBarTheme:
//         BottomNavigationBarThemeData(backgroundColor: Colors.black),
//     scaffoldBackgroundColor: primaryDarkColor,
//     dialogBackgroundColor: primaryDarkColor,
//     floatingActionButtonTheme:
//         FloatingActionButtonThemeData(backgroundColor: Colors.teal),
//     colorScheme: ColorScheme.dark().copyWith(
//       secondary: Colors.teal,
//       primary: Colors.teal,
//     ),
//   );
//   ThemeData get getTheme => _themeData;
//   swapTheme() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (_themeData == dark) {
//       _themeData = light;
//       prefs.setBool('isDark', false);
//     } else {
//       _themeData = dark;
//       prefs.setBool('isDark', true);
//     }

//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String fontFamily = 'Poppins';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  ThemeProvider({required bool isDark}) {
    _themeData = isDark ? dark : light;
  }
  ThemeData light = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: fontFamily,
      ),
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(
                fontFamily: fontFamily, fontWeight: FontWeight.w500)))),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black87,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontFamily: fontFamily,
      ),
      titleMedium: TextStyle(
        color: Colors.black87,
        fontFamily: fontFamily,
      ),
      titleLarge: TextStyle(
        color: Colors.black87,
        fontFamily: fontFamily,
      ),
    ),
    cardColor: Colors.grey[300],
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.teal),
    colorScheme: ColorScheme.light().copyWith(
      secondary: Colors.teal,
      primary: Colors.teal,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData dark = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      titleTextStyle: TextStyle(
        color: Colors.grey[400],
        fontFamily: fontFamily,
      ),
      actionsIconTheme: IconThemeData(color: Colors.grey[400]),
      iconTheme: IconThemeData(
        color: Colors.grey[300],
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(
                fontFamily: fontFamily, fontWeight: FontWeight.w500)))),
    cardColor: Colors.black,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.grey[400],
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        color: Colors.grey[400],
        fontFamily: fontFamily,
      ),
      titleMedium: TextStyle(
        color: Colors.grey[400],
        fontFamily: fontFamily,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey[400]),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.grey[800]),
    scaffoldBackgroundColor: Colors.grey[900],
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.teal),
    colorScheme: ColorScheme.dark().copyWith(
      secondary: Colors.teal,
      primary: Colors.teal,
    ),
    dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),
  );
  ThemeData get getTheme => _themeData;
  swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeData == dark) {
      _themeData = light;
      prefs.setBool('isDark', false);
    } else {
      _themeData = dark;
      prefs.setBool('isDark', true);
    }

    notifyListeners();
  }
}
