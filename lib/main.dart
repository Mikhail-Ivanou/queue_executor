import 'package:flutter/material.dart';
import 'package:queue_executor/injector.dart';
import 'package:queue_executor/ui/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      home: const MainPage(),
    );
  }
}
