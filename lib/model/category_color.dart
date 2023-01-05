import 'package:drift/drift.dart';

class CategoryColors extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  // COLOR HEXCODE
  TextColumn get hexCode => text()();
}