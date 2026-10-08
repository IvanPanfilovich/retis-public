import 'package:retis/connections/bloc/connections_bloc.dart';
import 'package:retis/database/database_repository.dart';
import 'package:retis/notifications/notifications_service/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:retis/common_widgets/custom_appbar.dart';
import 'package:retis/notifications/notifications_schedule/notifications_schedule.dart';
import 'package:retis/settings/bloc/settings_bloc.dart';
import 'package:retis/settings/widgets/setting_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final DatabaseRepository databaseRepository;
  final NotificationService notificationService;
  const SettingsPage(
      {super.key,
      required this.databaseRepository,
      required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Settings',
        action: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 45.r,
          icon: const Icon(Icons.close),
          onPressed: () {
            GoRouter.of(context).pop();
            context.read<ConnectionsBloc>().add(RefreshConnections());
          },
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            SettingsBloc(databaseRepository: databaseRepository),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(18.r),
              children: [
                SettingCard(
                  icon: Icons.alarm,
                  title: 'Notification Schedule',
                  content: NotificationSchedule(
                    showHeader: false,
                    notificationService: notificationService
                  ),
                ),
                SizedBox(height: 18.r),
                SettingCard(
                  icon: Icons.insert_drive_file,
                  title: 'Privacy Policy',
                  onTap: () async {
                    const url =
                        'https://docs.google.com/document/d/1DTvDQqZmgNBcXUonTHV-_Vg36BiIXu77Amj9GJzHjkI/edit?usp=sharing';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                ),
                SizedBox(height: 18.r),
                SettingCard(
                  icon: Icons.exit_to_app,
                  title: 'Export connections',
                  onTap: () {
                    context.read<SettingsBloc>().add(ExportConnections());
                  },
                ),
                SizedBox(height: 18.r),
                SettingCard(
                  icon: Icons.upload_file,
                  title: 'Import connections',
                  onTap: () {
                    context.read<SettingsBloc>().add(ImportConnections());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
