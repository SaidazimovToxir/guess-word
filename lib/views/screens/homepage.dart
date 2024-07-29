import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_quiz/bloc/word_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess the word by photo"),
      ),
      body: BlocConsumer<WordBloc, WordState>(
        listener: (context, state) {
          if (state.words.isNotEmpty && state.userWord.join() == state.words[0].word) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Correct!"),
                    content: const Text("You guessed the word!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<WordBloc>().add(NextWord());
                          Navigator.of(context).pop();
                        },
                        child: const Text("Next Word"),
                      ),
                    ],
                  );
                },
              );
            });
          }
        },
        builder: (context, state) {
          if (state.completed) {
            return const Center(
              child: Text(
                "Congratulations! You've completed the game.",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
            );
          }
      
          if (state.words.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      
          final word = state.words[0].word;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.words.length,
                    itemBuilder: (context, index) {
                      final word = state.words[index];
                      return Image.network(
                        word.image,
                        scale: 1.1,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 60,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index < state.userWord.length) {
                            context.read<WordBloc>().add(RemoveCharacter(index));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              state.userWord.length > index
                                  ? state.userWord[index].toString()
                                  : '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: word.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 60,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (state.userWord.length < state.words[0].word.length) {
                            context.read<WordBloc>().add(AddCharacter(state.shuffledLetters[index]));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              state.shuffledLetters[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
