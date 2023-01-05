import 'package:drift/drift.dart';

class Schedules extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  // CONTENT
  TextColumn get content => text()();

  // Date of event
  DateTimeColumn get date => dateTime()();

  // Start Time
  IntColumn get startTime => integer()();

  // End Time
  IntColumn get endTime => integer()();

  // Category Color ID
  IntColumn get colorId => integer()();

  // Created Date
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
