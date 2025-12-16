import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../attendance/domain/entities/attendance.dart';
import '../../attendance/domain/repositories/attendance_repository.dart';
import '../../members/domain/entities/member.dart';
import '../../members/domain/repositories/member_repository.dart';

@lazySingleton
class BackupService {
  final MemberRepository _memberRepository;
  final AttendanceRepository _attendanceRepository;

  BackupService(this._memberRepository, this._attendanceRepository);

  /// 1. Create Backup (Export)
  Future<void> createBackup() async {
    try {
      // A. Fetch All Data
      // For members, we need a way to get ALL of them. 'getMembers' returns a Stream.
      // We'll take the first emission.
      final members = await _memberRepository.getMembers().first;
      
      // For attendance history
      final history = await _attendanceRepository.getHistory().first;

      // B. Serialize Data Manual JSON
      final Map<String, dynamic> backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'members': members.map((m) => _memberToMap(m)).toList(),
        'events': history.map((e) => _attendanceToMap(e)).toList(),
      };

      final jsonString = jsonEncode(backupData);

      // C. Save to File
      final directory = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final fileName = 'redil_backup_$dateStr.json';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(jsonString);

      // D. Share File
      await Share.shareXFiles([XFile(file.path)], text: 'Copia de Seguridad Redil - $dateStr');
      
    } catch (e) {
      debugPrint('Backup Error: $e');
      throw Exception('Error al crear copia de seguridad: $e');
    }
  }

  /// 2. Restore Backup (Import)
  /// Returns TRUE if success, Throws if failed.
  Future<bool> restoreBackup() async {
    try {
      // A. Pick File
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return false; // User cancelled
      }

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(content);

      // B. Validation
      if (!jsonMap.containsKey('members') || !jsonMap.containsKey('events')) {
        throw Exception('Formato de archivo inválido. Faltan claves requeridas.');
      }

      final List<dynamic> membersJson = jsonMap['members'];
      final List<dynamic> eventsJson = jsonMap['events'];

      // C. Execution (Wipe & Insert)
      // 1. Wipe
      await _memberRepository.wipeData();
      await _attendanceRepository.wipeData();

      // 2. Insert Members
      for (var mJson in membersJson) {
        final member = _mapToMember(mJson);
        await _memberRepository.saveMember(member);
      }

      // 3. Insert Events
      for (var eJson in eventsJson) {
        final attendance = _mapToAttendance(eJson);
        await _attendanceRepository.saveAttendance(attendance);
      }

      return true;

    } catch (e) {
      debugPrint('Restore Error: $e');
      throw Exception('Error al restaurar copia: $e');
    }
  }

  // --- MAPPERS (Manual Serialization) ---

  Map<String, dynamic> _memberToMap(Member member) {
    return {
      'id': member.id,
      'firstName': member.firstName,
      'lastName': member.lastName,
      'phone': member.phone,
      'role': member.role.index, // Store as INT for stability or STRING for readability? Using Index for simplicity with Enum values.
      'status': member.status.index,
      'lastAttendanceDate': member.lastAttendanceDate?.toIso8601String(),
      'createdAt': member.createdAt.toIso8601String(),
      'updatedAt': member.updatedAt.toIso8601String(),
      'dateOfBirth': member.dateOfBirth?.toIso8601String(),
      'address': member.address,
      'civilStatus': member.civilStatus?.index,
      'notes': member.notes,
      'isDeleted': member.isDeleted,
      'isHarvested': member.isHarvested,
      'lastContacted': member.lastContacted?.toIso8601String(),
    };
  }

  Member _mapToMember(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      role: MemberRole.values[map['role'] as int],
      status: MemberStatus.values[map['status'] as int],
      lastAttendanceDate: map['lastAttendanceDate'] != null ? DateTime.parse(map['lastAttendanceDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      address: map['address'],
      civilStatus: map['civilStatus'] != null ? CivilStatus.values[map['civilStatus'] as int] : null,
      notes: map['notes'],
      isDeleted: map['isDeleted'] ?? false,
      isHarvested: map['isHarvested'] ?? false,
      lastContacted: map['lastContacted'] != null ? DateTime.parse(map['lastContacted']) : null,
    );
  }

  Map<String, dynamic> _attendanceToMap(Attendance attendance) {
    return {
      'id': attendance.id,
      'date': attendance.date.toIso8601String(),
      'title': attendance.title,
      'description': attendance.description,
      'presentMemberIds': attendance.presentMemberIds,
      'targetRole': attendance.targetRole,
      'invitedMemberIds': attendance.invitedMemberIds,
      'seriesId': attendance.seriesId,
    };
  }

  Attendance _mapToAttendance(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      date: DateTime.parse(map['date']),
      title: map['title'],
      description: map['description'],
      presentMemberIds: List<String>.from(map['presentMemberIds'] ?? []),
      targetRole: map['targetRole'] ?? 'ALL',
      invitedMemberIds: List<String>.from(map['invitedMemberIds'] ?? []),
      seriesId: map['seriesId'],
    );
  }
}
