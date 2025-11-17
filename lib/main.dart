import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_genui_demo/firebase_options.dart';
import 'package:flutter_genui_demo/home_screen.dart';
import 'package:genui/genui.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final model = FirebaseAI.googleAI().generativeModel(
  //   model: 'gemini-2.5-flash',
  // );
  configureGenUiLogging(level: Level.ALL);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
