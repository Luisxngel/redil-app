import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Stream<List<Attendance>> getHistory(); // Most recent first
  Future<Either<Failure, void>> saveAttendance(Attendance attendance);
  Future<Either<Failure, void>> deleteAttendance(String id);
}
