import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final Isar _isar;

  AttendanceRepositoryImpl(this._isar);

  @override
  Stream<List<Attendance>> getHistory({DateTime? start, DateTime? end}) async* {
    print("🔥🔥 REPO: Iniciando getHistory... 🔥🔥");
    
    // 1. WATCH THE QUERY
    // We remove ALL filters. We just want to see what is in the DB.
    final stream = _isar.attendanceModels
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);

    // 2. INTERCEPT THE STREAM TO DEBUG
    yield* stream.map((models) {
      print("🔥🔥 REPO: Isar encontró ${models.length} registros en TOTAL 🔥🔥");
      for (var m in models) {
        print("   -> ID: ${m.id} | Evento: ${m.date}"); 
      }
      
      // 3. CONVERT TO ENTITIES
      final entities = models.map((e) => e.toEntity()).toList();
      return entities;
    });
  }

  @override
  Future<Either<Failure, void>> saveAttendance(Attendance attendance) async {
    try {
      final model = AttendanceModel.fromEntity(attendance);
      
      await _isar.writeTxn(() async {
        // FIX: Data Corruption Prevention (P0)
        // Read existing record to preserve critical fields that might be lost in partial updates
        final existing = await _isar.attendanceModels.get(model.isarId);
        
        if (existing != null) {
          // 1. Preserve Target Role if it was reset to default 'ALL'
          if (model.targetRole == 'ALL' && existing.targetRole != 'ALL') {
            model.targetRole = existing.targetRole;
          }
          
          // 2. Preserve Invited List if it was wiped out
          if (model.invitedMemberIds.isEmpty && existing.invitedMemberIds.isNotEmpty) {
             model.invitedMemberIds = List<String>.from(existing.invitedMemberIds);
          }
        }

        await _isar.attendanceModels.put(model);
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error saving attendance: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttendance(String id) async {
    try {
      final intId = fastHash(id);
      await _isar.writeTxn(() async {
        await _isar.attendanceModels.delete(intId);
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error deleting attendance: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> wipeData() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.attendanceModels.clear();
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error wiping attendance data: $e'));
    }
  }
}
