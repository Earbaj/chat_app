class ChatMessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
