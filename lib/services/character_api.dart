import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';

class CharacterApi {
  static Future<List<Character>> fetchCharacters() async {
    final response = await http.get(
      Uri.parse('https://potterapi-fedeperin.vercel.app/en/characters'),
    );
    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки: HTTP ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data is! List) {
      throw const FormatException('API вернул данные в неожиданном формате');
    }

    return data
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
