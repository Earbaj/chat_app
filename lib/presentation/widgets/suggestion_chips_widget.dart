import 'package:flutter/material.dart';

class SuggestionChipsWidget extends StatelessWidget {
  final Function(String topic) onSelectTopic;

  const SuggestionChipsWidget({super.key, required this.onSelectTopic});

  static const List<Map<String, String>> suggestions = [
    {'icon': '🚀', 'label': 'Flutter Clean Architecture'},
    {'icon': '🤖', 'label': 'What is Artificial Intelligence?'},
    {'icon': '🌌', 'label': 'Explain Quantum Physics'},
    {'icon': '🎨', 'label': 'Creative Storytelling'},
    {'icon': '💻', 'label': 'Dart vs Kotlin Comparison'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.smart_toy_outlined,
            size: 64,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to AI Topic Assistant!',
            style: Theme.of(context).headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select a suggested topic below or type your own question:',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: suggestions.map((item) {
              return ActionChip(
                avatar: Text(item['icon']!, style: const TextStyle(fontSize: 16)),
                label: Text(item['label']!),
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () => onSelectTopic(item['label']!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
