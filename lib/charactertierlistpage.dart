import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GameInfo.dart';
import 'characterprofile.dart';
import 'favoritesprovider.dart';
import 'CharacterRemove.dart';

///Widget that shows the list of CharacterTierList Tierlists
class CharacterTierList extends StatelessWidget {
  final String gameName;
  final String creator;
  final List<GameInfo> gameInfo;

  CharacterTierList({
    super.key,
    required this.gameName,
    required this.creator,
    required this.gameInfo,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: Text(
          '${gameName}',
          style: const TextStyle(fontSize: 30, fontFamily: 'Horizon'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SafeArea(
        child: CharacterTierListPage(
          gameName: gameName,
          creator: creator,
          gameInfo: gameInfo,
        ),
      ),
    ));
  }
}

class CharacterTierListPage extends StatefulWidget {
  final String gameName;
  final String creator;
  final List<GameInfo> gameInfo;

  const CharacterTierListPage({
    super.key,
    required this.gameName,
    required this.creator,
    required this.gameInfo,
  });

  @override
  State<CharacterTierListPage> createState() => _CharacterTierListPageState(
        gameName: gameName,
        creator: creator,
        gameInfo: gameInfo,
      );
}

class _CharacterTierListPageState extends State<CharacterTierListPage> {
  String gameName;
  String creator;
  var db;
  final List<GameInfo> gameInfo;
  late List<GameInfo> gInfo = gameInfo;
  final characterSearch = TextEditingController();
  late CharacterRemove characterInfo;

  _CharacterTierListPageState({
    required this.gameName,
    required this.creator,
    required this.gameInfo,
  });

  /// Documentation for searchGame
  /// > * _`@param: [String]`_ - query
  ///
  /// > _`@returns: [List]`_
  searchGame(String query) {
    final suggestions = gameInfo.where((character) {
      final characterName = character.name.toLowerCase();
      final input = query.toLowerCase();

      return characterName.contains(input);
    }).toList();

    setState(() => gInfo = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context, listen: true);
    db = Provider.of<FirebaseFirestore>(context, listen: false);

    return Column(children: [
      SizedBox(
        height: 35,
        child: TextField(
          controller: characterSearch,
          decoration: InputDecoration(
              prefix: const Icon(Icons.filter_alt),
              hintText: 'Search name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.pink))),
          onChanged: searchGame,
        ),
      ),
      Expanded(
          child: ListView.builder(
        primary: true,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        itemCount: gInfo.length,
        itemBuilder: (context, index) {
          final character = gInfo[index];
          return ListTile(
            key: ValueKey<String?>(character.id),
            contentPadding: const EdgeInsets.all(5),
            hoverColor: Colors.pink.shade50,
            selectedTileColor: Colors.pink.shade50,
            leading: Image.network(
              character.image,
              fit: BoxFit.cover,
            ),
            title: Text(
              '${character.name}',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Horizon',
                  color: Colors.pink.shade200),
            ),
            subtitle: character.title != null
                ? Text(
                    '${character.title}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : null,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(8.5),
                side: BorderSide(
                  color: Colors.pink.shade100,
                )),
            trailing: FavoriteButton(
              iconColor: Colors.pinkAccent.shade400,
              iconSize: 35.5,
              isFavorite: character.isFavorite,
              valueChanged: (favorite) {
                character.isFavorite = favorite;
                character.canAdd = !favorite;
                characterInfo = CharacterRemove(
                  gameName: gameName,
                  creator: creator,
                  character: character,
                );
                if (favorite) {
                  provider.addFav(characterInfo);
                } else {
                  provider.removeFav(character.id);
                }

                db.collection(gameName).doc((index + 1).toString()).update({
                  'isFavorite': character.isFavorite,
                  'canAdd': character.canAdd,
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterProfile(
                    gameName: gameName,
                    creator: creator,
                    character: character,
                  ),
                ),
              );
            },
          );
        },
      )),
    ]);
  }
}
