import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:retis/connections/models/connection.dart';
import 'package:go_router/go_router.dart';

class ConnectionTile extends StatelessWidget {
  final Connection connection;

  ConnectionTile({
    super.key,
    required this.connection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/connections/edit/${connection.id}');
      },
      child: Container(
        padding: EdgeInsets.only(left: 12.w, top: 5.h, right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        constraints: BoxConstraints(
          minHeight: 100.h,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 20.h : 0, bottom: Platform.isAndroid ? 15.h : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          connection.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 25.r,
                            height: 1.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 7.5.h),
                      if (connection.commentary != '')
                        Flexible(
                          child: Text(
                            connection.commentary,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 15.r,
                              height: 1.r,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ),
            Flexible(
              flex: 2,
              child: Text(
                intervalOptions[connection.intervalInDays] ?? 'None',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 25.r,
                  height: 1.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Map<int, String> intervalOptions = {
    7: 'Once a week',
    14: 'Every 2 weeks',
    21: 'Every 3 weeks',
    30: 'Every month',
    60: 'Every 2 months',
    90: 'Every 3 months',
    120: 'Every 4 months',
    180: 'Every 6 months',
    365: 'Every 12 months',
  };
}
