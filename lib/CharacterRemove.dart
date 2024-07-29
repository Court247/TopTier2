import 'GameInfo.dart';

class CharacterRemove {
  String gameName;
  String creator;
  GameInfo character;

  CharacterRemove(
      {required this.gameName, required this.creator, required this.character});

  // Convert a CharacterRemove instance to a Map
  Map<String, dynamic> toJson() => {
        'gameName': gameName,
        'creator': creator,
        'character':
            character.ToJson(), // Assuming GameInfo has a toJson method
      };

  factory CharacterRemove.fromJson(Map<String, dynamic> json) =>
      CharacterRemove(
          gameName: json['gameName'],
          creator: json['creator'],
          character: GameInfo.fromJson2(
              json['character']) // Assuming GameInfo has a fromJson method

          );
}
