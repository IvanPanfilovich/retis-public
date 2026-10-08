import 'package:retis/notifications/notifications_service/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:retis/notifications/notifications_schedule/notifications_schedule_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSchedule extends StatefulWidget {
  final NotificationService notificationService;
  final bool showHeader;

  const NotificationSchedule({
    super.key, 
    required this.notificationService, 
    this.showHeader = false
  });

  @override
  State<NotificationSchedule> createState() => _NotificationScheduleState();
}

class _NotificationScheduleState extends State<NotificationSchedule> {
  TimeOfDay? newTime;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsScheduleCubit(notificationService: widget.notificationService),
      child: BlocBuilder<NotificationsScheduleCubit, TimeOfDay>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(left: 15.w, top: 5.h, right: 15.w, bottom: 20.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.showHeader
                  ? Row(
                      children: [
                        Icon(
                          Icons.alarm, 
                          size: 40.r,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        SizedBox(width: 15.w),
                        Text(
                          'Notification Schedule',
                          style: TextStyle(
                            fontSize: 25.r,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
                widget.showHeader ? SizedBox(height: 15.h) : const SizedBox(),
                Text(
                  'This is the time when you will receive notification from the app',
                  style: TextStyle(
                    fontSize: 20.r,
                    height: 1.r
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18.h),
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: state,
                    );
                    if (!context.mounted) return;
                    if (pickedTime != null && pickedTime != state) {
                      setState(() {
                        newTime = pickedTime;
                      });
                      context
                          .read<NotificationsScheduleCubit>()
                          .saveTime(newTime!);
                    }
                  },
                  child: Container(
                    width: 180.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10.h),
                          height: 80.h,
                          width: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            state.hour.toString().padLeft(2, '0'),
                            style: GoogleFonts.epilogue(
                              fontSize: 52.r,
                              height: 1.r,
                              color: Theme.of(context).colorScheme.surface
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.h),
                          height: 70.h,
                          width: 20.w,
                          alignment: Alignment.center,
                          child: Text(
                            ':',
                            style: GoogleFonts.epilogue(
                              fontSize: 52.r,
                              height: 1.r,
                              color: Theme.of(context).colorScheme.surface
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.h),
                          height: 80.h,
                          width: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            state.minute.toString().padLeft(2, '0'),
                            style: GoogleFonts.epilogue(
                              fontSize: 52.r,
                              height: 1.r,
                              color: Theme.of(context).colorScheme.surface
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
