import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/image_generation_bloc.dart';
import '../bloc/image_generation_event.dart';
import '../bloc/image_generation_state.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // context.read<ImageGenerationBloc>().add(const ResetGenerationEvent());
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<ImageGenerationBloc, ImageGenerationState>(
        builder: (context, state) {
          if (state is ImageGenerationLoading) {
            return _buildLoadingState(context);
          } else if (state is ImageGenerationSuccess) {
            return _buildSuccessState(context, state);
          } else if (state is ImageGenerationError) {
            return _buildErrorState(context, state);
          }

          // Fallback - should not happen with proper navigation
          return _buildLoadingState(context);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Generating your image...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, ImageGenerationSuccess state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prompt text
            Text(
              'Your prompt:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              state.prompt,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),

            // Image with animation
            Expanded(
              child: Hero(
                tag: 'generated_image',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      state.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.broken_image, size: 64, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Try Another button
            ElevatedButton(
              onPressed: () {
                context.read<ImageGenerationBloc>().add(const RegenerateImageEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh, size: 22),
                  SizedBox(width: 8),
                  Text('Try another', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // New Prompt button
            OutlinedButton(
              onPressed: () {
                context.read<ImageGenerationBloc>().add(const ResetGenerationEvent());
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.deepPurple, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit_outlined, size: 22),
                  SizedBox(width: 8),
                  Text('New prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ImageGenerationError state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),

            // Error icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.error_outline, size: 60, color: Colors.red),
            ),

            const SizedBox(height: 24),

            Text(
              'Oops! Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Retry button
            ElevatedButton(
              onPressed: () {
                context.read<ImageGenerationBloc>().add(const RegenerateImageEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh, size: 22),
                  SizedBox(width: 8),
                  Text('Retry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // New Prompt button
            OutlinedButton(
              onPressed: () {
                context.read<ImageGenerationBloc>().add(const ResetGenerationEvent());
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.deepPurple, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit_outlined, size: 22),
                  SizedBox(width: 8),
                  Text('New prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
