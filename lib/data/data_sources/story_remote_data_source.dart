import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/story_model.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> fetchStories();
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  @override
  Future<List<StoryModel>> fetchStories() async {
    final response = await rootBundle.loadString('assets/stories.json');
    final List<dynamic> data = json.decode(response);
    return data.map((story) => StoryModel.fromJson(story)).toList();
  }
}