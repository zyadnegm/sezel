import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sezel/WebViewPage.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد AnimationController لمدة 2 ثانية
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // إعداد Tween للانتقال من الشفافية الكاملة إلى الظهور الكامل
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // بدء الأنيميشن
    _animationController.forward();

    // بعد فترة (مثلاً 4 ثوانٍ) الانتقال إلى الشاشة الرئيسية
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WebViewPage()),
      );
    });
  }

  @override
  void dispose() {
    // تأكد من التخلص من الـ AnimationController لتفادي تسرب الذاكرة
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      body: Center(
        // استخدام FadeTransition لإظهار صورة الـ Splash مع أنيميشن
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'images/Blacklogo.png', // ضع هنا صورة السبلاش الخاصة بك
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}