import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String id; // UUID
  final DateTime date;
  final String? title; // NEW: Event Name
  final String? description; // Details
  final List<String> presentMemberIds;
  final String targetRole; // 'ALL', 'LIDER', 'MEMBER', 'OPTIONAL', 'MANUAL'
  final List<String> invitedMemberIds; // For MANUAL role
  final String? seriesId; // Identifier for recurring event series

  const Attendance({
    required this.id,
    required this.date,
    this.title,
    this.description,
    this.presentMemberIds = const [],
    this.targetRole = 'ALL',
    this.invitedMemberIds = const [],
    this.seriesId,
  });

  @override
  List<Object?> get props => [id, date, title, description, presentMemberIds, targetRole, invitedMemberIds, seriesId];

  Attendance copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? description,
    List<String>? presentMemberIds,
    String? targetRole,
    List<String>? invitedMemberIds,
    String? seriesId,
  }) {
    return Attendance(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      presentMemberIds: presentMemberIds ?? this.presentMemberIds,
      targetRole: targetRole ?? this.targetRole,
      invitedMemberIds: invitedMemberIds ?? this.invitedMemberIds,
      seriesId: seriesId ?? this.seriesId,
    );
  }
}
