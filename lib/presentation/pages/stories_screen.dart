import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_stories.dart';
import '../../main.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../bloc/story_state.dart';
import 'story_detail_screen.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stories')),
      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StoryLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.stories.length,
                    itemBuilder: (context, index) {
                      final story = state.stories[index];
                      return GestureDetector(
                        onTap: () {
                         BlocProvider.of<StoryBloc>(context).add(SetCurrentStory(index));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  const StoryDetailScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF833AB4), // Purple
                                      Color(0xFFFF355E), // Pink
                                      Color(0xFFFFC600), // Yellow
                                      Color(0xFFFF4500), // Orange
                                    ],
                                    // begin: Alignment.topLeft,
                                    // end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0), // Border width
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.white, // Inner circle color
                                      child: ClipOval(
                                        child: Image.network(
                                          state.stories[index].imageUrl,
                                          fit: BoxFit.cover,
                                          width: 70,
                                          height: 70,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 70,
                                              height: 70,
                                              color: Colors.grey,
                                              child: const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),
                              Flexible(
                                child: Text(
                                  story.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is StoryError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}