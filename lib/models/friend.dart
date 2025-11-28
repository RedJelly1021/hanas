class Friend // Model for a friend with a name and an emoji
{
  final String name; // Friend's name
  final String emoji; // Friend's emoji representation

  Friend // Constructor
  ({
    required this.name, // Friend's name
    required this.emoji, // Friend's emoji representation
  });

  factory Friend.fromMap(Map<String, dynamic> map) // Factory constructor to create a Friend from a map
  {
    return Friend // Return a new Friend instance
    (
      name: map['name'] ?? '', // Assign name from map or default to empty string
      emoji: map['emoji'] ?? '', // Assign emoji from map or default to empty string
    );
  }

  Map<String, dynamic> toMap() // Method to convert Friend instance to a map
  {
    return // Return a map representation of the Friend
    {
      'name': name, // Friend's name
      'emoji': emoji, // Friend's emoji representation
    };
  }
}