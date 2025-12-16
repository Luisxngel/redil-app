import 'package:shared_preferences/shared_preferences.dart'; // NEW
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/members/data/models/member_model.dart';
import '../../features/attendance/data/models/attendance_model.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => getIt.init();

@module
abstract class IsarModule {
  @preResolve
  Future<Isar> get isar async {
    final dir = await getApplicationDocumentsDirectory();
    
    // Open Isar with defined schemas
    return await Isar.open(
      [MemberModelSchema, AttendanceModelSchema],
      directory: dir.path,
    );
  }
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
