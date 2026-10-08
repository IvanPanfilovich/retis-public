import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:retis/common_widgets/custom_appbar.dart';
import 'package:retis/common_widgets/custom_button.dart';
import 'package:retis/connections/bloc/connections_bloc.dart';
import 'package:retis/connections/widgets/edit_connection_tile.dart';
import 'package:retis/connections/models/connection.dart';

class EditConnectionPage extends StatefulWidget {
  final int? id;
  const EditConnectionPage({super.key, this.id});

  @override
  State<EditConnectionPage> createState() => _EditConnectionPageState();
}

class _EditConnectionPageState extends State<EditConnectionPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _commentaryController;
  double _currentSliderValue = 1;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _commentaryController = TextEditingController();

    if (widget.id != null) {
      context.read<ConnectionsBloc>().add(GetConnectionById(widget.id!));
      context.read<ConnectionsBloc>().stream.listen((state) {
        if (state is SingleConnectionLoadSuccess &&
            widget.id == state.connection.id) {
          _nameController.text = state.connection.name;
          _commentaryController.text = state.connection.commentary;
          _currentSliderValue =
              convertDaysToSliderValue(state.connection.intervalInDays)
                  .toDouble();
        }
      });
    } else {
      _nameController.text = '';
      _commentaryController.text = '';
      _currentSliderValue = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionsBloc, ConnectionsState>(
      builder: (context, state) {
        if (state is ConnectionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SingleConnectionLoadFailure) {
          return const Scaffold(
            appBar: CustomAppBar(titleText: 'Edit Connection'),
            body: Center(child: Text('Failed to load connection')),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            titleText: widget.id == null ? 'Create' : 'Edit Connection',
            action: IconButton(
              icon: Icon(Icons.close, size: 30.r),
              onPressed: () {
                context.read<ConnectionsBloc>().add(RefreshConnections());
                GoRouter.of(context).pop();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(18.h),
            child: ListView(
              children: [
                EditConnectionTile(
                  nameController: _nameController,
                  commentaryController: _commentaryController,
                  sliderValue: _currentSliderValue,
                ),
                SizedBox(height: 18.h),
                Slider(
                  value: _currentSliderValue,
                  min: 1,
                  max: 9,
                  divisions: 8,
                  // label: intervalOptions[_currentSliderValue.toInt()],
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    if (widget.id != null)
                      CustomButton(
                        text: 'Delete connection',
                        size: (widget.id != null)
                            ? Size(172.w, 50.h)
                            : Size(352.w, 50.h),
                        fontSize: 18.r,
                        onPressed: () {
                          context
                              .read<ConnectionsBloc>()
                              .add(DeleteConnection(widget.id!));
                          GoRouter.of(context).pop();
                        },
                      ),
                    if (widget.id != null) SizedBox(width: 8.w),
                    CustomButton(
                      text: widget.id == null
                          ? 'Create connection'
                          : 'Save changes',
                      size: (widget.id != null)
                          ? Size(172.w, 50.h)
                          : Size(352.w, 50.h),
                      fontSize: (widget.id != null) ? 18.r : 28.r,
                      onPressed: () {
                        if (_nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter a name for the connection.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        Connection newConnection = Connection(
                          id: widget.id ?? 0,
                          name: _nameController.text,
                          commentary: _commentaryController.text,
                          intervalInDays:
                              convertSliderValueToDays(_currentSliderValue),
                          lastContactedDate:
                              DateTime.fromMillisecondsSinceEpoch(0),
                        );
                        if (widget.id == null) {
                          context
                              .read<ConnectionsBloc>()
                              .add(SaveConnection(newConnection));
                        } else {
                          context
                              .read<ConnectionsBloc>()
                              .add(UpdateConnection(newConnection));
                        }
                        GoRouter.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int convertSliderValueToDays(double sliderValue) {
    switch (sliderValue.toInt()) {
      case 1:
        return 7; // Once a week
      case 2:
        return 14; // 2 weeks
      case 3:
        return 21; // 3 weeks
      case 4:
        return 30; // Every month
      case 5:
        return 60; // Every 2 months
      case 6:
        return 90; // Every 3 months
      case 7:
        return 120; // Every 4 months
      case 8:
        return 180; // Every 6 months
      case 9:
        return 365; // Every 12 months
      default:
        return 7;
    }
  }

  int convertDaysToSliderValue(int days) {
    switch (days) {
      case 7:
        return 1;
      case 14:
        return 2;
      case 21:
        return 3;
      case 30:
        return 4;
      case 60:
        return 5;
      case 90:
        return 6;
      case 120:
        return 7;
      case 180:
        return 8;
      case 365:
        return 9;
      default:
        return 1;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentaryController.dispose();
    super.dispose();
  }
}
