import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../models/member_model.dart';

@LazySingleton(as: MemberRepository)
class MemberRepositoryImpl implements MemberRepository {
  final Isar _isar;

  MemberRepositoryImpl(this._isar);

  @override
  Stream<List<Member>> getMembers() async* {
    yield* _isar.memberModels
        .where()
        .filter()
        .isDeletedEqualTo(false) // Filter active members
        .watch(fireImmediately: true)
        .map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Stream<List<Member>> getTrashMembers() async* {
    yield* _isar.memberModels
        .where()
        .filter()
        .isDeletedEqualTo(true) // Filter deleted members
        .watch(fireImmediately: true)
        .map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<Failure, Member?>> getMemberById(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) return const Right(null);

      final model = await _isar.memberModels.get(intId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMember(Member member) async {
    try {
      final model = MemberModel.fromEntity(member);
      await _isar.writeTxn(() async {
        await _isar.memberModels.put(model);
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error saving member: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> hardDeleteMember(String id) async {
    try {
      final intId = int.parse(id);
      await _isar.writeTxn(() async {
        await _isar.memberModels.delete(intId); // Hard Delete
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMember(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        return const Left(DatabaseFailure('Invalid ID format'));
      }

      await _isar.writeTxn(() async {
        final member = await _isar.memberModels.get(intId);
        if (member != null) {
          member.isDeleted = true;
          await _isar.memberModels.put(member); // Soft Delete
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error deleting member: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> restoreMember(String id) async {
    try {
      final intId = int.parse(id);
      await _isar.writeTxn(() async {
        final member = await _isar.memberModels.get(intId);
        if (member != null) {
          member.isDeleted = false;
          await _isar.memberModels.put(member); // Restore
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Member>>> searchMembers(String query) async {
    try {
      if (query.isEmpty) {
        final members = await _isar.memberModels.where().findAll();
        return Right(members.map((e) => e.toEntity()).toList());
      }

      final models = await _isar.memberModels
          .filter()
          .firstNameContains(query, caseSensitive: false)
          .or()
          .lastNameContains(query, caseSensitive: false)
          .or()
          .phoneContains(query)
          .findAll();

      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error searching members: $e'));
    }
  }
}
