import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/character.dart';
import '../models/house.dart';
import '../models/spell.dart';

class CharacterApi {
  static Future<List<Character>> fetchCharacters() async {
    final data = await _fetchList('characters');
    return data.map(Character.fromJson).toList();
  }

  static Future<List<House>> fetchHouses() async {
    final data = await _fetchList('houses');
    return data.map(House.fromJson).toList();
  }

  static Future<List<Book>> fetchBooks() async {
    final data = await _fetchList('books');
    return data.map(Book.fromJson).toList();
  }

  static Future<List<Spell>> fetchSpells() async {
    final data = await _fetchList('spells');
    return data.map(Spell.fromJson).toList();
  }

  static Future<List<Map<String, dynamic>>> _fetchList(String endpoint) async {
    final response = await http.get(
      Uri.parse('https://potterapi-fedeperin.vercel.app/en/$endpoint'),
    );
    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки: HTTP ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data is! List) {
      throw const FormatException('API вернул данные в неожиданном формате');
    }

    return data.map((item) => item as Map<String, dynamic>).toList();
  }
}
