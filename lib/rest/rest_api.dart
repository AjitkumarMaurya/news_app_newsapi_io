import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_newsapi_io/model/headline_response.dart';
import '../utils/preference.dart';


class ApiCall {
  final endPointUrl = "newsapi.org";
  final client = http.Client();
  Future<List<Articles>> getArticle(String _connectionStatus) async {


    final queryParameters = {
        'country': 'in',
        'apiKey': 'a34f17e6e15b4990b992da88c477a2d6'
      };
      final uri = Uri.https(endPointUrl, '/v2/top-headlines', queryParameters);
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        PreferenceManager().setPref("dataList",response.body);
        final List data = body['articles'];
        return data.map((e) => Articles.fromJson(e)).toList();
      } else if (response.statusCode == 429) {
        throw Exception('Too Many Requests');
      } else if (response.statusCode == 500) {
        throw Exception('Server Error.');
      } else {
        throw Exception('Error');
      }
  }
}