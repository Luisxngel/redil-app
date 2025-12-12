import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../members/domain/repositories/member_repository.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _checkRepo;
  final MemberRepository _memberRepo;

  // Temporary state for the form
  Set<String> _currentSelection = {};
  Attendance? _editingEvent;

  AttendanceBloc(this._checkRepo, this._memberRepo) : super(const AttendanceState.initial()) {
    on<LoadHistory>(_onLoadHistory);
    on<LoadForm>(_onLoadForm);
    on<ToggleMember>(_onToggleMember);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadHistory(LoadHistory event, Emitter<AttendanceState> emit) async {
    emit(const AttendanceState.loading());
    await emit.forEach(
      _checkRepo.getHistory(),
      onData: (history) => AttendanceState.historyLoaded(history),
      onError: (e, _) => AttendanceState.error(e.toString()),
    );
  }

  Future<void> _onLoadForm(LoadForm event, Emitter<AttendanceState> emit) async {
    emit(const AttendanceState.loading());
    
    // 1. Get ALL active members
    final membersResult = await _memberRepo.getMembers().first; // Get snapshot
    
    // 2. Setup Selection
    if (event.attendanceId != null) {
      // Edit Mode
      // We don't have getById yet in Repo, but we can assume we pass the object or query history.
      // But repo.getHistory is a stream. Ideally invoke getById. 
      // For now, let's just cheat and let the UI pass null if new, or I implement getById if strict.
      // User requirement implies "Edit" functionality.
      // Let's implement a quick filter on history or use existing list if state was history.
      // Actually, easier: _attendanceRepo.getHistory().first... filter by ID.
      try {
         final history = await _checkRepo.getHistory().first;
         _editingEvent = history.firstWhere((e) => e.id == event.attendanceId);
         _currentSelection = Set.from(_editingEvent!.presentMemberIds);
      } catch (e) {
        emit(const AttendanceState.error("No se encontró el evento"));
        return;
      }
    } else {
      // New Mode
      _editingEvent = null;
      _currentSelection = {};
    }

    emit(AttendanceState.formLoaded(
      existingEvent: _editingEvent,
      allMembers: membersResult,
      selectedMemberIds: Set.from(_currentSelection),
    ));
  }

  void _onToggleMember(ToggleMember event, Emitter<AttendanceState> emit) {
    if (state is FormLoaded) {
      final currentState = state as FormLoaded;
      
      if (_currentSelection.contains(event.memberId)) {
        _currentSelection.remove(event.memberId);
      } else {
        _currentSelection.add(event.memberId);
      }

      // Re-emit with updated selection (create copy of set to ensure equality check works if needed, usually Set is distinct ref)
      emit(currentState.copyWith(selectedMemberIds: Set.from(_currentSelection)));
    }
  }

  Future<void> _onSaveEvent(SaveEvent event, Emitter<AttendanceState> emit) async {
    // Generate ID for new or keep existing
    final id = _editingEvent?.id ?? const Uuid().v4();
    
    final newAttendance = Attendance(
      id: id,
      date: event.date,
      description: event.description,
      presentMemberIds: _currentSelection.toList(),
      targetRole: event.targetRole,
      invitedMemberIds: event.invitedMemberIds,
    );

    final result = await _checkRepo.saveAttendance(newAttendance);
    
    result.fold(
      (failure) => emit(AttendanceState.error(failure.message)),
      (_) => emit(const AttendanceState.actionSuccess('Asistencia Guardada')),
    );
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<AttendanceState> emit) async {
     final result = await _checkRepo.deleteAttendance(event.id);
     result.fold(
      (failure) => emit(AttendanceState.error(failure.message)),
      (_) => emit(const AttendanceState.actionSuccess('Evento Eliminado')),
    );
  }
}
