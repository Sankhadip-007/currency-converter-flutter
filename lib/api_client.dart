import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient{
  String url="https://api.apilayer.com/exchangerates_data/symbols?apikey=n8zvPRU9FKOdAuJPMllz6UnUOC0qibOX";

  Future<Map<String, dynamic>> getJSONData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from URL');
    }
  }


}
