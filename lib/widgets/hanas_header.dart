import 'package:flutter/material.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HanasHeader extends StatelessWidget 
{
  final String title; //헤더 제목
  final VoidCallback? onBack; //뒤로가기 콜백(선택적, null이면 뒤로가기 없음)
  final List<Widget> rightActions; //오른쪽 액션 위젯들

  const HanasHeader
  ({
    super.key, 
    required this.title, 
    this.onBack, 
    this.rightActions = const [],
  });

  @override
  Widget build(BuildContext context)
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기

    double rightActionsWidth = (rightActions.length * 48).toDouble(); //오른쪽 액션들 너비 계산
    double leftSpaceWidth = onBack != null ? 48 : rightActionsWidth; //왼쪽 공간 너비 계산

    return Container
    (
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), //패딩
      decoration: BoxDecoration
      (
        gradient: LinearGradient
        (
          colors: 
          [
            theme.appBarGradientStart, 
            theme.appBarGradientEnd, 
          ],
          begin: Alignment.topCenter, 
          end: Alignment.bottomCenter, 
        ),
      ),
      child: SafeArea
      (
        bottom: false, 
        child: Row
        (
          children: 
          [
            //뒤로가기 버튼 or 빈 공간
            onBack != null //뒤로가기 콜백이 있으면
              ? IconButton //아이콘 버튼
                (
                  icon: Icon(Icons.arrow_back_ios_new, color: theme.foreground), //핑크색 뒤로가기 아이콘
                  onPressed: onBack, //뒤로가기 콜백
                )
              : SizedBox(width: leftSpaceWidth), //빈 공간
            
            //제목
            Expanded
            (
              child: Center
              (
                child: Text
                (
                  title,
                  style: TextStyle
                  (
                    fontSize: 22, 
                    fontWeight: FontWeight.bold, 
                    color: theme.foreground, 
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),

            //오른쪽 액션들 여러개 가능 or 빈 공간
            Row
            (
              mainAxisSize: MainAxisSize.min,
              children: rightActions.isNotEmpty
                ? rightActions
                : [const SizedBox(width: 48)],  
            ),
          ],
        ),
      ),
    );
  }
}