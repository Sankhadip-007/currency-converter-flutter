import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient{
  String url="https:your_url_to_get_all_currencies/symbols?apikey=your_api_key";

  Future<Map<String, dynamic>> getJSONData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from URL');
    }
  }


}
