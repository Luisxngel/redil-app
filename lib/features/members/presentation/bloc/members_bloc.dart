import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import 'members_event.dart';
import 'members_state.dart';

@injectable
class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final MemberRepository _repository;
  
  // Keep track of current members and filter state for in-memory filtering if needed
  // However, requirements say "LoadMembers (Subscribe to stream)".
  // We will assume the stream returns all members, and filtering might happen in the UI or by re-querying.
  // The requirement "FilterByStatus (Recibe un MemberStatus, opcional)" implies we should filter the list.
  
  // To support filtering on the stream, we might need a combined stream or local logic.
  // For simplicity and Clean Architecture, let's keep it simple:
  // If filter is active, we might filter the list from the stream inside map.

  MemberStatus? _currentFilter;

  MembersBloc(this._repository) : super(const MembersState.initial()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMember>(_onAddMember);
    on<DeleteMember>(_onDeleteMember);

    on<SearchMembers>(_onSearchMembers);
    on<FilterByStatus>(_onFilterByStatus);
    on<LoadTrash>(_onLoadTrash);
    on<RestoreMember>(_onRestoreMember);
    on<HardDeleteMember>(_onHardDeleteMember);
    on<WipeAllData>(_onWipeAllData);
  }

  Future<void> _onWipeAllData(
    WipeAllData event,
    Emitter<MembersState> emit,
  ) async {
    final result = await _repository.wipeData();
    result.fold(
      (failure) => emit(MembersState.error(failure.message)),
      (_) => emit(const MembersState.actionSuccess('BASE DE DATOS BORRADA')),
    );
  }
  
  Future<void> _onLoadTrash(
    LoadTrash event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersState.loading());
    await emit.forEach(
      _repository.getTrashMembers(),
      onData: (members) => MembersState.loaded(members),
      onError: (error, stackTrace) => MembersState.error(error.toString()),
    );
  }

  Future<void> _onRestoreMember(
    RestoreMember event,
    Emitter<MembersState> emit,
  ) async {
    final result = await _repository.restoreMember(event.id);
    result.fold(
      (failure) => emit(MembersState.error(failure.message)),
      (_) => emit(const MembersState.actionSuccess('Miembro restaurado')),
    );
  }

  Future<void> _onHardDeleteMember(
    HardDeleteMember event,
    Emitter<MembersState> emit,
  ) async {
    final result = await _repository.hardDeleteMember(event.id);
    result.fold(
      (failure) => emit(MembersState.error(failure.message)),
      (_) => emit(const MembersState.actionSuccess('Miembro eliminado permanentemente')),
    );
  }

  Future<void> _onLoadMembers(
    LoadMembers event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersState.loading());
    await emit.forEach<List<Member>>(
      _repository.getMembers(),
      onData: (members) {
        if (_currentFilter != null) {
          final filtered = members.where((m) => m.status == _currentFilter).toList();
          return MembersState.loaded(filtered);
        }
        return MembersState.loaded(members);
      },
      onError: (e, _) => MembersState.error(e.toString()),
    );
  }

  Future<void> _onAddMember(
    AddMember event,
    Emitter<MembersState> emit,
  ) async {
    // We don't emit loading here to avoid full UI Flicker if we want optimistic updates,
    // but standard practice is to show some loading or just await result.
    // Since we listen to the stream, saving will trigger a new emission from _onLoadMembers automatically.
    final result = await _repository.saveMember(event.member);
    result.fold(
      (failure) => emit(MembersState.error(failure.message)),
      (_) {
        // Success
        emit(const MembersState.actionSuccess('Miembro guardado correctamente'));
      },
    );
  }

  Future<void> _onDeleteMember(
    DeleteMember event,
    Emitter<MembersState> emit,
  ) async {
    final result = await _repository.deleteMember(event.id);
    result.fold(
      (failure) => emit(MembersState.error(failure.message)),
      (_) {
        emit(const MembersState.actionSuccess('Miembro eliminado correctamente'));
      },
    );
  }

  Future<void> _onSearchMembers(
    SearchMembers event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersState.loading());
    final result = await _repository.searchMembers(event.query);
    result.fold(
      (failure) => emit(MembersState.error(failure.message)),
      (members) => emit(MembersState.loaded(members)),
    );
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<MembersState> emit,
  ) async {
    _currentFilter = event.status;
    // We need to re-trigger the stream processing or re-fetch.
    // Since emit.forEach is active, simply triggering a new Load might be cleanest to "reset" the stream handler with new logic?
    // OR easier: just re-add LoadMembers event to restart the stream subscription with the new filter context?
    // A more reactive approach is having the stream combiner, but restarting the listener is acceptable for MVP.
    add(const LoadMembers());
  }
}
