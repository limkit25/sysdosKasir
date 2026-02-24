import 'package:injectable/injectable.dart';
import '../database/app_database.dart';

@module
abstract class AppModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();
}
