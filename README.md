# Retis

Retis is a Flutter app that helps you keep in touch with the people who matter. Add the
people you want to stay close to, say how often you want to reach out, and Retis sends you
a local reminder at a time of day you choose — so nothing quietly slips.

## How it works

- Add a **connection**: a name, an optional note, how often you want to reach out (in days)
  and when you last spoke.
- Choose a daily **notification time**. Retis schedules local notifications for the
  connections that are due and re-schedules them in the background.
- Mark a connection as contacted and its interval restarts from that day.
- **Import and export** your data as a spreadsheet.

### How the reminder engine works

For each due connection Retis picks a random day inside the chosen interval, snaps it to
your saved notification time (default **20:00**) and schedules a local notification. A
`background_fetch` task then re-scans the schedule every 15 minutes and reschedules as
connections are contacted, with `stopOnTerminate: false` and `startOnBoot: true` so reminders
survive app closes and device restarts.

## Screens

- Onboarding — welcome and notification setup
- Connections — list, add and edit connection
- Settings — notification schedule, data import/export, about

## Tech stack

- **Framework:** Flutter (Dart SDK >= 3.3.3)
- **State management:** `flutter_bloc`
- **Navigation:** `go_router`
- **Storage:** `sqflite`, `shared_preferences`
- **Notifications & background work:** `flutter_local_notifications`, `background_fetch`,
  `flutter_timezone`
- **UI:** `google_fonts`, `flutter_screenutil`, `flutter_svg`
- **Data import/export:** `excel`, `file_picker`
- **Other:** `permission_handler`, `url_launcher`, `path_provider`

## Project layout

Everything that ships lives under `lib/`. The app is organised by feature, with each feature
holding its own bloc, pages and widgets so a change to one never reaches into another.

```
lib/
  main.dart                      app entry: background fetch, blocs, router, theme
  common_widgets/                shared app bar and button
  connections/                   the core entity: people you keep in touch with
  database/                      sqflite repository
  notifications/                 reminder scheduling and delivery
  onboarding/                    first-run welcome and notification setup
  settings/                      settings screen, import/export
  ui/                            theme definition
```

### Module reference

| Module | Files | Responsibility |
| --- | --- | --- |
| `main.dart` | — | Configures `background_fetch` (15 min, `stopOnTerminate: false`, `startOnBoot: true`), builds the `ConnectionsBloc`, decides the first route from saved preferences, and mounts `MaterialApp.router`. |
| `connections/` | `bloc/`, `models/`, `pages/`, `widgets/` | `Connection` is the domain model (name, note, interval in days, last contacted). `ConnectionsBloc` owns the CRUD and notification-scheduling events; `connections_page` lists them and `edit_connection_page` adds and edits. |
| `notifications/` | `notifications_service/`, `notifications_schedule/` | `NotificationService` initialises the plugin, requests permissions, computes the next reminder date and schedules/cancels notifications. `NotificationSchedule` + its cubit render the daily time picker and persist the chosen time. |
| `onboarding/` | `bloc/`, `pages/`, `widgets/` | The first-run flow: `welcome_page` introduces the app, `notifications_setup_page` walks through permission and the daily reminder time, sharing layout through `onboarding_base`. |
| `settings/` | `bloc/`, `pages/`, `widgets/` | `SettingsBloc` handles the notification schedule, spreadsheet import/export and the "contact us" / store links; `settings_page` composes them from `setting_card` rows. |
| `database/` | `database_repository.dart` | Single sqflite access point: opens and migrates the database, exposes connection CRUD, and mirrors the current list into `shared_preferences` for the background task. |
| `common_widgets/` | `custom_appbar.dart`, `custom_button.dart` | The two shared primitives every screen builds on. |
| `ui/` | `theme.dart` | `getThemeData()` — the app's single colour, typography and component theme. |

Platform shells (`android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`) are the standard
Flutter runners, customised with the Retis name, icons and bundle identifiers. Assets live in
`assets/` (app icon and adaptive foreground) and `web/`.

## Getting started

Requires a Flutter SDK matching Dart >= 3.3.3.

```bash
flutter pub get
flutter run
```

## Status

Retis is published and live:

- **App Store:** <https://apps.apple.com/app/id6499269473>
- **Google Play:** <https://play.google.com/store/apps/details?id=com.retis.retis>

This repository holds the application source.

## License

Copyright (c) 2026 Ivan Panfilovich. All rights reserved. See [`LICENSE`](./LICENSE).
