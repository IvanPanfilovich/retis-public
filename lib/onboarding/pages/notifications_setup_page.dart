import 'package:retis/notifications/notifications_schedule/notifications_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:retis/notifications/notifications_schedule/notifications_schedule_cubit.dart';
import 'package:retis/notifications/notifications_service/notifications_service.dart';
import 'package:retis/onboarding/bloc/notifications_setup_bloc.dart';
import 'package:retis/onboarding/widgets/onboarding_base.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsSetupPage extends StatelessWidget {
  final NotificationService notificationService;
  const NotificationsSetupPage({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotificationsSetupBloc(
              notificationService: notificationService,
            ),
          ),
          BlocProvider(
            create: (context) => NotificationsScheduleCubit(
              notificationService: notificationService
            ),
          ),
        ],
        child: BlocListener<NotificationsSetupBloc, NotificationsSetupState>(
          listener: (context, state) async {
            if (state is NotificationsPermissionGranted) {
              GoRouter.of(context).go('/connections');
            } else if (state is NotificationsPermissionDenied) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification permission denied. The app will not be able to send notifications unless you allow it in the settings.'),
                  duration: Duration(seconds: 10),
                ),
              );
              GoRouter.of(context).go('/connections');
            }
          },
          child: Builder(
            builder: (context) {
              return OnboardingBase(
                onButtonPressed: () {
                  BlocProvider.of<NotificationsSetupBloc>(context).add(
                      RequestNotificationPermission(
                          context.read<NotificationsScheduleCubit>().state));
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Set time when you want to receive notifications',
                        style: GoogleFonts.baloo2(
                          fontSize: 45.r,
                          height: 1.r,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.h),
                      NotificationSchedule(
                        showHeader: true,
                        notificationService: notificationService,
                      ),
                    ],
                  ),
                ),
              );
            }
          )
        ),
      ),
    );
  }
}
