import 'package:flutter/material.dart';
import 'package:test_flutter_week8/screen/home_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/009/759/704/non_2x/eps10-pink-motorcycle-front-view-icon-isolated-on-white-background-scooter-symbol-in-a-simple-flat-trendy-modern-style-for-your-website-design-logo-pictogram-and-mobile-application-vector.jpg',
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Makeup Delivery',
            style: TextStyle(
              fontSize: 32,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Get your favorite makeup products delivered to your doorstep quickly and conveniently. Browse through a wide range of brands and enjoy the best beauty shopping experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Best Delivery in Cambodia...',
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.pinkAccent,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
        ],
      ),
    );
  }
}
