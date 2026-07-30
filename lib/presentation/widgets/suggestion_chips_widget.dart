import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 💡 SUGGESTION CHIPS WIDGET (সাজেশন প্রম্পট চিপস উইজেট)
/// ---------------------------------------------------------------------------
/// নতুনদের জন্য ব্যাখ্যা:
/// চ্যাট স্ক্রিন যখন একদম খালি থাকে, তখন ইউজারকে কিছু নমুনা প্রশ্ন/টপিক সিলেক্ট
/// করার সুযোগ দিতে এই উইজেটটি দেখানো হয়। এতে ট্যাপ করলেই সেই প্রম্পটটি AI-কে পাঠানো হয়।
/// ---------------------------------------------------------------------------

class SuggestionChipsWidget extends StatelessWidget {
  final Function(String topic) onSelectTopic; // চিপসে চাপ দিলে প্রম্পট পাঠানোর কলব্যাক

  const SuggestionChipsWidget({super.key, required this.onSelectTopic});

  // নমুনা প্রম্পটের লিস্ট (আইকন ও লেবেল সহ)
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
          // স্বাগত আইকন
          const Icon(
            Icons.smart_toy_outlined,
            size: 64,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 16),
          
          // টাইটেল হেডার
          Text(
            'Welcome to AI Topic Assistant!',
            style: Theme.of(context).headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // সাব-টাইটেল গাইড
          Text(
            'Select a suggested topic below or type your own question:',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // সাজেশন চিপসের Wrap লেআউট
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
