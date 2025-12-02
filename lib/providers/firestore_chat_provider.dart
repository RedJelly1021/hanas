import 'package:flutter/material.dart'; // Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore imports

class FirestoreChatProvider extends ChangeNotifier
{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 채팅 메시지 목록 (Firestore 기반)
  List<Map<String, dynamic>> messages = [];

  // 특정 방의 메시지 불러오기
  Future<void> loadMessages(String roomId) async
  {
    //TODO: Firestore 연동 예정
    //final snapshot = await _db.collection('chats').doc(roomId).collection('messages').get();
    //messages = snapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }
}