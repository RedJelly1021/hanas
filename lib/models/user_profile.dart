class UserProfile
{
  final String userId; // User's unique identifier
  final String nickname; // User's nickname
  final String statusMessage; // User's status message
  
  UserProfile // Constructor
  ({
    required this.userId, // User's unique identifier
    required this.nickname, // User's nickname
    required this.statusMessage, // User's status message
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) // Factory constructor to create a UserProfile from a map
  {
    return UserProfile // Return a new UserProfile instance
    (
      userId: map['userId'] ?? '', // Assign userId from map or default to empty string
      nickname: map['nickname'] ?? 'Guest', // Assign nickname from map or default to 'Guest'
      statusMessage: map['statusMessage'] ?? 'Hello there!', // Assign status message from map or default to 'Hello there!'
    );
  }

  Map<String, dynamic> toMap() // Method to convert UserProfile instance to a map
  {
    return // Return a map representation of the UserProfile
    {
      'userId': userId, // User's unique identifier
      'nickname': nickname, // User's nickname
      'statusMessage': statusMessage, // User's status message
    };
  }
}