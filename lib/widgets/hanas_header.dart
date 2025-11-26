import 'package:flutter/material.dart'; //플러터 머티리얼 패키지 임포트
import 'package:provider/provider.dart'; //프로바이더 패키지 임포트
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 임포트

class HanasHeader extends StatelessWidget //HANAS 헤더 위젯 클래스
{
  final Widget title; //헤더 제목
  final VoidCallback? onBack; //뒤로가기 콜백(선택적, null이면 뒤로가기 없음)
  final List<Widget> rightActions; //오른쪽 액션 위젯들

  const HanasHeader //HANAS 헤더 위젯 생성자
  ({
    super.key, //키 값
    required this.title, //제목 필수
    this.onBack, //뒤로가기 콜백
    this.rightActions = const [], //오른쪽 액션들 기본값 빈 리스트
  });

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기

    double rightActionsWidth = (rightActions.length * 48).toDouble(); //오른쪽 액션들 너비 계산
    double leftSpaceWidth = onBack != null ? 48 : rightActionsWidth; //왼쪽 공간 너비 계산

    return Container //컨테이너 위젯
    (
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), //패딩
      decoration: BoxDecoration //박스 장식
      (
        gradient: LinearGradient //선형 그라데이션
        (
          colors:  //그라데이션 색상들
          [
            theme.appBarGradientStart, //테마의 앱바 그라데이션 시작 색상
            theme.appBarGradientEnd, //테마의 앱바 그라데이션 끝 색상
          ],
          begin: Alignment.topCenter, //그라데이션 시작 위치
          end: Alignment.bottomCenter, //그라데이션 끝 위치
        ),
      ),
      child: SafeArea //세이프 에어리어 위젯
      (
        bottom: false, //하단 세이프 에어리어 비활성화
        child: Row //가로 행 위젯
        (
          children: //자식 위젯들
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
            Expanded(child: Center(child: title)), //가운데 정렬된 제목 확장 위젯
            // (
            //   title,
            //   style: TextStyle
            //   (
            //     fontSize: 22, 
            //     fontWeight: FontWeight.bold, 
            //     color: theme.foreground, 
            //     letterSpacing: 0.8,
            //   ),
            // ),
            
            //오른쪽 액션들 여러개 가능 or 빈 공간
            Row //가로 행 위젯
            (
              mainAxisSize: MainAxisSize.min, //최소 크기 가로 행 위젯
              children: rightActions.isNotEmpty //오른쪽 액션들이 있으면
                ? rightActions //오른쪽 액션들 표시
                : [const SizedBox(width: 48)],  //빈 공간
            ),
          ],
        ),
      ),
    );
  }
}