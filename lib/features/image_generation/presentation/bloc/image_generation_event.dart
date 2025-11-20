import 'package:equatable/equatable.dart';

abstract class ImageGenerationEvent extends Equatable {
  const ImageGenerationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start generating an image
class GenerateImageEvent extends ImageGenerationEvent {
  final String prompt;

  const GenerateImageEvent(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

/// Event to regenerate image with the same prompt
class RegenerateImageEvent extends ImageGenerationEvent {
  const RegenerateImageEvent();
}

/// Event to reset to initial state (for "New prompt")
class ResetGenerationEvent extends ImageGenerationEvent {
  const ResetGenerationEvent();
}
