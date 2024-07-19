import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:toptier/Games.dart';
import 'package:toptier/charactertierlistpage.dart';
import 'WebClient.dart';
import 'GameInfo.dart';
import 'favorites.dart';

class TopTierGames extends StatelessWidget {
  const TopTierGames({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink.shade100,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TopTierGamesPage(),
    );
  }
}

class TopTierGamesPage extends StatefulWidget {
  const TopTierGamesPage({super.key});

  @override
  State<TopTierGamesPage> createState() => TopTierGamesPageState();
}

class TopTierGamesPageState extends State<TopTierGamesPage> {
  late final db;
  late final storage;
  final gameSearch = TextEditingController();
  List<Games> games = [];
  List<GameInfo> gameInfo = [];
  List<Games> gamingList = [];
  List<Color> colorings = [
    Colors.white,
    Colors.pink.shade50,
    Colors.pink.shade100,
    Colors.pink.shade300,
    Colors.pink
  ];

  @override
  initState() {
    super.initState();
    db = Provider.of<FirebaseFirestore>(context, listen: false);
    storage = Provider.of<FirebaseStorage>(context, listen: false);
    keepUpdated();
  }

  keepUpdated() async {
    final storageRef = storage.ref().child("Tierlists/");
    final listResult = await storageRef.listAll();

    for (int i = 0; i < listResult.items.length; i++) {
      print('Reference Name: ${listResult.items[i].name}');
      var ref = listResult.items[i];
      print("Ref: ${ref.name}");
      var refName = ref.name.replaceAll('.txt', '');
      print("RefName: $refName");
      final url = await getPath(ref.name);
      print("URL: $url");
      await addCharacters(url);
    }
  }

  getPath(gameName) async {
    String? url;
    try {
      Reference ref = storage.ref('Tierlists/${gameName}');

      url = await ref.getDownloadURL();
      // Use the URL to download or read the file
    } catch (e) {
      // Handle any errors
      print(e);
    }
    return url;
  }

  addCharacters(url) async {
    // Gets response json string
    var temp = WebClient(url).getInfo();

    //Converts from Future<String> to String
    var getInfo = await temp;
    addCollection(getInfo);
    setCollection(getInfo);
    getCharacters(getInfo);
  }

  void addCollection(gameInfo) async {
    var countDoc = await db.collection('Games').doc(gameInfo.gameName).get();
    var docInfo = countDoc.data();

    if (docInfo == null) {
      db.collection('GameData').doc(gameInfo.gameName).set({
        'name': gameInfo.gameName,
        'creator': gameInfo.creator,
        'count': gameInfo.characters.length,
      });
    }
  }

  setCollection(gameInfo) async {
    int i = 0;

    while (i < gameInfo.characters.length) {
      bool exists = await searchCollection(
          gameInfo.characters[i]['name'], gameInfo.gameName);

      if (!exists) {
        db.collection(gameInfo.gameName).doc((i + 1).toString()).set({
          'name': gameInfo.characters[i]['name'],
          'title': gameInfo.characters[i]['title'],
          'image': gameInfo.characters[i]['image'],
          'class': gameInfo.characters[i]['class'],
          'element': gameInfo.characters[i]['element'],
          'horoscope': gameInfo.characters[i]['horoscope'],
          'rarity': gameInfo.characters[i]['rarity'],
          'rating': gameInfo.characters[i]['rating'],
          'artifact': gameInfo.characters[i]['artifact'],
          'sets': gameInfo.characters[i]['sets'],
          'description': gameInfo.characters[i]['description'],
          'stats': gameInfo.characters[i]['stats'],
          'link': gameInfo.characters[i]['link'],
          'isFavorite': gameInfo.characters[i]['isFavorite'] ?? false,
          'canAdd': gameInfo.characters[i]['canAdd'] ?? true,
          'isOwned': gameInfo.characters[i]['isOwned'] ?? false,
        });
      } else {
        var docRef = db.collection(gameInfo.gameName).doc((i + 1).toString());

        Map<String, dynamic> oldData = {};

        docRef.snapshots().listen((docSnapshot) {
          if (docSnapshot.exists) {
            Map<String, dynamic> newData = docSnapshot.data();

            if (oldData != null && !mapEquals(oldData, newData)) {
              docRef.update(newData);
            }
          }
        });
      }
      i++;
    }
  }

  searchCollection(name, gameName) async {
    var querySnapshot =
        await db.collection(gameName).where('name', isEqualTo: name).get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void getCharacters(data) async {
    final gameRef = db.collection(data.gameName);
    final gameDoc = await gameRef.get();
    final gameData = gameDoc.docs.map((doc) => doc.data()).toList();
    gameData
        .map((data) => gameInfo.add(GameInfo(
            name: data['name'],
            title: data['title'],
            image: data['image'],
            characterClass: data['class'],
            element: data['element'],
            horoscope: data['horoscope'],
            rarity: data['rarity'],
            rating: data['rating'],
            artifact: data['artifact'],
            sets: data['sets'],
            description: data['description'],
            stats: data['stats'],
            link: data['link'],
            isFavorite: data['isFavorite'],
            canAdd: data['canAdd'],
            isOwned: data['isOwned'])))
        .toList();
    addToGames(gameInfo, data.gameName, data.creator);
    gameInfo = [];
    print("Games: ${games.length}");
    setState(() {
      gamingList = games;
    });
    print("GamingList: ${gamingList.length}");
  }

  addToGames(List<GameInfo> gameInfo, String gameName, String creator) {
    gameInfo.sort((a, b) => a.name.compareTo(
        b.name)); // Assuming 'name' is the property you want to sort by

    setState(() => games.add(
        Games(gameName: gameName, creator: creator, characters: gameInfo)));
  }

  /// Documentation for searchGame
  /// > * _`@param: [String]`_ - query
  ///
  /// > _`@returns: [void]`_
  ///
  /// In charge of searching using the text field to find the game tierlist
  void searchGame(String query) {
    //Searches and creates new list of games that matches the query String
    //everytime the text field is changed
    final suggestions = games.where((game) {
      final gamesName = game.gameName.toLowerCase();
      final input = query.toLowerCase();

      //return the instance that == the query String
      return gamesName.contains(input);
    }).toList();

    //sets the state back to gameList to refill the list of previous games
    setState(() => gamingList = suggestions);
  }

  Future<void> _refreshData() async {
    // Clear your existing data
    setState(() {
      games.clear();
    });

    // Fetch your new data
    await keepUpdated();

    // Update your state with the new data
    setState(() {
      games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.pink.shade100),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                      fontSize: 30, fontFamily: 'Horizon', color: Colors.white),
                )),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: Colors.pinkAccent.shade400,
                opticalSize: 10.5,
              ),
              title: Text(
                'Favorites',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Horizon',
                    color: Colors.pink.shade200),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Favorites()));
              },
              selected: false,
              selectedColor: Colors.pink.shade50,
              hoverColor: Colors.pink.shade50,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8.5),
                  side: BorderSide(
                      color: Colors.pink.shade50,
                      strokeAlign: BorderSide.strokeAlignInside)),
            ),
          ],
        ),
      ),
      appBar: AppBar(
          title: const Text(
            'Game Tierlists',
            style: TextStyle(fontSize: 30, fontFamily: 'Horizon'),
          ),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          ],
          backgroundColor: Colors.pink.shade100),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 35,
            child: TextFormField(
              controller: gameSearch,
              decoration: InputDecoration(
                  prefix: const Icon(Icons.search),
                  hintText: 'Game Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.pink))),
              onChanged: searchGame,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(5),
                    itemCount: gamingList.length,
                    itemBuilder: (context, index) {
                      final g = gamingList[index];
                      return ListTile(
                        title: Text(
                          '${g.gameName}',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Horizon',
                            color: Colors.pink.shade200,
                          ),
                        ),
                        subtitle: Text(
                          ' Created by: ${g.creator}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        selected: false,
                        selectedColor: Colors.pink.shade50,
                        hoverColor: Colors.pink.shade50,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(8.5),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 254, 205, 222),
                                strokeAlign: BorderSide.strokeAlignInside)),
                        trailing: Text(
                          '${g.characters.length} characters',
                          style: const TextStyle(
                              color: Colors.black45,
                              fontStyle: FontStyle.italic),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CharacterTierList(
                                        gameName: g.gameName,
                                        creator: g.creator,
                                        gameInfo: g.characters,
                                      )));
                        },
                      );
                    })),
          ),
        ],
      ),
    );
  }
}
