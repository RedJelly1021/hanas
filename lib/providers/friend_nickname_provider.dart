import 'package:flutter/material.dart';

//친구 닉네임 관리용 프로바이더
class FriendNicknameProvider extends ChangeNotifier // ChangeNotifier 상속
{
  final Map<String, String> _nicknames = {}; //원래 이름 => 별명

  //표시용 이름 (별명 있으면 별명, 없으면 원래 이름)
  String displayName(String originalName) // 표시용 이름 반환 메서드
  {
    return _nicknames[originalName] ?? originalName; // 별명이 있으면 반환, 없으면 원래 이름 반환
  }

  //별명 가져오기 (없으면 nmull)
  String? getNickname(String originalName) => _nicknames[originalName]; // 별명 getter

  //별명 설정 (빈 문자열이면 제거)
  void setNickname(String originalName, String? nickname) // 별명 설정 메서드
  {
    final trimmed = nickname?.trim() ?? ""; // 닉네임이 null이면 빈 문자열로 처리

    if (trimmed.isEmpty) // 빈 문자열이면 제거
    {
      _nicknames.remove(originalName); // 별명 제거
    }
    else // 빈 문자열이 아니면 설정
    {
      _nicknames[originalName] = trimmed; // 별명 설정
    }
    notifyListeners(); // 변경 알림
  }
}