import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_fetch/background_fetch.dart';

import 'package:retis/connections/bloc/connections_bloc.dart';
import 'package:retis/connections/pages/connections_page.dart';
import 'package:retis/connections/pages/edit_connection_page.dart';
import 'package:retis/database/database_repository.dart';
import 'package:retis/notifications/notifications_service/notifications_service.dart';
import 'package:retis/settings/pages/settings_page.dart';
import 'package:retis/ui/theme.dart';

import 'onboarding/pages/notifications_setup_page.dart';
import 'onboarding/pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final notificationService =
      NotificationService(databaseRepository: DatabaseRepository.instance);
  await notificationService.initialize();

  runApp(RetisApp(notificationService: notificationService));
  await BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      startOnBoot: true,
      requiresBatteryNotLow: false,
      requiresStorageNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
    ),
    notificationService.notificationsRescheduleTask,
    (String taskId) async {
      BackgroundFetch.finish(taskId);
    },
  );
}

class RetisApp extends StatelessWidget {
  final NotificationService notificationService;

  const RetisApp({super.key, required this.notificationService});

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();

    final onboardingDone = (prefs.getInt('notificationsTimeHour') != null) &&
        (prefs.getInt('notificationsTimeMinute') != null);
    var notificationsAllowed = await notificationService.checkPermission();
    if (!notificationsAllowed && onboardingDone) {
      notificationsAllowed = await notificationService.requestPermissions();
    }
    return onboardingDone && notificationsAllowed;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ConnectionsBloc(
                databaseRepository: DatabaseRepository.instance,
                notificationService: notificationService)),
      ],
      child: FutureBuilder<bool>(
        future: isOnboardingDone(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final onboardingDone = snapshot.data ?? false;
          final router = GoRouter(
            initialLocation: onboardingDone ? '/connections' : '/onboarding',
            routes: [
              GoRoute(
                path: '/onboarding',
                builder: (context, state) => const WelcomePage(),
                routes: [
                  GoRoute(
                    path: 'notifications-setup',
                    builder: (context, state) => NotificationsSetupPage(
                      notificationService: notificationService,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/connections',
                builder: (context, state) => const ConnectionsPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const EditConnectionPage(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      return EditConnectionPage(id: id);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/settings',
                builder: (context, state) => SettingsPage(
                  databaseRepository: DatabaseRepository.instance,
                  notificationService: notificationService,
                ),
              ),
            ],
          );

          return ScreenUtilInit(
            designSize: const Size(390, 845),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp.router(
              theme: getThemeData(),
              routerConfig: router,
            ),
          );
        },
      ),
    );
  }
}
