import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptier/favoritesprovider.dart';

import 'CharacterRemove.dart';
import 'characterprofile.dart';

///Favorites page that shows the list of currently saved favorited characters.
class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: const Text(
          'Favorites',
          style: TextStyle(fontSize: 30, fontFamily: 'Horizon'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return const Settings();
                // }));
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      backgroundColor: Colors.pink.shade50,
      body: const SafeArea(
        child: FavoriteList(),
      ),
    ));
  }
}

class FavoriteList extends StatefulWidget {
  const FavoriteList({
    super.key,
  });

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  /// Documentation for changeChar
  /// > _`@returns: [dynamic]`_
  ///
  /// changes the isFavorite and canAdd variables to default
  changeChar(List<CharacterRemove> favs) {
    int i = 0;
    while (i < favs.length) {
      print(favs[i].character.name);
      favs[i].character.isFavorite = false;
      favs[i].character.canAdd = true;
      findDocID(favs[i].character.id, favs[i].gameName);
      i++;
    }
  }

  /// Documentation for confirmation
  /// > _`@returns: [void]`_
  ///
  /// When pressed, it shows an Alert box asking user if they're sure they want to erase favorites list
  void confirmation() {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);

    if (provider.favorites.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Empty List!'),
                icon: const Icon(
                  Icons.priority_high,
                  color: Colors.red,
                  size: 30,
                ),
                content: const Text(
                  'Your list is empty! Try adding to your list first :)',
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.pink.shade100)),
                      onPressed: () {
                        setState(() {
                          changeChar(provider.favorites);
                        });
                        provider.clearFavorite();

                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.pink.shade100),
                      ))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Are You Sure?'),
                icon: const Icon(
                  Icons.priority_high,
                  color: Colors.red,
                  size: 30,
                ),
                content: const Text(
                  'You are clearing your favorites list and this action CANNOT be undone.',
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.pink.shade100)),
                      onPressed: () {
                        setState(() {
                          changeChar(provider.favorites);
                        });
                        provider.clearFavorite();

                        Navigator.pop(context);
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.pink.shade100),
                      ))
                ],
              ));
    }
  }

  findDocID(characterID, gameName) async {
    final db = Provider.of<FirebaseFirestore>(context, listen: false);
    var snapshot =
        await db.collection(gameName).where('id', isEqualTo: characterID).get();

    if (snapshot.docs.isNotEmpty) {
      print(snapshot.docs.first.id);
      db.collection(gameName).doc(snapshot.docs.first.id).update({
        'isFavorite': false,
        'canAdd': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final favorites = provider.favorites;
    final user = Provider.of<FirebaseAuth>(context, listen: false);
    final db = Provider.of<FirebaseFirestore>(context, listen: false);
    late CharacterRemove favsInfo;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade100,
        tooltip: 'Tap to clear favorites list',
        onPressed: () {
          confirmation();
        },
        child: const Icon(Icons.clear),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            primary: true,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favs = favorites[index];
              return ListTile(
                key: ValueKey<String?>(favs.character.id),
                contentPadding: const EdgeInsets.all(5),
                hoverColor: Colors.pink.shade50,
                selectedTileColor: Colors.pink.shade50,
                leading: Image.network(
                  favs.character.image,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  '${favs.character.name}',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Horizon',
                      color: Colors.pink.shade200),
                ),
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(8.5),
                    side: BorderSide(
                      color: Colors.pink.shade100,
                    )),
                trailing: FavoriteButton(
                  iconColor: Colors.pinkAccent.shade400,
                  iconSize: 35.5,
                  isFavorite: favs.character.isFavorite,
                  //make it so that "canAdd is changed "
                  valueChanged: (favorite) {
                    favs.character.isFavorite = favorite;
                    favs.character.canAdd = !favorite;
                    provider.removeFav(favs.character.id);
                    findDocID(favs.character.id, favs.gameName);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterProfile(
                        gameName: favs.gameName,
                        creator: favs.creator,
                        character: favs.character,
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
