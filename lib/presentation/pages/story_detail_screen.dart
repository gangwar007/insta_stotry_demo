import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/story_bloc.dart';
import '../bloc/story_event.dart';
import '../bloc/story_state.dart';
import 'story_progress_indicator.dart';

class StoryDetailScreen extends StatefulWidget {
  const StoryDetailScreen({super.key});

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late PageController _pageController;
  late StoryBloc _storyBloc;
  Timer? _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _storyBloc = BlocProvider.of<StoryBloc>(context);
    _pageController = PageController(
      initialPage: _storyBloc.state is StoryLoaded
          ? (_storyBloc.state as StoryLoaded).currentStoryIndex
          : 0,
    );

    _startAutoAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progress = 0.0;
          _nextStory();
        }
      });
    });
  }

  void _nextStory() {
    final currentState = _storyBloc.state;
    if (currentState is StoryLoaded) {
      if (currentState.currentStoryIndex < currentState.stories.length - 1) {
        _storyBloc.add(NextStory());
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
        Navigator.pop(context);
      }
    }
  }

  void _previousStory() {
    final currentState = _storyBloc.state;
    if (currentState is StoryLoaded) {
      if (currentState.currentStoryIndex > 0) {
        _storyBloc.add(PreviousStory());
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            if (state is StoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StoryLoaded) {
              return Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: state.stories.length,
                    onPageChanged: (index) {
                      _storyBloc.add(SetCurrentStory(index));
                      setState(() {
                        _progress = 0.0;
                      });
                    },
                    itemBuilder: (context, index) {
                      final story = state.stories[index];
                      return Stack(
                        children: [
                          Image.network(
                            story.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 50,
                            left: 16,
                            child: Text(
                              story.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: StoryProgressIndicator(
                      totalStories: state.stories.length,
                      currentStoryIndex: state.currentStoryIndex,
                      progress: _progress,
                    ),
                  ),
                ],
              );
            } else if (state is StoryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
