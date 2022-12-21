import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.whatsapp,
              size: 90,
            ),
            const Spacer(),
            Text(
              "from",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              "Dhruv",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade300,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
