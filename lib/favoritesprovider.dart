import 'package:flutter/material.dart';
import 'package:toptier/GameInfo.dart';

class FavoriteProvider extends ChangeNotifier {
  List<GameInfo> _favorites = [];
  List<GameInfo> get favorites => _favorites;

  /// Documentation for addFav
  /// > * _`@param: [GameInfo]`_ - character
  ///
  /// > _`@returns: [void]`_
  ///
  /// adds character to favorites list
  /// Some reason it keeps removing the character below the one you click on
  void addFav(GameInfo character) {
    String charName = character.name;
    final isFav = character.isFavorite;
    if (isFav) {
      _favorites.add(character);
    } else if (!isFav) {
      _favorites.remove(character);
    }
    notifyListeners();
  }

  /// Documentation for clearFavorite
  ///
  /// > _`@returns: [void]`_
  ///
  /// Clears the favorites list
  void clearFavorite() {
    _favorites = [];
    notifyListeners();
  }
}
