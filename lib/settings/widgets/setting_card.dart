import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? content;
  final void Function()? onTap;

  const SettingCard({
    super.key,
    required this.icon,
    required this.title,
    this.content,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    if (content != null) {
      return ExpansionTile(
        dense: true,
        tilePadding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 3.r),
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        leading: Icon(icon, size: 40.r),
        title: Text(title, style: TextStyle(fontSize: 24.r, height: 1.2)),
        children: [content!],
      );
    } else {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 3.r),
        tileColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        leading: Icon(icon, size: 40.r),
        title: Text(title, style: TextStyle(fontSize: 24.r, height: 1.2)),
        onTap: onTap,
      );
    }
  }
}
