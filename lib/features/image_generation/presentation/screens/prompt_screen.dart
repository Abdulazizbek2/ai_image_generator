import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/image_generation_bloc.dart';
import '../bloc/image_generation_event.dart';
import '../bloc/image_generation_state.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Load saved prompt if exists
    final state = context.read<ImageGenerationBloc>().state;
    if (state is ImageGenerationInitial && state.savedPrompt != null) {
      _controller.text = state.savedPrompt!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGenerate() {
    if (_controller.text.trim().isNotEmpty) {
      context.read<ImageGenerationBloc>().add(GenerateImageEvent(_controller.text.trim()));
      context.push('/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageGenerationBloc, ImageGenerationState>(
      listener: (context, state) {},
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // App Title
                Text(
                  'AI Image Generator',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Create amazing images with AI',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe what you want to see...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    style: const TextStyle(fontSize: 16),
                    onChanged: (value) {
                      setState(() {}); // Rebuild to update button state
                    },
                    onSubmitted: (_) {
                      if (_controller.text.trim().isNotEmpty) {
                        _onGenerate();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Generate Button
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    final isEnabled = value.text.trim().isNotEmpty;

                    return ElevatedButton(
                      onPressed: isEnabled ? _onGenerate : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[500],
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: isEnabled ? 4 : 0,
                        shadowColor: Colors.deepPurple.withValues(alpha: 0.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 24, color: isEnabled ? Colors.white : Colors.grey[500]),
                          const SizedBox(width: 12),
                          Text(
                            'Generate',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isEnabled ? Colors.white : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
