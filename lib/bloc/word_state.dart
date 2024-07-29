part of 'word_bloc.dart';

class WordState {
  final List<String> userWord;
  final List<String> shuffledLetters;
  final List<Word> words;
  final bool completed;

  const WordState({
    this.userWord = const [],
    this.shuffledLetters = const [],
    this.words = const [],
    this.completed = false,
  });

  WordState copyWith({
    List<String>? userWord,
    List<String>? shuffledLetters,
    List<Word>? words,
    bool? completed,
  }) {
    return WordState(
      userWord: userWord ?? this.userWord,
      shuffledLetters: shuffledLetters ?? this.shuffledLetters,
      words: words ?? this.words,
      completed: completed ?? this.completed,
    );
  }
}
