import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/schedule_with_color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:intl/intl.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  const TodayBanner({
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: Colors.white,
    );

    String formattedDate = DateFormat('MMMM dd, yyyy').format(selectedDay);

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate,
              style: textStyle,
            ),
            StreamBuilder<List<ScheduleWithColor>>(
              stream: GetIt.I<LocalDatabse>().watchSchedules(selectedDay),
              builder: (context, snapshot) {
                int count = 0;

                if(snapshot.hasData){
                  count = snapshot.data!.length;
                }

                return Text(
                  '$count Schedules',
                  style: textStyle,
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
