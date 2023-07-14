part of 'search_bloc.dart';

@immutable
abstract class PersonSearchEvent extends Equatable {
  const PersonSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchPersons extends PersonSearchEvent{
  final String personQuery;

  const SearchPersons({required this.personQuery});

}