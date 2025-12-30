import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl = 'http://34.45.111.55:8000/query';

  Future<String> getAIResponse(String question, {String plantType = ""}) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question': question,
          'plantType': plantType,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          if (data is Map) {
            if (data.containsKey('response')) {
              return data['response'].toString();
            } else if (data.containsKey('answer')) {
              return data['answer'].toString();
            } else {
              return utf8.decode(response.bodyBytes);
            }
          } else {
            return data.toString();
          }
        } catch (e) {
          return utf8.decode(response.bodyBytes);
        }
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
