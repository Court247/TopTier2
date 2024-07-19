///Instance of GameInfo that holds all the character's information
class GameInfo {
  String? id;
  String name;
  String? title;
  String image;
  String characterClass;
  String element;
  String? horoscope;
  String rarity;
  Map rating;
  List? artifact;
  List sets;
  String description;
  Map stats;
  String link;
  bool isFavorite;
  bool canAdd;
  bool isOwned;

  GameInfo(
      {this.id,
      required this.name,
      this.title,
      required this.image,
      required this.characterClass,
      required this.element,
      this.horoscope,
      required this.rarity,
      required this.rating,
      this.artifact,
      required this.sets,
      required this.description,
      required this.stats,
      required this.link,
      this.isFavorite = false,
      this.canAdd = true,
      this.isOwned = false});

  /// Documentation for ToJson
  ///
  /// > _`@returns: [Map]`_
  ///
  /// Turns a single instance into json String
  ToJson() {
    Map data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['image'] = this.image;
    data['class'] = this.characterClass;
    data['element'] = this.element;
    data['horoscope'] = this.horoscope;
    data['rarity'] = this.rarity;
    data['rating'] = this.rating;
    data['artifact'] = this.artifact;
    data['sets'] = this.sets;
    data['description'] = this.description;
    data['link'] = this.link;
    data['stats'] = this.stats;
    data['isFavorite'] = this.isFavorite;
    data['canAdd'] = this.canAdd;
    data['isOwned'] = this.isOwned;
    return data;
  }

  FromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    image = json['image'];
    characterClass = json['class'];
    element = json['element'];
    horoscope = json['horoscope'];
    rarity = json['rarity'];
    rating = json['rating'];
    artifact = json['artifact'];
    sets = json['sets'];
    description = json['description'];
    link = json['link'];
    stats = json['stats'];
    isFavorite = json['isFavorite'];
  }
}
