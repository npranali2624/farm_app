import 'package:farmer_app/presentation/pages/admin/admin_dashboard.dart';
import 'package:farmer_app/presentation/pages/landing_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}