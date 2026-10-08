import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:retis/onboarding/widgets/onboarding_base.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBase(
        onButtonPressed: () {
          context.push('/onboarding/notifications-setup');
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icon.svg',
                    width: 100.w,
                    height: 100.h,
                  ),
                  SizedBox(width: 60.w),
                  Text(
                    'Retis',
                    style: GoogleFonts.baloo2(
                      fontSize: 45.r,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60.h),
              Text(
                'Add your valuable connections',
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 30.r, 
                  height: 1.r,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.h),
              Icon(
                Icons.arrow_downward,
                size: 60.r,
                color: Theme.of(context).colorScheme.onSurface
              ),
              Text(
                'Set how often do you want to contact them',
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 30.r,
                  height: 1.r,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.h),
              Icon(
                Icons.arrow_downward,
                size: 60.r,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Text(
                'Receive notification on a random day',
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 30.r,
                  height: 1.r, 
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.h),
              Icon(
                Icons.arrow_downward,
                size: 60.r,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Text(
                'Build and Grow your network!',
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 30.r,
                  height: 1.r,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
