class ChatPreview // Model for a chat preview with friend's name, emoji, last message, and time
{
  final String friendName; // The name of the friend
  final String emoji; // The emoji representing the friend
  final String lastMessage; // The last message in the chat
  final DateTime time; // The timestamp of the last message
  final bool isDeleted; // Whether the chat preview is marked as deleted
  final bool isMine; // Whether the last message was sent by the current user
  final String type; // The type of the last message
  final int unreadCount; // The count of unread messages

  ChatPreview // Constructor
  ({
    required this.friendName, // The name of the friend
    required this.emoji, // The emoji representing the friend
    required this.lastMessage, // The last message in the chat
    required this.time, // The timestamp of the last message
    required this.isDeleted, // Whether the chat preview is marked as deleted
    required this.isMine, // Whether the last message was sent by the current user
    required this.type, // The type of the last message
    required this.unreadCount, // The count of unread messages
  });

  factory ChatPreview.fromMap(Map<String, dynamic> map) // Factory constructor to create a ChatPreview from a map
  {
    return ChatPreview // Return a new ChatPreview instance
    (
      friendName: map['friendName'] ?? '', // The name of the friend
      emoji: map['emoji'] ?? '', // The emoji representing the friend
      lastMessage: map['lastMessage'] ?? '', // The last message in the chat
      time: DateTime.parse(map['time']), // The timestamp of the last message
      isDeleted: map['isDeleted'] ?? false, // Whether the chat preview is marked as deleted
      isMine: map['isMine'] ?? false, // Whether the last message was sent by the current user
      type: map['type'] ?? 'text', // The type of the last message
      unreadCount: map['unreadCount'] ?? 0, // The count of unread messages
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
      'isDeleted': isDeleted, // Whether the chat preview is marked as deleted
      'isMine': isMine, // Whether the last message was sent by the current user
      'type': type, // The type of the last message
      'unreadCount': unreadCount, // The count of unread messages
    };
  }

  ChatPreview copyWith
  ({
    String? lastMessage, // The last message in the chat
    DateTime? time, // The timestamp of the last message
    bool? isDeleted, // Whether the chat preview is marked as deleted
    bool? isMine, // Whether the last message was sent by the current user
    String? type, // The type of the last message
    int? unreadCount, // The count of unread messages
  })
  {
    return ChatPreview // Return a new ChatPreview instance with updated fields
    (
      friendName: friendName, // The name of the friend
      emoji: emoji, // The emoji representing the friend
      lastMessage: lastMessage ?? this.lastMessage, // The last message in the chat
      time: time ?? this.time, // The timestamp of the last message
      isDeleted: isDeleted ?? this.isDeleted, // Whether the chat preview is marked as deleted
      isMine: isMine ?? this.isMine, // Whether the last message was sent by the current user
      type: type ?? this.type, // The type of the last message
      unreadCount: unreadCount ?? this.unreadCount, // The count of unread messages
    );
  }
}