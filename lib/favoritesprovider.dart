import 'package:flutter/material.dart';
import 'package:toptier/GameInfo.dart';

import 'CharacterRemove.dart';

class FavoriteProvider extends ChangeNotifier {
  List<CharacterRemove> _favorites = [];
  set favorites(List<CharacterRemove> value) => _favorites = value;
  List<CharacterRemove> get favorites => _favorites;

  /// Documentation for addFav
  /// > * _`@param: [GameInfo]`_ - character
  ///
  /// > _`@returns: [void]`_
  ///
  /// adds character to favorites list
  /// Some reason it keeps removing the character below the one you click on

  void addFav(CharacterRemove character) {
    //add to favorites list
    if (character.character.isFavorite) {
      final userId =
          character.character.id; // Assuming character has a userId property
      final isUserInFavorites =
          _favorites.any((fav) => fav.character.id == userId);

      if (!isUserInFavorites) {
        print(character.creator);
        _favorites.add(character);
      }

      
    }

    // Notify listeners of the change
    notifyListeners();
  }

  void removeFav(characterID) {
    //fix this logic
    // Find the character by ID
    _favorites.removeWhere((find) => find.character.id == characterID);

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
