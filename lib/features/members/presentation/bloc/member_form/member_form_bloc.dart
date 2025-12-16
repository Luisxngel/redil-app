import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../members/domain/entities/member.dart';
import '../../../../members/domain/repositories/member_repository.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';

@injectable
class MemberFormBloc extends Bloc<MemberFormEvent, MemberFormState> {
  final MemberRepository _repository;

  MemberFormBloc(this._repository) : super(const MemberFormState()) {
    on<Initialize>(_onInitialize);
    on<FirstNameChanged>((event, emit) => emit(state.copyWith(firstName: event.value)));
    on<LastNameChanged>((event, emit) => emit(state.copyWith(lastName: event.value)));
    on<PhoneChanged>((event, emit) => emit(state.copyWith(phone: event.value)));
    on<AddressChanged>((event, emit) => emit(state.copyWith(address: event.value)));
    on<RoleChanged>((event, emit) => emit(state.copyWith(role: event.value)));
    on<StatusChanged>((event, emit) => emit(state.copyWith(status: event.value)));
    on<CivilStatusChanged>((event, emit) => emit(state.copyWith(civilStatus: event.value)));
    on<DateOfBirthChanged>((event, emit) => emit(state.copyWith(dateOfBirth: event.value)));
    on<NotesChanged>((event, emit) => emit(state.copyWith(notes: event.value)));
    on<PhotoChanged>((event, emit) => emit(state.copyWith(photoPath: event.path)));
    on<ProfessionChanged>((event, emit) => emit(state.copyWith(profession: event.value)));
    on<Submit>(_onSubmit);
  }

  void _onInitialize(Initialize event, Emitter<MemberFormState> emit) {
    if (event.member != null) {
      final m = event.member!;
      emit(state.copyWith(
        originalMember: m,
        firstName: m.firstName,
        lastName: m.lastName,
        phone: m.phone,
        address: m.address ?? '',
        role: m.role,
        status: m.status,
        civilStatus: m.civilStatus ?? CivilStatus.single,
        dateOfBirth: m.dateOfBirth,
        notes: m.notes ?? '',
        photoPath: m.photoPath,
        profession: m.profession,
      ));
    } else {
      // Reset
      emit(const MemberFormState());
    }
  }

  Future<void> _onSubmit(Submit event, Emitter<MemberFormState> emit) async {
    // Validation
    if (state.firstName.trim().isEmpty || state.lastName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Nombre y Apellido son requeridos'));
      emit(state.copyWith(errorMessage: null)); // Clear error trigger
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    final Member memberToSave;
    if (state.isEditing) {
      memberToSave = state.originalMember!.copyWith(
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        phone: state.phone.trim(),
        address: state.address.trim(),
        role: state.role,
        status: state.status,
        civilStatus: state.civilStatus,
        dateOfBirth: state.dateOfBirth,
        notes: state.notes.trim(),
        photoPath: state.photoPath,
        profession: state.profession?.trim(),
        updatedAt: DateTime.now(),
      );
    } else {
      memberToSave = Member(
        id: const Uuid().v4(),
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        phone: state.phone.trim(),
        address: state.address.trim(),
        role: state.role,
        status: state.status,
        civilStatus: state.civilStatus,
        dateOfBirth: state.dateOfBirth,
        notes: state.notes.trim(),
        photoPath: state.photoPath,
        profession: state.profession?.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    final result = await _repository.saveMember(memberToSave);
    
    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
