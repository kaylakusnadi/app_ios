import 'package:flutter/material.dart';
import 'dart:async';
import 'dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigasi otomatis ke Dashboard setelah 2 detik
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/logo_borwita.png',
              width: 220,
              // Fallback icon jika gambar belum terdaftar di pubspec.yaml
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.business,
                size: 100,
                color: Colors.blue,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Text(
                "Developed by Kayla Kirani Kusnadi",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}