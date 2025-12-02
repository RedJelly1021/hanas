import 'package:flutter/material.dart'; // Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore imports

class FirestoreFriendProvider extends ChangeNotifier
{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 친구 목록 (Firestore 기반)
  List<Map<String, dynamic>> friends = [];

  // 나중에 실제 Firestore 연동될 때 구현
  Future<void> loadFriends(String uid) async
  {
    //TODO: Firestore 연동 예정
    //final snapshot = await _db.collection('users').doc(uid).collection('friends').get();
    //friends = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }
}