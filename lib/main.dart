import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core package
import 'package:flutter_localizations/flutter_localizations.dart'; // Import the necessary localizations package
import 'package:khataboook/bottom%20navigation/parties_screen.dart';
import 'I10n/language_selection.dart'; // Import language selection page
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khatabook App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('mr', 'IN'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // Localization delegate for material components
        GlobalWidgetsLocalizations.delegate, // Localization delegate for widget components
      ],
      home: LanguageSelectionPage(), // Home page is language selection
    );
  }
}
