import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_quiz/bloc/word_bloc.dart';
import 'package:mini_quiz/models/word.dart';
import 'package:mini_quiz/views/screens/homepage.dart';

class MockWordBloc extends MockBloc<WordEvent, WordState> implements WordBloc {}

void main() {
  group('Homepage Widget', () {
    late WordBloc wordBloc;

    setUp(() {
      wordBloc = MockWordBloc();
    });

    tearDown(() {
      wordBloc.close();
    });

    testWidgets('has one image, one text, and buttons', (WidgetTester tester) async {
      whenListen(
        wordBloc,
        Stream<WordState>.fromIterable([
          WordState(
            words: [
              Word(
                image: "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/1.webp?v=1682812404",
                word: "музыка",
              ),
            ],
            shuffledLetters: List<String>.generate(12, (index) => 'a'),
          ),
        ]),
        initialState: WordState(
          words: [
            Word(
              image: "https://bygame.ru/uploads/ai/4-fotki-1-slovo-new/6/1.webp?v=1682812404",
              word: "музыка",
            ),
          ],
          shuffledLetters: List<String>.generate(12, (index) => 'a'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WordBloc>(
            create: (_) => wordBloc,
            child: const Homepage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for image
      expect(find.byType(Image), findsOneWidget);

      // Check for text
      expect(find.byType(Text), findsWidgets);

      // Check for buttons
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
