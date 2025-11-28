class ChatPreview // Model for a chat preview with friend's name, emoji, last message, and time
{
  final String friendName; // The name of the friend
  final String emoji; // The emoji representing the friend
  final String lastMessage; // The last message in the chat
  final DateTime time; // The timestamp of the last message

  ChatPreview // Constructor
  ({
    required this.friendName, // The name of the friend
    required this.emoji, // The emoji representing the friend
    required this.lastMessage, // The last message in the chat
    required this.time, // The timestamp of the last message
  });

  factory ChatPreview.fromMap(Map<String, dynamic> map) // Factory constructor to create a ChatPreview from a map
  {
    return ChatPreview // Return a new ChatPreview instance
    (
      friendName: map['friendName'] ?? '', // The name of the friend
      emoji: map['emoji'] ?? '', // The emoji representing the friend
      lastMessage: map['lastMessage'] ?? '', // The last message in the chat
      time: DateTime.parse(map['time']), // The timestamp of the last message
    );
  }

  Map<String, dynamic> toMap() // Method to convert ChatPreview instance to a map
  {
    return // Return a map representation of the ChatPreview
    {
      'friendName': friendName, // The name of the friend
      'emoji': emoji, // The emoji representing the friend
      'lastMessage': lastMessage, // The last message in the chat
      'time': time.toIso8601String(), // The timestamp of the last message
    };
  }
}