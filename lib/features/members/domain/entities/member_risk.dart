import 'member.dart';

class MemberRisk {
  final Member member;
  final int consecutiveAbsences;

  const MemberRisk(this.member, this.consecutiveAbsences);
}
