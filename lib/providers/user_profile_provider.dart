import 'package:flutter/material.dart';

//내 프로필(닉네임 / 상태 메시지) 관리
class UserProfileProvider extends ChangeNotifier // ChangeNotifier 상속
{
  String _nickname = "Guest"; // 기본 닉네임
  String _statusMessage = "Hello there!"; // 기본 상태 메시지

  String get nickname => _nickname; // 닉네임 getter
  String get statusMessage => _statusMessage; // 상태 메시지 getter

  void setNickname(String value) // 닉네임 설정 메서드
  {
    _nickname = value.trim().isEmpty ? "Guest" : value.trim(); // 빈 문자열이면 기본값 설정
    notifyListeners(); // 변경 알림
  }

  void setStatusMessage(String value) // 상태 메시지 설정 메서드
  {
    _statusMessage = value.trim().isEmpty ? "Hello there!" : value.trim(); // 빈 문자열이면 기본값 설정
    notifyListeners(); // 변경 알림
  }
}