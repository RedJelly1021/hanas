import 'package:flutter/material.dart';
import '../theme/hanas_theme.dart';

class ThemeProvider extends ChangeNotifier //테마 프로바이더 클래스
{
  HanasTheme currentTheme = hanasThemes[0]; //기본 테마 = 핑크 블라썸

  void changeTheme(HanasTheme theme) //테마 변경 메서드
  {
    currentTheme = theme; //현재 테마 변경
    notifyListeners(); //앱 전체 새로고침
  }
}