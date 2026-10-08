import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Size? size;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: size ?? Size(325.w, 60.h),
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          // padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: fontSize ?? 30.r),
        ));
  }
}
