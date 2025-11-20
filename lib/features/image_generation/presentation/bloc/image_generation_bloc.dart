import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mock_api_service.dart';
import 'image_generation_event.dart';
import 'image_generation_state.dart';

class ImageGenerationBloc
    extends Bloc<ImageGenerationEvent, ImageGenerationState> {
  final MockApiService _apiService;

  ImageGenerationBloc({MockApiService? apiService})
      : _apiService = apiService ?? MockApiService(),
        super(const ImageGenerationInitial()) {
    on<GenerateImageEvent>(_onGenerateImage);
    on<RegenerateImageEvent>(_onRegenerateImage);
    on<ResetGenerationEvent>(_onResetGeneration);
  }

  Future<void> _onGenerateImage(
    GenerateImageEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    emit(ImageGenerationLoading(event.prompt));

    try {
      final imageUrl = await _apiService.generate(event.prompt);
      emit(ImageGenerationSuccess(
        imageUrl: imageUrl,
        prompt: event.prompt,
      ));
    } catch (e) {
      emit(ImageGenerationError(
        message: e.toString().replaceAll('Exception: ', ''),
        prompt: event.prompt,
      ));
    }
  }

  Future<void> _onRegenerateImage(
    RegenerateImageEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    final currentState = state;
    String prompt = '';

    if (currentState is ImageGenerationSuccess) {
      prompt = currentState.prompt;
    } else if (currentState is ImageGenerationError) {
      prompt = currentState.prompt;
    }

    if (prompt.isNotEmpty) {
      emit(ImageGenerationLoading(prompt));

      try {
        final imageUrl = await _apiService.generate(prompt);
        emit(ImageGenerationSuccess(
          imageUrl: imageUrl,
          prompt: prompt,
        ));
      } catch (e) {
        emit(ImageGenerationError(
          message: e.toString().replaceAll('Exception: ', ''),
          prompt: prompt,
        ));
      }
    }
  }

  Future<void> _onResetGeneration(
    ResetGenerationEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    final currentState = state;
    String? savedPrompt;

    // Save the prompt when going back to initial state
    if (currentState is ImageGenerationSuccess) {
      savedPrompt = currentState.prompt;
    } else if (currentState is ImageGenerationError) {
      savedPrompt = currentState.prompt;
    } else if (currentState is ImageGenerationLoading) {
      savedPrompt = currentState.prompt;
    }

    emit(ImageGenerationInitial(savedPrompt: savedPrompt));
  }
}
