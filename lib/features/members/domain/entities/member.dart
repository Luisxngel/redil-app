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
  final bool isHarvested; 
  final DateTime? lastContacted; // NEW: Track last interaction

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
    this.isHarvested = false,
    this.lastContacted,
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
        isHarvested,
        lastContacted,
      ];

  // Business Logic / Validation could go here or in UseCases/ValueObjects
  // For simple MVP rules:
  static String sanitizeName(String name) => name.trim();

  static bool isValidPhone(String phone) {
    // Allows numbers and + symbol
    return RegExp(r'^[0-9+]+$').hasMatch(phone);
  }

  Member copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    MemberRole? role,
    MemberStatus? status,
    DateTime? lastAttendanceDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dateOfBirth,
    String? address,
    CivilStatus? civilStatus,
    String? notes,
    bool? isDeleted,
    bool? isHarvested,
    DateTime? lastContacted,
  }) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      lastAttendanceDate: lastAttendanceDate ?? this.lastAttendanceDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      civilStatus: civilStatus ?? this.civilStatus,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
      isHarvested: isHarvested ?? this.isHarvested,
      lastContacted: lastContacted ?? this.lastContacted,
    );
  }
}
