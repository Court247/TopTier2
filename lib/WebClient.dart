import 'package:http/http.dart' as http;

///Class imports
import 'GameParser.dart';

///Net: handles getting the response from the URL
class WebClient {
  var server;

  ///unnamed constructor
  WebClient(this.server);

  /// Documentation for getInfo
  ///
  /// > _`@returns: [dynamic]`_
  getInfo() async {
    //parses the server address into a uri
    var uri = Uri.parse(server);

    //gets the response message from the server
    var response = await http.get(uri);

    //calls the QuizParser class to get the information
    var j_son = GameParser.constr(response).infoResponse();

    //returns the information
    return j_son;
  }
}
