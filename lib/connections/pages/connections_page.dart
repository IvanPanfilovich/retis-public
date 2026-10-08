import 'package:retis/connections/widgets/connection_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:retis/common_widgets/custom_appbar.dart';
import 'package:retis/connections/bloc/connections_bloc.dart';
import 'package:retis/connections/widgets/add_connection_button.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ConnectionsBloc>().add(LoadConnections());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Your connections',
        action: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.r),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.settings_outlined, size: 34.r),
            padding: EdgeInsets.zero,
            color: Theme.of(context).colorScheme.surface,
            onPressed: () {
              GoRouter.of(context).push('/settings');
            },
          ),
        ),
      ),
      body: BlocBuilder<ConnectionsBloc, ConnectionsState>(
        builder: (context, state) {
          if (state is ConnectionsLoading) {
            return Center(
              child: SizedBox(
                width: 100.w,
                height: 100.h,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (state is ConnectionsLoadSuccess) {
            final connections = state.connections;
            if (connections.isEmpty) {
              return Center(
                child: Text(
                  "No connections found",
                  style: TextStyle(fontSize: 30.r),
                )
              );
            }
            return ListView.builder(
              padding: EdgeInsets.only(left: 18.w, top: 18.h, right: 18.w, bottom: 18.h),
              itemCount: connections.length,
              itemBuilder: (context, index) {
                final connection = connections[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 18.h),
                  child: ConnectionTile(connection: connection),
                );
              },
            );
          } else if (state is ConnectionsLoadFailure) {
            return Center(
                child: Text(
              "Error loading connections",
              style: TextStyle(fontSize: 30.r),
            ));
          } else {
            context.read<ConnectionsBloc>().add(RefreshConnections());
            return Center(
              child: SizedBox(
                width: 100.w,
                height: 100.h,
                child: const CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      floatingActionButton: const AddConnectionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
