// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/usecases/get_all_persons.dart';
part 'person_list_state.dart';
// ignore: constant_identifier_names
const SERVER_FAILURE_MASSAGE = 'ServerFailure';
// ignore: constant_identifier_names
const CACHED_FAILURE_MASSAGE = 'CacheFailure';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPerson getAllPerson;

  PersonListCubit({required this.getAllPerson}) : super(PersonEmpty());

  int page = 1;
  void loadPerson() async{
    if(state is PersonLoading) return ;

    final currentState = state;

    var oldPerson = <PersonEntity>[];
    if(currentState is PersonLoaded){
      oldPerson = currentState.personsList;
    }
    
    emit(PersonLoading(oldPerson,isFirstFetch: page == 1));

    final failureOrPerson = await getAllPerson (PagePersonParams(page: page));

    failureOrPerson.fold((error) => emit(PersonError(message: _mapFailureToMessage(error))), (character) {
      page++;
      final persons = (state as PersonLoading).oldPersonList;
      persons.addAll(character);
      emit(PersonLoaded(persons));
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MASSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MASSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
