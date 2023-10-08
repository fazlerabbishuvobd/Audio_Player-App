import 'package:audioplayer_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5)).then((value) =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Lottie.asset('assets/player.json', height: 300),
            const Text('Music Player'),
            const Text('Feel your musics'),
            const Spacer(),
            const CircularProgressIndicator(
              color: Colors.amber,
              strokeWidth: 5,
            ),
            const Spacer(),
            const Text('Design and Developed by'),
            const Text('Fazle Rabbi'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            )
          ],
        ),
      ),
    );
  }
}
