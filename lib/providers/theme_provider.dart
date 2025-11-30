import 'package:flutter/material.dart';
import '../theme/hanas_theme.dart';

class ThemeProvider extends ChangeNotifier //테마 프로바이더 클래스
{
  HanasTheme _current = hanasThemes.first; //기본 테마 설정

  ThemeData get materialTheme => _current.materialTheme; //머티리얼 테마 데이터 가져오기

  HanasTheme get currentTheme => _current; //현재 테마 가져오기

  List<HanasTheme> get allThemes => hanasThemes; //모든 테마 리스트 가져오기

  void changeTheme(HanasTheme theme) //테마 설정 메서드
  {
    _current = theme; //현재 테마 변경
    notifyListeners(); //리스너들에게 변경 알림
  }

  void setThemeByIndex(int index) //인덱스로 테마 설정 메서드
  {
    if (index < 0 || index >= hanasThemes.length) return; //유효성 검사
    _current = hanasThemes[index]; //현재 테마 변경
    notifyListeners(); //리스너들에게 변경 알림
  }
}