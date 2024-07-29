import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GameInfo.dart';
import 'characterprofile.dart';
import 'favoritesprovider.dart';
import 'CharacterRemove.dart';
import 'settingspage.dart';
import 'userpreferences.dart';

///Widget that shows the list of CharacterTierList Tierlists
class CharacterTierList extends StatelessWidget {
  final String gameName;
  final String creator;
  final List<GameInfo> gameInfo;

  const CharacterTierList({
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
          IconButton(
            icon: const Icon(Icons.more_vert_sharp),
            onPressed: () {
              showModalBottomSheet(
                context: context, // You need to pass the BuildContext
                builder: (BuildContext context) {
                  return Container(
                    height: 200, // Set the height of the bottom sheet
                    color: Colors.white, // Background color of the bottom sheet
                    child: ListView(
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.settings), // Example list tile
                          title: const Text('Settings'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            ); // Close the bottom sheet
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.logout), // Example list tile
                          title: const Text('Log Out'),
                          onTap: () {
                            // Handle the tap
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                AppSettings.openAppSettings();
              }),
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
  final List<GameInfo> gameInfo;
  late List<GameInfo> gInfo = gameInfo;
  final characterSearch = TextEditingController();
  late CharacterRemove characterInfo;
  late final provider;
  late final user;
  late final sharedPrefs;
  late final db;
  bool _isInitialized = false; // Define the flag here

  _CharacterTierListPageState({
    required this.gameName,
    required this.creator,
    required this.gameInfo,
  });

  @override
  void initState() {
    super.initState();
    // Other initialization code if needed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      provider = Provider.of<FavoriteProvider>(context);
      user = Provider.of<FirebaseAuth>(context);
      sharedPrefs = Provider.of<UserPreferences>(context);
      db = Provider.of<FirebaseFirestore>(context);
      updateTierPageFavs();
      _isInitialized = true;
    }
  }

  updateTierPageFavs() {
    final List<CharacterRemove> favorites = provider.favorites;
    gameInfo.forEach((character) {
      final bool isFavorite =
          favorites.any((fav) => fav.character.id == character.id);
      character.isFavorite = isFavorite;
      character.canAdd = !isFavorite;
    });
    setState(() => gInfo = gameInfo);
  }

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
    print(
        'Favorites List from CharacterTierListPage: ${provider.favorites.length}');

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
                sharedPrefs.saveUserFavorites(
                    user.currentUser!.uid, 'favorites', provider.favorites);
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
