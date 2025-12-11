import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/member.dart';

abstract class MemberRepository {
  /// Get a stream of members for real-time updates
  Stream<List<Member>> getMembers();

  /// Get a specific member by ID
  Future<Either<Failure, Member?>> getMemberById(String id);

  /// Save (create or update) a member
  Future<Either<Failure, void>> saveMember(Member member);

  /// Delete a member by ID
  Future<Either<Failure, void>> deleteMember(String id);

  /// Search members by name or phone
  Future<Either<Failure, List<Member>>> searchMembers(String query);

  /// Search members by name or phone
  Stream<List<Member>> getTrashMembers();
  
  Future<Either<Failure, void>> hardDeleteMember(String id);
  
  Future<Either<Failure, void>> restoreMember(String id);
}
