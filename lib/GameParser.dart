import 'dart:convert';
import 'Info.dart';

///Parses the Game information
class GameParser {
  var response;

  GameParser();
  GameParser.constr(this.response);

  /// Documentation for infoResponse
  ///
  /// > _`@returns: [Info]`_
  ///
  ///Gets the information from the server and allocates it's information in the info class
  Info infoResponse() {
    //decodes the json encoded response.
    var decoder = json.decode(response!.body);

    //Returns class Info with json String allocating information
    return Info(decoder['gameName'], decoder['creator'], decoder['Characters']);
    /*if (decoder.containsKey('tag')) {
      return Info.constr(decoder['characters']);
    } else {
      return Info(decoder['response'], decoder['quiz']);
    }*/
  }
}
