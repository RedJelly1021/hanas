import 'package:flutter/material.dart'; //Flutter 머티리얼 패키지 임포트
import 'package:provider/provider.dart'; //프로바이더 패키지 임포트
import 'package:hanas/theme/hanas_theme.dart'; //HANAS 테마 임포트
import 'package:hanas/widgets/hanas_header.dart'; //HANAS 헤더 위젯 임포트
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 임포트

class ThemeSelectScreen extends StatelessWidget //테마 선택 화면 클래스
{
  const ThemeSelectScreen({super.key}); //생성자

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final themeProvider = Provider.of<ThemeProvider>(context); //테마 프로바이더 가져오기
    final current = themeProvider.currentTheme; //현재 테마 가져오기

    return Scaffold //기본 화면 구조
    (
      body: Container //컨테이너 위젯
      (
        decoration: BoxDecoration //박스 장식
        (
          gradient: LinearGradient //선형 그라데이션
          (
            colors: //그라데이션 색상
            [
              current.appBarGradientStart, //현재 테마 앱 바 그라데이션 시작 색상
              current.appBarGradientEnd, //현재 테마 앱 바 그라데이션 끝 색상
            ],
            begin: Alignment.topCenter, //그라데이션 시작점
            end: Alignment.bottomCenter, //그라데이션 끝점
          ),
        ),
        child: SafeArea //안전 영역
        (
          child: Column //세로 정렬
          (
            children: //자식 위젯들
            [
              //Hanas header
              HanasHeader
              (
                title: Row //헤더 제목 행
                (
                  mainAxisAlignment: MainAxisAlignment.center, //가운데 정렬
                  children: //자식 위젯들
                  [
                    Text //헤더 텍스트
                    (
                      "테마 선택", //헤더 제목
                      style: TextStyle //텍스트 스타일
                      (
                        fontSize: 20, //폰트 크기
                        fontWeight: FontWeight.bold, //굵게
                        color: current.foreground, //글자 색상
                      ),
                    ),
                  ],
                ),
                onBack: () => Navigator.pop(context), //뒤로 가기 동작
              ),
              const SizedBox(height: 10), //상단 여백'
              //Theme list
              Expanded
              (
                child: ListView //테마 리스트뷰
                (
                  children: hanasThemes.map((theme) //테마들 반복
                  {
                    final isSelected = current == theme; //현재 테마와 비교

                    return GestureDetector //탭 감지기
                    (
                      onTap: () => //탭했을 때
                        themeProvider.changeTheme(theme), //테마 변경
                      child: AnimatedContainer //애니메이션 컨테이너
                      (
                        duration: const Duration(milliseconds: 250), //애니메이션 지속 시간
                        curve: Curves.easeOutCubic, //애니메이션 곡선
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), //외부 여백
                        padding: const EdgeInsets.all(20), //내부 여백
                        decoration: BoxDecoration //컨테이너 장식
                        (
                          color: isSelected ? theme.primary.withOpacity(0.2) : current.cardColor, //선택된 테마는 강조색, 아니면 흰색
                          borderRadius: BorderRadius.circular(18), //둥근 모서리
                          border: Border.all //테두리
                          (
                            color: isSelected
                             ? theme.primary 
                             : theme.borderColor.withOpacity(0.7), //테마 기본색 테두리
                            width: isSelected ? 3 : 1.3, //선택된 테마는 두꺼운 테두리
                          ),
                          boxShadow: //박스 그림자
                          [
                            BoxShadow //그림자
                            (
                              color: theme.shadowColor.withOpacity
                              (
                                isSelected ? 0.45 : 0.20
                              ), //그림자 색상
                              blurRadius: isSelected ? 14 : 7, //흐림 반경
                              offset: const Offset(0, 4), //그림자 위치
                            ),
                          ],
                        ),
                        child: Row //행 위젯
                        (
                          children: //자식 위젯들
                          [
                            Text(theme.flowerEmoji, style: const TextStyle(fontSize: 42)), //테마 꽃 이모지
                            const SizedBox(width: 22), //간격
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                              children: [
                                Text //테마 이름 텍스트
                                (
                                  theme.name, //테마 이름
                                  style: TextStyle //텍스트 스타일
                                  (
                                    fontSize: 20, //폰트 크기
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, //선택된 테마는 굵게
                                    color: theme.foreground, //테마 기본색
                                  ),
                                ),
                                const SizedBox(height: 4), //간격
                                Text
                                (
                                  isSelected
                                  ? "현재 적용된 테마입니다" //선택된 테마일 때
                                  : "탭하여 이 테마로 변경하기", //선택되지 않은 테마일 때
                                  style: TextStyle //텍스트 스타일
                                  (
                                    color: theme.foreground.withOpacity(0.6), //테마 기본색 반투명
                                    fontSize: 13, //폰트 크기
                                  ),
                                )
                              ],
                            ),
                            const Spacer(), //빈 공간
                            if (isSelected) //선택된 테마일 때
                              Icon //체크 아이콘
                              (
                                Icons.check_circle_outline, //체크 아이콘
                                color: theme.primary, //테마 강조색
                                size: 28, //아이콘 크기
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(), //테마 리스트로 변환
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}