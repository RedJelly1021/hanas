class ChatMessage // Model for a chat message with text, time, and ownership information
{
  final String text; // The content of the chat message
  final DateTime time; // The timestamp of when the message was sent
  final bool isMine; // Indicates if the message was sent by the current user

  ChatMessage // Constructor
  ({
    required this.text, // The content of the chat message
    required this.time, // The timestamp of when the message was sent
    required this.isMine, // Indicates if the message was sent by the current user
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) // Factory constructor to create a ChatMessage from a map
  {
    return ChatMessage // Return a new ChatMessage instance
    (
      text: map['text'] ?? '', // Assign text from map or default to empty string
      time: DateTime.parse(map['time']), // Parse time from map
      isMine: map['isMine'] ?? false, // Assign ownership from map or default to false
    );
  }

  Map<String, dynamic> toMap() // Method to convert ChatMessage instance to a map
  {
    return // Return a map representation of the ChatMessage
    {
      'text': text, // The content of the chat message
      'time': time.toIso8601String(), // The timestamp of when the message was sent
      'isMine': isMine, // Indicates if the message was sent by the current user
    };
  }
}