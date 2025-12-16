import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../members/domain/repositories/member_repository.dart';
import '../../../../core/providers/date_time_provider.dart';
import '../models/attendance_group.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _checkRepo;
  final MemberRepository _memberRepo;
  final IDateTimeProvider _timeProvider;

  // Temporary state for the form
  Set<String> _currentSelection = {};
  Attendance? _editingEvent;

  AttendanceBloc(this._checkRepo, this._memberRepo, this._timeProvider) : super(const AttendanceState.initial()) {
    on<LoadHistory>(_onLoadHistory);
    on<LoadForm>(_onLoadForm);
    on<ToggleMember>(_onToggleMember);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadHistory(LoadHistory event, Emitter<AttendanceState> emit) async {
    emit(const AttendanceState.loading());
    
    final now = _timeProvider.now;
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
    print("DEBUG BLOC: Init LoadHistory. Range: $startOfYear TO $endOfYear");

    await emit.forEach(
      _checkRepo.getHistory(start: startOfYear, end: endOfYear),
      onData: (history) {
        
        // FIX: DO NOT FILTER. Pass FULL history to the state so Calendar receives everything.
        // We still calculate 'scheduled' for the separate view, but 'history' now contains EVERYTHING.
        print("🔥🔥 BLOC: Emitiendo ${history.length} eventos (Pasado + Futuro) para el Calendario 🔥🔥");

        // 2. Group Future Events (Keep this logic for Key Metrics or Scheduled View)
        final now = _timeProvider.now;
        final futureEvents = history.where((e) => e.date.isAfter(now) || e.date.isAtSameMomentAs(now)).toList();
        final Map<String, List<Attendance>> groups = {};
        
        for (var event in futureEvents) {
          final key = event.seriesId ?? event.id;
          if (!groups.containsKey(key)) {
            groups[key] = [];
          }
          groups[key]!.add(event);
        }
        
        final List<AttendanceGroup> scheduledGroups = [];
        groups.forEach((key, events) {
          if (events.isEmpty) return;
          events.sort((a, b) => a.date.compareTo(b.date));
          final mainEvent = events.first;
          scheduledGroups.add(AttendanceGroup(
            mainEvent: mainEvent,
            count: events.length,
            isRecurring: mainEvent.seriesId != null, 
          ));
        });
        scheduledGroups.sort((a, b) => a.mainEvent.date.compareTo(b.mainEvent.date));
        
        // 3. Emit Loaded with FULL history
        return AttendanceState.historyLoaded(
          history: history, // PASS EVERYTHING
          scheduled: scheduledGroups
        );
      },
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
    final String? seriesId = event.isRecurring ? const Uuid().v4() : _editingEvent?.seriesId;
    
    // 1. Create Base Event (First Instance)
    final baseAttendance = Attendance(
      id: id,
      date: event.date,
      title: event.title, // New
      description: event.description,
      presentMemberIds: _currentSelection.toList(), // Keep selected for the main/first event
      targetRole: event.targetRole,
      invitedMemberIds: event.invitedMemberIds,
      seriesId: seriesId,
    );

    // 2. Prepare list of events to save
    final eventsToSave = <Attendance>[baseAttendance];

    // 3. Handle Recurrence
    if (event.isRecurring && event.recurrenceEndDate != null) {
      if (event.recurrenceFrequency == 'WEEKLY') {
         DateTime nextDate = event.date.add(const Duration(days: 7));
         int safetyCounter = 0;
         
         // Loop until End Date or Max 52 instances (Safety Break)
         while (nextDate.isBefore(event.recurrenceEndDate!.add(const Duration(days: 1))) && safetyCounter < 52) {
           eventsToSave.add(baseAttendance.copyWith(
             id: const Uuid().v4(), // New ID for each instance
             date: nextDate,
             presentMemberIds: [], // Future events start with empty attendance
             seriesId: seriesId,
           ));
           
           nextDate = nextDate.add(const Duration(days: 7));
           safetyCounter++;
         }
      }
    }

    // 4. Execute Save (Sequential to avoid overload/race conditions)
    // We can't really do "all or nothing" transaction here easily without Repo support for strict batch list.
    // For now, save individually. If one fails, we stop and report error.
    
    for (final attendance in eventsToSave) {
      final result = await _checkRepo.saveAttendance(attendance);
      if (result.isLeft()) {
        emit(AttendanceState.error("Error al guardar recurrencia en fecha: ${attendance.date}"));
        return; 
      }
    }
    
    emit(const AttendanceState.actionSuccess('Asistencia Guardada'));
  }

  Future<void> _onDeleteEvent(DeleteEvent event, Emitter<AttendanceState> emit) async {
     final result = await _checkRepo.deleteAttendance(event.id);
     result.fold(
      (failure) => emit(AttendanceState.error(failure.message)),
      (_) => emit(const AttendanceState.actionSuccess('Evento Eliminado')),
    );
  }
}
