import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, human!',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 30.h),
                height: 200.h,
                child: const Image(image: AssetImage('assets/onboarding.png'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  padding:
                      EdgeInsets.symmetric(horizontal: 70.w, vertical: 15.h)),
              onPressed: () {
                Navigator.of(context).pushNamed('/auth');
              },
              child: Text(
                'Let\'s begin!',
                style: GoogleFonts.geologica(
                    fontWeight: FontWeight.w300, fontSize: 18.sp),
              ),
            ),
          ],
        )));
  }
}
