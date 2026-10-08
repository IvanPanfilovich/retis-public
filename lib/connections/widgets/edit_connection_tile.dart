import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditConnectionTile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController commentaryController;
  final double sliderValue;

  final Map<int, String> intervalOptions = {
    1: 'Once a week',
    2: 'Every 2 weeks',
    3: 'Every 3 weeks',
    4: 'Every month',
    5: 'Every 2 months',
    6: 'Every 3 months',
    7: 'Every 4 months',
    8: 'Every 6 months',
    9: 'Every 12 months',
  };

  EditConnectionTile({
    super.key,
    required this.nameController,
    required this.commentaryController,
    required this.sliderValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 5.h),
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
                padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
                child: Column(
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    controller: nameController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 25.r,
                      height: 1.r
                    ),
                    cursorColor: Theme.of(context).colorScheme.surface,
                    cursorHeight: 25.h,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 25.r,
                        height: 1.r
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 7.5.h),
                  Expanded(
                    child: TextFormField(
                      controller: commentaryController,
                      expands: true,
                      maxLines: null,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 15.r,
                        height: 1.r
                      ),
                      cursorColor: Theme.of(context).colorScheme.surface,
                      decoration: InputDecoration(
                        labelText: 'Commentary (optional)',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 15.r
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ],
              ),
              )
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              intervalOptions[sliderValue.toInt()] ?? 'How often',
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
    );
  }
}
