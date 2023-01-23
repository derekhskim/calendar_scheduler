
import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/model/schedule_with_color.dart';
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
          const SizedBox(height: 8),
          TodayBanner(
            selectedDay: selectedDay,
          ),
          const SizedBox(height: 8),
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
      child: const Icon(
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
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabse>().watchSchedules(selectedDate),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('스케줄이 없습니다.'),
                );
              }

              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                  itemBuilder: (context, index) {
                    final scheduleWithColor = snapshot.data![index];

                    return Dismissible(
                      key: ObjectKey(scheduleWithColor.schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        GetIt.I<LocalDatabse>()
                            .removeSchedule(scheduleWithColor.schedule.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) {
                              return ScheduleBottomSheet(
                                selectedDate: selectedDate,
                                scheduleId: scheduleWithColor.schedule.id,
                              );
                            },
                          );
                        },
                        child: ScheduleCard(
                          startTime: scheduleWithColor.schedule.startTime,
                          endTime: scheduleWithColor.schedule.endTime,
                          content: scheduleWithColor.schedule.content,
                          color: Color(
                            int.parse(
                              'FF${scheduleWithColor.categoryColor.hexCode}',
                              radix: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
