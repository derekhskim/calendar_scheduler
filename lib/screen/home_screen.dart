import 'dart:ffi';

import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: Column(children: [
          Calendar(
            selectedDay: selectedDay,
            focusedDay: focusedDay,
            onDaySelected: onDaySelected,
          ),
          SizedBox(height: 8),
          TodayBanner(
            selectedDay: selectedDay,
            scheduleCount: 3,
          ),
          SizedBox(height: 8),
          _ScheduleList(
            selectedDate: selectedDay,
          ),
        ]),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          /// Bottom Sheet, only stretches till half of the screen
          context: context,
          isScrollControlled: true,

          /// Enables the ability to stretch beyond half of the screen
          builder: (_) {
            /// Takes regular builder context (_) {}
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(
        Icons.add,
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;
  const _ScheduleList({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: StreamBuilder<List<Schedule>>(
            stream: GetIt.I<LocalDatabse>().watchSchedules(),
            builder: (context, snapshot) {
              print('------------ Original Data ------------');
              print(snapshot.data);

              List<Schedule> schedules = [];

              if (snapshot.hasData) {
                schedules = snapshot.data!
                    .where((element) => element.date == selectedDate)
                    .toList();
              }

              print('------------ filtered Data ------------');
              print(selectedDate);
              print(schedules);

              return ListView.separated(
                  itemCount: 100,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 8,
                    );
                  },
                  itemBuilder: (context, index) {
                    return ScheduleCard(
                      startTime: 12,
                      endTime: 14,
                      content: '프로그래밍 공부하기. $index',
                      color: Colors.red,
                    );
                  });
            }),
      ),
    );
  }
}
