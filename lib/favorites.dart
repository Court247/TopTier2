import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:toptier/favoritesprovider.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
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
  changeChar() {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    final favs = provider.favorites;
    int i = 0;
    while (i < favs.length) {
      favs[i].isFavorite = false;
      favs[i].canAdd = true;
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
                              MaterialStatePropertyAll(Colors.pink.shade100)),
                      onPressed: () {
                        setState(() {
                          changeChar();
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
                              MaterialStatePropertyAll(Colors.pink.shade100)),
                      onPressed: () {
                        setState(() {
                          changeChar();
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final favorites = provider.favorites;

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
                contentPadding: const EdgeInsets.all(5),
                hoverColor: Colors.pink.shade50,
                selectedTileColor: Colors.pink.shade50,
                leading: Image.network(
                  favs.image,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  '${favs.name}',
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
                  isFavorite: favs.isFavorite,
                  //make it so that "canAdd is changed "
                  valueChanged: (fav) {
                    favs.isFavorite = fav;
                    // if (fav) {
                    //   favs.canAdd = false;
                    // }
                    provider.addFav(favs);
                  },
                ),
                onTap: () {},
              );
            },
          )),
        ],
      ),
    );
  }
}
