import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String id; // UUID
  final DateTime date;
  final String? description;
  final List<String> presentMemberIds;
  final String targetRole; // 'ALL', 'LIDER', 'MEMBER', 'OPTIONAL', 'MANUAL'
  final List<String> invitedMemberIds; // For MANUAL role

  const Attendance({
    required this.id,
    required this.date,
    this.description,
    this.presentMemberIds = const [],
    this.targetRole = 'ALL',
    this.invitedMemberIds = const [],
  });

  @override
  List<Object?> get props => [id, date, description, presentMemberIds, targetRole, invitedMemberIds];
}
