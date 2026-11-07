import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:controll_job_1/models/character.dart';
import 'package:controll_job_1/screens/characters_page.dart';

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
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Harry James Potter'), findsOneWidget);
    expect(find.text('Факультет: Gryffindor'), findsOneWidget);
    expect(find.text('Актёр: Daniel Radcliffe'), findsOneWidget);
    expect(find.text('Дата рождения: Jul 31, 1980'), findsOneWidget);
    expect(find.text('Дети: James Sirius Potter'), findsOneWidget);
  });
}
