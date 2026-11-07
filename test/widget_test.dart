import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:controll_job_1/models/character.dart';
import 'package:controll_job_1/models/book.dart';
import 'package:controll_job_1/models/house.dart';
import 'package:controll_job_1/models/spell.dart';
import 'package:controll_job_1/screens/characters_page.dart';
import 'package:controll_job_1/widgets/character_card.dart';

void main() {
  testWidgets('shows characters and details from the API', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CharactersPage(
          characterLoader: () async => const [
            Character(
              fullName: 'Harry James Potter',
              nickname: 'Harry',
              house: 'Gryffindor',
              actor: 'Daniel Radcliffe',
              children: ['James Sirius Potter'],
              image: '',
              birthdate: 'Jul 31, 1980',
            ),
          ],
          houseLoader: () async => const [
            House(
              name: 'Gryffindor',
              emoji: '🦁',
              founder: 'Godric Gryffindor',
              colors: ['red', 'gold'],
              animal: 'Lion',
            ),
          ],
          bookLoader: () async => const [
            Book(
              number: 1,
              title: "Harry Potter and the Sorcerer's Stone",
              originalTitle: "Harry Potter and the Sorcerer's Stone",
              releaseDate: 'Jun 26, 1997',
              description: 'The first year at Hogwarts.',
              pages: 223,
              cover: '',
            ),
          ],
          spellLoader: () async => const [
            Spell(name: 'Lumos', use: 'Makes wand emit light'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Harry James Potter'), findsOneWidget);
    expect(find.text('Gryffindor'), findsWidgets);
    expect(find.text('Daniel Radcliffe'), findsOneWidget);
    expect(find.text('Jul 31, 1980'), findsOneWidget);
    expect(find.text('James Sirius Potter'), findsOneWidget);
    expect(find.text('Герои волшебного мира'), findsOneWidget);
  });

  testWidgets('disintegrates a character card when tapped', (
    WidgetTester tester,
  ) async {
    var disintegrated = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CharacterCard(
            character: const Character(
              fullName: 'Harry James Potter',
              nickname: 'Harry',
              house: 'Gryffindor',
              actor: 'Daniel Radcliffe',
              children: [],
              image: '',
              birthdate: 'Jul 31, 1980',
            ),
            onDisintegrated: () => disintegrated = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Harry James Potter'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(disintegrated, isTrue);
  });

  testWidgets('navigates through houses, books, and spells', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CharactersPage(
          characterLoader: () async => const [],
          houseLoader: () async => const [
            House(
              name: 'Gryffindor',
              emoji: '🦁',
              founder: 'Godric Gryffindor',
              colors: ['red', 'gold'],
              animal: 'Lion',
            ),
          ],
          bookLoader: () async => const [
            Book(
              number: 1,
              title: "Harry Potter and the Sorcerer's Stone",
              originalTitle: "Harry Potter and the Sorcerer's Stone",
              releaseDate: 'Jun 26, 1997',
              description: 'The first year at Hogwarts.',
              pages: 223,
              cover: '',
            ),
          ],
          spellLoader: () async => const [
            Spell(name: 'Lumos', use: 'Makes wand emit light'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Факультеты'));
    await tester.pumpAndSettle();
    expect(find.text('Факультеты Хогвартса'), findsOneWidget);
    expect(find.text('Godric Gryffindor'), findsOneWidget);

    await tester.tap(find.text('Книги'));
    await tester.pumpAndSettle();
    expect(find.text("Harry Potter and the Sorcerer's Stone"), findsOneWidget);

    await tester.tap(find.text('Заклинания'));
    await tester.pumpAndSettle();
    expect(find.text('Lumos'), findsOneWidget);
    expect(find.text('Makes wand emit light'), findsOneWidget);

    await tester.tap(find.text('Lumos'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Свет озаряет кончик волшебной палочки'), findsOneWidget);
    expect(find.text('Великолепно'), findsOneWidget);
    await tester.tap(find.text('Великолепно'));
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('toggles between Hogwarts light and dark themes', (
    WidgetTester tester,
  ) async {
    var isDark = false;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: CharactersPage(
            isDark: isDark,
            onThemeToggle: () => setState(() => isDark = !isDark),
            characterLoader: () async => const [],
            houseLoader: () async => const [],
            bookLoader: () async => const [],
            spellLoader: () async => const [],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Включить тёмную тему'), findsOneWidget);
    await tester.tap(find.byTooltip('Включить тёмную тему'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Включить светлую тему'), findsOneWidget);
  });
}
