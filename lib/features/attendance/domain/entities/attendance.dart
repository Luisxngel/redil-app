import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String id; // UUID
  final DateTime date;
  final String? description;
  final List<String> presentMemberIds;

  const Attendance({
    required this.id,
    required this.date,
    this.description,
    this.presentMemberIds = const [],
  });

  @override
  List<Object?> get props => [id, date, description, presentMemberIds];
}
