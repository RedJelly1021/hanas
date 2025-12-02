import 'package:flutter/material.dart'; // Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore imports
import 'package:hanas/providers/user_profile_provider.dart'; // 사용자 프로필 관련 프로바이더

//Firestore의 '/users/{userId}' 문서를 관리하는 Provider
class FirestoreUserProvider extends ChangeNotifier
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false; // 로딩 상태
  bool get isLoading => _isLoading;

  Future<void> loadUser(String userId, UserProfileProvider profile) async
  {
    if (userId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    final docRef = _firestore.collection('users').doc(userId);
    final doc = await docRef.get();

    //문서가 없으면 새로 생성
    if (!doc.exists)
    {
      await docRef.set
      ({
        'userId': userId,
        'nickname': profile.nickname,
        'statusMessage': profile.statusMessage,
      });

      _isLoading = false;
      notifyListeners();
      return;
    }

    //Firestore -> UserProfileProvider 반영
    final data = doc.data()!;
    profile.setUserId(data['userId']);
    profile.setNickname(data['nickname']);
    profile.setStatusMessage(data['statusMessage']);

    _isLoading = false;
    notifyListeners();
  }

  //Firestore에 프로필 저장 (닉네임/상태 메시지 변경 시 호출)
  Future<void> saveUser(UserProfileProvider profile) async
  {
    if (profile.userId.isEmpty) return;

    await _firestore.collection('users').doc(profile.userId).set
    ({
      'userId': profile.userId,
      'nickname': profile.nickname,
      'statusMessage': profile.statusMessage,
    }, SetOptions(merge: true));

    notifyListeners();
  }
}