import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier
{
  final List<String> _favorites = []; //즐겨찾기 아이템 리스트
  List<String> get favorites => _favorites; //즐겨찾기 아이템 getter

  bool isFavorite(String name) //이름이 즐겨찾기에 있는지 확인
  {
    return _favorites.contains(name);
  }

  void toggleFavorite(String name) //즐겨찾기 토글 메서드
  {
    if (_favorites.contains(name)) {
      //이미 즐겨찾기에 있으면
      _favorites.remove(name); //제거
    } else {
      //즐겨찾기에 없으면
      _favorites.add(name); //추가
    }
    notifyListeners(); //변경 사항 알림
  }
}