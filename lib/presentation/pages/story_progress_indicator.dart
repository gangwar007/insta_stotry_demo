import 'package:flutter/material.dart';

class StoryProgressIndicator extends StatelessWidget {
  final int totalStories;
  final int currentStoryIndex;
  final double progress;

  const StoryProgressIndicator({
    required this.totalStories,
    required this.currentStoryIndex,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalStories, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: LinearProgressIndicator(
                value: index == currentStoryIndex ? progress : (index < currentStoryIndex ? 1.0 : 0.0),
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        );
      }),
    );
  }
}