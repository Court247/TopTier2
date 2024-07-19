import 'GameInfo.dart';

///Games class for holding the List of Characters and the game name
class Games {
  String gameName;
  String creator;
  List<GameInfo> characters;

  Games(
      {required this.gameName,
      required this.creator,
      required this.characters});

  /// Documentation for toJson
  ///
  /// > _`@returns: [Map]`_
  ///
  ///Creates json for Game class calling GameInfo to create json for each character in the List<GameInfo> character list
  toJson() {
    Map data = new Map();
    data['gameName'] = this.gameName;
    data['Characters'] = this.characters.map((v) => v.ToJson()).toList();

    return data;
  }
}
