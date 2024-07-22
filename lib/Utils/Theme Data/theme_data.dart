import 'package:delivery/Utils/utils.dart';
import 'package:flutter/material.dart';

ThemeData comprehensiveThemeData = ThemeData(
  // Basic color properties
  primaryColor: Colors.blue,
  primaryColorLight: Colors.lightBlue,
  primaryColorDark: Colors.blue[800],
  hintColor: Colors.white60,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.grey[50],
  cardColor: Colors.white,
  dividerColor: Colors.grey,
  highlightColor: Colors.lightBlueAccent,
  splashColor: Colors.lightBlue,
  // selectedRowColor: Colors.blue[100],
  unselectedWidgetColor: Colors.grey,
  disabledColor: Colors.grey[300],
  // buttonColor: Colors.blue,
  secondaryHeaderColor: Colors.blue[100],
  dialogBackgroundColor: Colors.white,
  indicatorColor: Colors.blue,
  // hintColor: Colors.grey,

  // Typography
  // fontFamily: 'Georgia',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.black),
    displaySmall: TextStyle(
        fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineLarge: TextStyle(
        fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleLarge: TextStyle(
        fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    titleSmall: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black),
    bodyMedium: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
    bodySmall: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
    labelLarge: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
    labelMedium: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.black),
    labelSmall: TextStyle(
        fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.black),
  ),
  primaryTextTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white),
  ),

  // Icon themes
  iconTheme: const IconThemeData(
    color: Colors.white70,
    size: 24.0,
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.orange,
    size: 24.0,
  ),

  // Button themes
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: sec,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        minimumSize: const Size(350, 40)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: const BorderSide(color: Colors.blue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    fillColor: Colors.blue[100],
    selectedColor: Colors.blue,
    color: Colors.blue[700],
    borderColor: Colors.blue,
  ),

  // AppBar theme
  appBarTheme: AppBarTheme(
    color: m,
    iconTheme: const IconThemeData(color: Colors.white70),
    actionsIconTheme: const IconThemeData(color: Colors.white70),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(color: Colors.white70, fontSize: 20),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(color: Colors.white70, fontSize: 20),
    ).titleLarge,
  ),

  // BottomAppBar theme
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white70,
    shape: CircularNotchedRectangle(),
  ),

  // BottomNavigationBar theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white70,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey[300],
  ),

  // dd fl theme
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
  ),

  // FloatingActionButton theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),

  // Card theme
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[300],
    disabledColor: Colors.grey[100],
    selectedColor: Colors.blue[300],
    secondarySelectedColor: Colors.blue[100],
    padding: const EdgeInsets.all(4.0),
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
  ),

  // Dialog theme
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    titleTextStyle: const TextStyle(fontSize: 20, ),
    contentTextStyle: const TextStyle(fontSize: 16),
  ),

  // InputDecoration theme
  inputDecorationTheme: const InputDecorationTheme(

    iconColor: Colors.white70,
    suffixIconColor: Colors.white70,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Colors.red)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    labelStyle: TextStyle(color: Colors.white70),
  ),

  // Slider theme
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.blue,
    inactiveTrackColor: Colors.blue[100],
    thumbColor: Colors.blue,
    overlayColor: Colors.blue.withAlpha(32),
    valueIndicatorColor: Colors.blue,
  ),

  // SnackBar theme
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: m,
    contentTextStyle: TextStyle(color: Colors.white),
  ),

  // Tooltip theme
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.9),
      borderRadius: BorderRadius.circular(4),
    ),
    textStyle: const TextStyle(color: Colors.white),
  ),

  // PopupMenu theme
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
    textStyle: TextStyle(color: Colors.black),
  ),

  // PageTransitions theme
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),

  // BottomSheet theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
  ),

  // Divider theme
  dividerTheme: const DividerThemeData(
    color: Colors.black,
    space: 1,
    thickness: 1,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
    trackColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade100,
    secondary: Colors.grey.shade100,
    surface: Colors.grey.shade100,
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onError: Colors.black,
  ).copyWith(),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue,
    selectionColor: Colors.blue[200],
    selectionHandleColor: Colors.blue[700],
  ),
);
