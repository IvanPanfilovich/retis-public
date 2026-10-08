import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.titleText,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      title: Padding(
        padding: EdgeInsets.only(left: 18.w, top: 10.h),
        child: Text(
          titleText,
          style: TextStyle(
            fontSize: 30.r,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 18.w, top: 10.h),
          child: action ?? const SizedBox(),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(66.h);
}
