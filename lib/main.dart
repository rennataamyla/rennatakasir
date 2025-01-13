import 'package:flutter/material.dart';
import 'package:rennatakasir/splash.dart';
// import 'package:rennakasir/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://njefwoyeuwuyehoksium.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qZWZ3b3lldXd1eWVob2tzaXVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTg3MDgsImV4cCI6MjA1MTg3NDcwOH0.gDqisRACn56V0WSSrRuYkYIbFwneJkUaS3RCCTS-KJw',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50],
      ),
      home: SplashScreen(),
    );
  }
}
