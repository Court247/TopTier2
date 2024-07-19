import 'GameInfo.dart';
import 'Games.dart';

/// Model Class in charge of handing the character lists and filling them.
class Gaming {
  List<dynamic> characters = [];
  String gameName;
  String creator;
  late List<GameInfo> gameInfos;
  late List<Games> games;

  Gaming(this.gameName, this.creator, this.characters) {
    gameInfos = [];
    games = [];
  }

  /// Documentation for addCharacter
  /// > * _`@param: [GameInfo]`_ - gameCharacter
  ///
  /// > _`@returns: [void]`_
  /// Simply adds character instance to the List of GameInfo
  void addCharacter(GameInfo gameCharacter) {
    gameInfos.add(gameCharacter);
  }

  /// Documentation for setCharacters
  /// > _`@returns: [void]`_
  /// Sets character in GameInfo instance whenever it is called
  void setCharacters() {
    int i = 0;
    while (i < characters.length) {
      addCharacter(GameInfo(
          id: characters[i]['id'],
          name: characters[i]['name'],
          title: characters[i]['title'],
          image: characters[i]['image'],
          characterClass: characters[i]['class'],
          element: characters[i]['element'],
          horoscope: characters[i]['horoscope'],
          rarity: characters[i]['rarity'],
          rating: characters[i]['rating'],
          artifact: characters[i]['artifact'],
          sets: characters[i]['sets'],
          description: characters[i]['description'],
          stats: characters[i]['stats'],
          link: characters[i]['link'],
          isFavorite: false,
          canAdd: true,
          isOwned: false));
      i++;
    }
  }

  /// Documentation for addGame
  /// > * _`@param: [List<GameInfo>]`_ - gameInfo
  ///
  /// > _`@returns: [void]`_
  /// Adds Game instance into List<Game>
  void addGame(List<GameInfo> gameInfo) {
    games.add(
        Games(gameName: gameName, creator: creator, characters: gameInfos));
  }
}
