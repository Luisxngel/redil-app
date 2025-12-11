import 'package:equatable/equatable.dart';

enum MemberRole { leader, assistant, member, guest }

enum MemberStatus { active, inactive, suspended }

enum CivilStatus { single, married, widowed, divorced }

class Member extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String phone;
  final MemberRole role;
  final MemberStatus status;
  final DateTime? lastAttendanceDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // New Fields
  final DateTime? dateOfBirth;
  final String? address;
  final CivilStatus? civilStatus;
  final String? notes;
  final bool isDeleted;

  const Member({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.status,
    this.lastAttendanceDate,
    required this.createdAt,
    required this.updatedAt,
    this.dateOfBirth,
    this.address,
    this.civilStatus,
    this.notes,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phone,
        role,
        status,
        lastAttendanceDate,
        createdAt,
        updatedAt,
        dateOfBirth,
        address,
        civilStatus,
        notes,
        isDeleted,
      ];

  // Business Logic / Validation could go here or in UseCases/ValueObjects
  // For simple MVP rules:
  static String sanitizeName(String name) => name.trim();

  static bool isValidPhone(String phone) {
    // Allows numbers and + symbol
    return RegExp(r'^[0-9+]+$').hasMatch(phone);
  }
}
