import 'package:equatable/equatable.dart';

abstract class ImageGenerationState extends Equatable {
  const ImageGenerationState();

  @override
  List<Object?> get props => [];
}

/// Initial state - user hasn't entered a prompt yet
class ImageGenerationInitial extends ImageGenerationState {
  final String? savedPrompt;

  const ImageGenerationInitial({this.savedPrompt});

  @override
  List<Object?> get props => [savedPrompt];
}

/// Loading state - generating image
class ImageGenerationLoading extends ImageGenerationState {
  final String prompt;

  const ImageGenerationLoading(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

/// Success state - image generated successfully
class ImageGenerationSuccess extends ImageGenerationState {
  final String imageUrl;
  final String prompt;

  const ImageGenerationSuccess({
    required this.imageUrl,
    required this.prompt,
  });

  @override
  List<Object?> get props => [imageUrl, prompt];
}

/// Error state - generation failed
class ImageGenerationError extends ImageGenerationState {
  final String message;
  final String prompt;

  const ImageGenerationError({
    required this.message,
    required this.prompt,
  });

  @override
  List<Object?> get props => [message, prompt];
}
