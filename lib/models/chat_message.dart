class ChatMessage // Model for a chat message with text, time, and ownership information
{
  final String id; // Unique identifier for the chat message
  final String sender; // The sender of the chat message
  final String text; // The content of the chat message
  final DateTime createdAt; // The timestamp of when the message was created
  final DateTime? updatedAt; // The timestamp of when the message was last updated
  final bool isMine; // Indicates if the message was sent by the current user
  final bool isRead; // Indicates if the message has been read
  final bool isDeleted; // Indicates if the message has been deleted
  final String type; // The type of the message (e.g., text, image, video)

  ChatMessage // Constructor
  ({
    required this.id, // Unique identifier for the chat message
    required this.sender, // The sender of the chat message
    required this.text, // The content of the chat message
    required this.createdAt, // The timestamp of when the message was created
    this.updatedAt, // The timestamp of when the message was last updated
    required this.isMine, // Indicates if the message was sent by the current user
    this.isRead = false, // Indicates if the message has been read
    this.isDeleted = false, // Indicates if the message has been deleted
    this.type = 'text', // The type of the message (default is 'text')
  });

  // Factory constructor to create a ChatMessage from a map
  factory ChatMessage.fromMap(Map<String, dynamic> map) 
  {
    return ChatMessage // Return a new ChatMessage instance
    (
      id: map['id'] ?? '', // Assign id from map or default to empty string
      sender: map['sender'] ?? '', // Assign sender from map or default to empty string
      text: map['text'] ?? '', // Assign text from map or default to empty string
      createdAt: DateTime.parse(map['createdAt']), // Parse createdAt from map
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null, // Parse updatedAt from map if available
      isMine: map['isMine'] ?? false, // Assign ownership from map or default to false
      isRead: map['isRead'] ?? false, // Assign read status from map or default to false
      isDeleted: map['isDeleted'] ?? false, // Assign deleted status from map or default to false
      type: map['type'] ?? 'text', // Assign type from map or default to 'text'
    );
  }
  
  // Method to convert ChatMessage instance to a map
  Map<String, dynamic> toMap() 
  {
    return // Return a map representation of the ChatMessage
    {
      'id': id, // Unique identifier for the chat message
      'sender': sender, // The sender of the chat message
      'text': text, // The content of the chat message
      'createdAt': createdAt.toIso8601String(), // The timestamp of when the message was created
      'updatedAt': updatedAt?.toIso8601String(), // The timestamp of when the message was last updated
      'isMine': isMine, // Indicates if the message was sent by the current user
      'isRead': isRead, // Indicates if the message has been read
      'isDeleted': isDeleted, // Indicates if the message has been deleted
      'type': type, // The type of the message
    };
  }

  ChatMessage copyWith
  ({
    String? id, // Unique identifier for the chat message
    String? sender, // The sender of the chat message
    String? text, // The content of the chat message
    DateTime? createdAt, // The timestamp of when the message was created
    DateTime? updatedAt, // The timestamp of when the message was last updated
    bool? isMine, // Indicates if the message was sent by the current user
    bool? isRead, // Indicates if the message has been read
    bool? isDeleted, // Indicates if the message has been deleted
    String? type, // The type of the message
  })
  {
    return ChatMessage // Return a new ChatMessage instance with updated fields
    (
      id: id ?? this.id, // Use provided id or existing id
      sender: sender ?? this.sender, // Use provided sender or existing sender
      text: text ?? this.text, // Use provided text or existing text
      createdAt: createdAt ?? this.createdAt, // Use provided createdAt or existing createdAt
      updatedAt: updatedAt ?? this.updatedAt, // Use provided updatedAt or existing updatedAt
      isMine: isMine ?? this.isMine, // Use provided isMine or existing isMine
      isRead: isRead ?? this.isRead, // Use provided isRead or existing isRead
      isDeleted: isDeleted ?? this.isDeleted, // Use provided isDeleted or existing isDeleted
      type: type ?? this.type, // Use provided type or existing type
    );
  }
}