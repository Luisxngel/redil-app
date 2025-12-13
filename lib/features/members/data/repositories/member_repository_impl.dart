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
      final model = await _isar.memberModels.filter().idEqualTo(id).findFirst();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMember(Member member) async {
    try {
      final existing = await _isar.memberModels
          .filter()
          .idEqualTo(member.id!)
          .findFirst();

      final model = MemberModel.fromEntity(member);
      
      if (existing != null) {
        model.isarId = existing.isarId; // Update existing record
        print('DEBUG REPO: Updating existing member (IsarID: ${existing.isarId}) with UUID: ${member.id}');
      } else {
        print('DEBUG REPO: Creating new member with UUID: ${member.id}');
      }

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
      await _isar.writeTxn(() async {
        await _isar.memberModels.filter().idEqualTo(id).deleteAll(); 
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMember(String id) async {
    try {
      await _isar.writeTxn(() async {
        final member = await _isar.memberModels.filter().idEqualTo(id).findFirst();
        if (member != null) {
          member.isDeleted = true;
          await _isar.memberModels.put(member); 
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
      await _isar.writeTxn(() async {
        final member = await _isar.memberModels.filter().idEqualTo(id).findFirst();
        if (member != null) {
          member.isDeleted = false;
          await _isar.memberModels.put(member); 
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

  @override
  Future<Either<Failure, void>> wipeData() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.memberModels.clear();
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
