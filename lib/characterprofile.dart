import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GameInfo.dart';

/// Shows profile information of character
class CharacterProfile extends StatelessWidget {
  final String gameName;
  final String creator;
  final GameInfo character;

  const CharacterProfile({
    super.key,
    required this.gameName,
    required this.creator,
    required this.character,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink.shade100,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade100,
          title: Text(
            '${character.name}',
            style: const TextStyle(fontSize: 30, fontFamily: 'Horizon'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.pink.shade50,
        body: Character(
            gameName: gameName, creator: creator, character: character),
      ),
    );
  }
}

class Character extends StatefulWidget {
  final String gameName;
  final String creator;
  final GameInfo character;
  const Character(
      {super.key,
      required this.gameName,
      required this.creator,
      required this.character});

  @override
  State<Character> createState() => CharacterState(
      gameName: gameName, creator: creator, character: character);
}

class CharacterState extends State<Character> {
  String gameName;
  String creator;
  GameInfo character;

  List<Color> colorss = [
    Colors.pink,
    Colors.pink.shade500,
    Colors.pink.shade300,
    Colors.pink.shade100,
    Colors.pink.shade50,
  ];
  static const colorizing = TextStyle(
    fontSize: 60.0,
    fontFamily: 'Horizon',
  );
  String overAll = '';
  int i = 0;
  CharacterState(
      {required this.gameName, required this.creator, required this.character});

  initState() {
    super.initState();
  }

  /// Documentation for overAllRating
  /// > _`@returns: [void]`_
  ///
  ///Calculates the over all rating score of the character
  overAllRating() {
    // Convert each rating to a double and sum them up
    var sum = character.rating.values
        .map((rating) => double.parse(rating))
        .reduce((value, element) => value + element);

    // Divide by the number of ratings
    var average = sum / character.rating.length;

    // Notifies that the value number has changed
    setState(() {
      overAll = average.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                //margin: const EdgeInsets.all(5),
                height: 100,
                width: 100,
                color: Colors.pink.shade50,
                child: Image.network(character.image),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Class: ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${character.characterClass}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  character.horoscope != null
                      ? Row(
                          children: [
                            const Text(
                              'Horoscope: ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${character.horoscope}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    children: [
                      const Text(
                        'Element: ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${character.element}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Rarity: ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${character.rarity}★',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(' ${gameName}',
                        textStyle: colorizing, colors: colorss),
                  ],
                  isRepeatingAnimation: true,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(gradient: LinearGradient(colors: colorss)),
                child: const Text(
                  'Rating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Horizon',
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.white, blurRadius: 20.0)]),
                ),
              )
            ],
          ),
          DataTable(
            columnSpacing: 10,
            dividerThickness: 4.0,
            columns: character.rating.keys
                .map((key) => DataColumn(label: Expanded(child: Text(key))))
                .toList(),
            rows: <DataRow>[
              DataRow(
                cells: character.rating.values
                    .map((value) => DataCell(Text(value)))
                    .toList(),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration:
                BoxDecoration(gradient: LinearGradient(colors: colorss)),
            child: const Text(
              'Stats',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Horizon',
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.white, blurRadius: 20.0)]),
            ),
          ),
          DataTable(
            columnSpacing: 17,
            dividerThickness: 3.0,
            columns: character.stats.keys
                .map((key) =>
                    DataColumn(label: Expanded(child: Text(key.toUpperCase()))))
                .toList(),
            rows: <DataRow>[
              DataRow(
                cells: character.stats.values
                    .map((value) => DataCell(Text(value.toString())))
                    .toList(),
              ),
            ],
          ),
          //THis is okay
          //This is the artifacts in Epic Seven
          Center(
            child: character.artifact != null && character.artifact!.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: character.artifact?.length,
                    itemBuilder: ((context, i) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: colorss)),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${character.artifact?[i]['title']}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Horizon',
                                  fontStyle: FontStyle.italic,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8.0)
                                  ]),
                            ),
                          ),
                          Text(character.artifact?[i]['custom_title'],
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          Image.network(character.artifact?[i]['image'],
                              scale: 2.0),
                          Text(
                            character.artifact?[i]['description'],
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }),
                  )
                : Container(),
          ),
          //THis is okay
          Container(
            width: double.infinity,
            decoration:
                BoxDecoration(gradient: LinearGradient(colors: colorss)),
            child: const Text(
              'Overview',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Horizon',
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.white, blurRadius: 20.0)]),
            ),
          ),
          //This is ok
          SizedBox(
            width: double.infinity,
            child: Text(
              '${character.description}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          //this is okay
          //This is the gear sets in Epic Seven
          ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(), // Add this line
            shrinkWrap: true,
            itemCount: character.sets.length,
            itemBuilder: ((context, i) {
              return character.sets[i]['set_1'] != null
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: colorss)),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${character.sets[i]['title']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Horizon',
                                fontStyle: FontStyle.italic,
                                shadows: [
                                  Shadow(color: Colors.white, blurRadius: 8.0)
                                ]),
                          ),
                        ),
                        Text(
                            '${character.sets[i]['set_1']}/${character.sets[i]['set_2']}\n',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text('Necklace',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${character.sets[i]['necklace']}\n',
                            style: const TextStyle(fontSize: 20)),
                        const Text('Ring',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${character.sets[i]['ring']}\n',
                            style: const TextStyle(fontSize: 20)),
                        const Text('Boots',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${character.sets[i]['boots']}\n',
                            style: const TextStyle(fontSize: 20)),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: colorss)),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${character.sets[i]['title']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Horizon',
                                fontStyle: FontStyle.italic,
                                shadows: [
                                  Shadow(color: Colors.white, blurRadius: 8.0)
                                ]),
                          ),
                        ),
                        Text(
                          '${character.sets[i]['description']}\n',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${character.sets[i]['4_set']['title']} x4\n',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${character.sets[i]['4_set']['description']}\n',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${character.sets[i]['2_set']['title']} x2\n',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${character.sets[i]['2_set']['description']} x4\n',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        const Row(
                          children: [
                            Text(
                              'UNA II\n',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            Text(
                              'UNA IV\n',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Spacer(),
                            Text(
                              'MUI II\n',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${character.sets[i]['una_ii']}\n',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            Text(
                              '${character.sets[i]['una_iv']}\n',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            Text(
                              '${character.sets[i]['mui_ii']}\n',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    );
            }),
          ),
          Container(
            width: double.infinity,
            decoration:
                BoxDecoration(gradient: LinearGradient(colors: colorss)),
            child: const Text(
              'Links',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Horizon',
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.white, blurRadius: 20.0)]),
            ),
          ),
          Text(
            character.link,
            style: const TextStyle(fontSize: 20),
          ),
          IconButton(
            onPressed: () async {
              var url = Uri.parse(character.link);
              launchUrl(url, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(
              Icons.favorite,
              size: 40,
              color: Colors.pinkAccent,
            ),
          )
        ],
      ),
    );
  }
}
