import 'package:flutter/material.dart'; //Flutter의 ChangeNotifier 사용
import 'package:hanas/models/friend.dart'; //Friend 모델 임포트

class FriendsProvider extends ChangeNotifier //친구 관리 프로바이더
{
  // 1) 친구 목록 (기존 mockFriends)
  final List<Friend> _friends = 
  [
    Friend(id: "1", name: "민수", emoji: "🐱"),
    Friend(id: "2", name: "지연", emoji: "🐰"),
    Friend(id: "3", name: "다희", emoji: "🐻"),
    Friend(id: "4", name: "유진", emoji: "🐼"),
    Friend(id: "5", name: "서준", emoji: "🦊"),
    Friend(id: "6", name: "현아", emoji: "🐧"),
    Friend(id: "7", name: "아람찌", emoji: "😍"),
    Friend(id: "8", name: "윤이", emoji: "👧🏻"),
    Friend(id: "9", name: "유리", emoji: "🌼"),
  ];

  List<Friend> get friends => List.unmodifiable(_friends); //친구 목록 getter
  bool isFriend(String name)
  {
    return _friends.any((f) => f.name == name); //이름으로 친구 여부 확인
  }

  // 2) 즐겨찾기
  final Set<String> _favorites = {}; //즐겨찾기 이름 집합

  bool isFavorite(String name) => _favorites.contains(name); //즐겨찾기 여부 확인

  void toggleFavorite(String name) //즐겨찾기 토글 메서드
  {
    if (_favorites.contains(name)) //이미 즐겨찾기에 있으면
    {
      _favorites.remove(name); //제거
    }
    else 
    {
      _favorites.add(name); //추가
    }
    notifyListeners(); //변경 사항 알림
  }

  // 3) 별명
  final Map<String, String> _nicknames = {}; //별명 맵

  String displayName(String original) => _nicknames[original] ?? original; //표시 이름 반환

  String? getNickname(String original) => _nicknames[original]; //별명 getter

  void setNickname(String original, String? nickname) //별명 설정 메서드
  {
    if (nickname == null || nickname.trim().isEmpty) //별명이 비어있으면
    {
      _nicknames.remove(original); //제거
    }
    else 
    {
      _nicknames[original] = nickname.trim(); //설정
    }
    notifyListeners(); //변경 사항 알림
  }

  // 4) 친구 삭제
  void removeFriend(String name) //친구 삭제 메서드
  {
    _friends.removeWhere((f) => f.name == name); //제거
    _favorites.remove(name); //즐겨찾기에서도 제거
    _nicknames.remove(name); //별명에서도 제거
    notifyListeners(); //변경 사항 알림
  }

  // 5) 친구 추가
  void addFriend(Friend friend) //친구 추가 메서드
  {
    if (isFriend(friend.name)) return; //이미 친구면 무시
    _friends.add(friend); //추가
    notifyListeners(); //변경 사항 알림
  }

  // 6) 특정 이름의 Friend 객체 반환
  Friend? getFriend(String name) //이름으로 친구 객체 반환
  {
    try 
    {
      return _friends.firstWhere((f) => f.name == name); //이름으로 친구 찾기
    } 
    catch (e) 
    {
      return null; //없으면 null 반환
    }
  }
}
