import 'package:flutter/material.dart'; // Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore imports

class FirestoreUserProvider extends ChangeNotifier
{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Firestore에서 가져온 유저 데이터 저장
  Map<String, dynamic>? _userData;

  // 나중에 실제 Firestore 연동될 때 구현
  Future<void> loadUser(String uid) async
  {
    //TODO: Firestore 연동 예정
    //final doc = await _db.collection('users').doc(uid).get();
    //userDate = doc.data();
    notifyListeners();
  }
}