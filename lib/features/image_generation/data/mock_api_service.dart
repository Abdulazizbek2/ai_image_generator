import 'dart:math';

class MockApiService {
  /// Generates an image based on the provided prompt.
  /// 
  /// Simulates API call with:
  /// - 2-3 seconds delay
  /// - ~50% chance of throwing an exception
  /// - Returns a placeholder image URL on success
  Future<String> generate(String prompt) async {
    // Simulate network delay (2-3 seconds)
    await Future.delayed(
      Duration(milliseconds: 2000 + Random().nextInt(1000)),
    );

    // ~50% chance of error
    if (Random().nextBool()) {
      throw Exception('Failed to generate image. Please try again.');
    }

    // Return a placeholder image URL
    // Using picsum.photos for random placeholder images
    final imageId = Random().nextInt(100) + 1;
    return 'https://picsum.photos/seed/$imageId/800/600';
  }
}
