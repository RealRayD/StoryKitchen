import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_generation_provider.dart';
class StoryDisplayScreen extends StatelessWidget {
  const StoryDisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storyGenerationProvider = context.watch<StoryGenerationProvider>();

    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(storyGenerationProvider.generatedStory?.title ?? 'Story'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: storyGenerationProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : storyGenerationProvider.generatedStory != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storyGenerationProvider.generatedStory!.content,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('Your story will appear here.'),
                    ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Add save functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Add share functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () {
                // Add font size adjustment
              },
            ),
          ],
        ),
        ),
      ),
    );
  }
}