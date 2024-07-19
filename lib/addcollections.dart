import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Games.dart';
import 'Gaming.dart';
import 'GameInfo.dart';

class AddToCollection {
  late final db;
  late final storage;
  List<Games> games = [];
  late Gaming game;
  List<GameInfo> gameInfo = [];
  List<Games> gamingList = [];

  addToCollection() async {
    int i = 0;
    while (i < games.length) {
      var batch = db.batch();

      for (int j = 0; j < games[i].characters.length; j++) {
        var docRef = db.collection(games[i].gameName).doc((j + 1).toString());
        var docSnapshot = await docRef.get();

        if (!docSnapshot.exists ||
            (!docSnapshot.data().containsKey('name') ||
                docSnapshot['name'] != games[i].characters[j].name)) {
          batch.set(docRef, games[i].characters[j].ToJson());
        }
      }

      await batch.commit();
      i++;
    }
  }

  getCollectionLength() {
    var collection = db.collection('Epic7');
    var snapshot = collection.get();
    return snapshot.docs.length;
  }

  getPath(gameName) async {
    String? url;
    try {
      Reference ref = storage.ref('Tierlists/${gameName}.txt');

      url = await ref.getDownloadURL();
      // Use the URL to download or read the file
    } catch (e) {
      // Handle any errors
    }
    return url;
  }

  void addCollection(gameName) async {
    var countDoc = await db.collection('CollectionData').doc(gameName).get();
    var name = countDoc.data()['name'];
    var count = countDoc.data()['count'];

    if (count == null && name == null) {
      db
          .collection('CollectionData')
          .doc(gameName)
          .set({'name': gameName, 'count': 1});
    } else {
      db
          .collection('CollectionData')
          .doc(gameName)
          .update({'count': count + 1});
    }
  }

  void listAllFiles() async {
    ListResult result = await storage.ref().listAll();

    result.items.forEach((Reference ref) async {
      String downloadURL = await ref.getDownloadURL();
      print('Found file: $downloadURL');
      // You can now use the downloadURL to download the file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Collection'),
      ),
      body: Center(
        child: Text('Adding data to collection in the background...'),
      ),
    );
  }
}
