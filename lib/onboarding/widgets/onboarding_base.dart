import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:retis/common_widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingBase extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final Widget child;
  final String buttonText;

  const OnboardingBase({
    super.key,
    required this.onButtonPressed,
    required this.child,
    this.buttonText = "Next",
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Expanded(child: child),
            CustomButton(
              text: buttonText,
              onPressed: onButtonPressed,
            ),
          ],
        ),
      )
    );
  }
}
