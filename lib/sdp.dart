import 'package:flutter/material.dart';
import 'package:mt_flutter/config.dart';
import 'package:mt_flutter/login.dart';
import 'package:mt_flutter/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MLApp());

class MLApp extends StatelessWidget {
  const MLApp({Key key, this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: '后台工具',

      debugShowCheckedModeBanner: false,
      theme: _buildRallyTheme(),
      // localizationsDelegates: GalleryLocalizations.localizationsDelegates,
      // supportedLocales: GalleryLocalizations.supportedLocales,P
      // locale: GalleryOptions.of(context).locale,
      // home: HomePage(),
      initialRoute: '/main',

      routes: <String, WidgetBuilder>{
        '/login': (context) => LoginPage(),
        '/main': (context) => HomePage(),
      },
    );
  }

  ThemeData _buildRallyTheme() {
    final base = ThemeData.dark();
    return ThemeData(
      scaffoldBackgroundColor: MLColors.primaryBackground,
      primaryColor: MLColors.primaryBackground,
      focusColor: MLColors.focusColor,
      textTheme: _buildRallyTextTheme(base.textTheme),
      cardColor: MLColors.primaryBackground,
      hoverColor: MLColors.gray25,
      selectedRowColor: MLColors.focusColor,
      toggleableActiveColor: MLColors.focusColor,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: MLColors.gray,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: MLColors.inputBackground,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  TextTheme _buildRallyTextTheme(TextTheme base) {
    return base
        .copyWith(
          body1: base.body1.copyWith(
            fontFamily: 'Roboto Condensed',
            fontSize: 1.4,
            fontWeight: FontWeight.w400,
          ),
          body2: GoogleFonts.eczar(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.4,
            textStyle: base.body2,
          ),
          button: base.button.copyWith(
            fontFamily: 'Roboto Condensed',
            fontWeight: FontWeight.w700,
            letterSpacing: 2.8,
          ),
          headline: GoogleFonts.eczar(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            textStyle: base.body2,
          ),
        )
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
  }
}
