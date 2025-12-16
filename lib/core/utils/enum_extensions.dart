import '../../features/members/domain/entities/member.dart';

extension MemberRoleX on MemberRole {
  String get label {
    switch (this) {
      case MemberRole.leader:
        return 'Líder';
      case MemberRole.assistant:
        return 'Servidor';
      case MemberRole.member:
        return 'Discípulo';
      case MemberRole.guest:
        return 'Invitado';
    }
  }

  String get labelPlural {
    switch (this) {
      case MemberRole.leader:
        return 'Líderes';
      case MemberRole.assistant:
        return 'Servidores';
      case MemberRole.member:
        return 'Discípulos';
      case MemberRole.guest:
        return 'Invitados';
    }
  }
}

extension MemberStatusX on MemberStatus {
  String get label {
    switch (this) {
      case MemberStatus.active:
        return 'Activo';
      case MemberStatus.inactive:
        return 'Inactivo';
      case MemberStatus.suspended:
        return 'Disciplinado';
    }
  }
}

extension CivilStatusX on CivilStatus {
  String get label {
    switch (this) {
      case CivilStatus.single:
        return 'Soltero';
      case CivilStatus.married:
        return 'Casado';
      case CivilStatus.widowed:
        return 'Viudo';
      case CivilStatus.divorced:
        return 'Divorciado';
    }
  }
}
