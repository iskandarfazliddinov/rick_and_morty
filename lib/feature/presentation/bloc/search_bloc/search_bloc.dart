import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/usecases/search_person.dart';
part 'search_event.dart';
part 'search_state.dart';

// ignore: constant_identifier_names
const SERVER_FAILURE_MASSAGE = 'ServerFailure';
// ignore: constant_identifier_names
const CACHED_FAILURE_MASSAGE = 'CacheFailure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;
  PersonSearchBloc({required this.searchPerson}) : super(PersonEmpty()){
    on<PersonSearchEvent>((event, emit) async {
      if (event is SearchPersons) {
        emit(PersonSearchLoading());

        final failureOrPerson =
        await searchPerson(SearchPersonParams(query: event.personQuery));

        failureOrPerson.fold(
                (failure) => emit(PersonSearchError(message: _mapFailureToMessage(failure))),
                (person) => emit(PersonSearchLoaded(persons: person)));
      }
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
