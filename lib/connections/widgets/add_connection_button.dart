import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddConnectionButton extends StatelessWidget {
  const AddConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      shape: const CircleBorder(),
      onPressed: () {
        GoRouter.of(context).push('/connections/add');
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSurface,
        size: 40.r,
      ),
    );
  }
}
