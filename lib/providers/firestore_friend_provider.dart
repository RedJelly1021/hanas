import 'package:flutter/material.dart'; // Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore imports
import 'package:hanas/models/friend.dart'; // Friend model import

// Firestore 기반 친구 관리 Provider
class FirestoreFriendProvider extends ChangeNotifier
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 친구 목록 (Firestore 기반)
  List<Friend> _friends = [];
  List<Friend> get friends => List.unmodifiable(_friends);

  //실시간 친구 목록 스트림 구독
  Stream<void> listenToFriends(String myUserId)
  {
    return _firestore
        .collection('users')
        .doc(myUserId)
        .collection('friends')
        .snapshots()
        .map((snapshot) {
          _friends = snapshot.docs.map((doc) => Friend.fromMap(doc.data())).toList();
          notifyListeners();
        });
  }

  //친구 추가
  Future<void> addFriend(String myUserId, Friend friend) async
  {
    await _firestore
        .collection('users')
        .doc(myUserId)
        .collection('friends')
        .doc(friend.id)
        .set(friend.toMap());
  }

  //친구 삭제
  Future<void> removeFriend(String myUserId, String friendId) async
  {
    await _firestore
        .collection('users')
        .doc(myUserId)
        .collection('friends')
        .doc(friendId)
        .delete();
  }

  //친구인지 확인
  bool isFriend(String friendId)
  {
    return _friends.any((friend) => friend.id == friendId);
  }
}