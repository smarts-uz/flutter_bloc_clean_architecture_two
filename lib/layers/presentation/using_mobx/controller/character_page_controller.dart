// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:rickmorty/layers/domain/entity/character.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';

part 'character_page_controller.g.dart';

enum CharacterPageStatus { initial, loading, success, failed }

class CharacterPageController = _CharacterPageController
    with _$CharacterPageController;

abstract class _CharacterPageController with Store {
  _CharacterPageController({
    required GetAllCharacters getAllCharacters,
  }) : _getAllCharacters = getAllCharacters;

  final GetAllCharacters _getAllCharacters;

  @readonly
  var _contentStatus = CharacterPageStatus.initial;

  @readonly
  var _currentPage = 1;

  @readonly
  var _hasReachedEnd = false;

  final charactersList = ObservableList<Character>();

  @action
  Future<void> fetchNextPage() async {
    if (_hasReachedEnd) return;

    _contentStatus = CharacterPageStatus.loading;

    final list = await _getAllCharacters(page: _currentPage);

    _currentPage++;
    charactersList.addAll(list);
    _contentStatus = CharacterPageStatus.success;
    _hasReachedEnd = list.isEmpty;
  }
}
