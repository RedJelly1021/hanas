import 'package:flutter/material.dart';

class HanasCard extends StatelessWidget //HANAS 카드 위젯 클래스
{
  final Widget child; //카드 내부에 표시될 위젯
  final EdgeInsets margin; //카드 외부 여백
  final EdgeInsets padding; //카드 내부 여백
  final Color? background; //카드 배경색
  final Color? borderColor; //카드 테두리 색상
  final double borderWidth; //카드 테두리 두께
  final double borderRadius; //카드 모서리 둥글기
  final Color shadowColor; //카드 그림자 색상
  final double shadowBlur; //카드 그림자 흐림 정도
  final double shadowOpacity; //카드 그림자 투명도
  final VoidCallback? onTap; //카드 탭 시 실행될 콜백 함수

  const HanasCard //HANAS 카드 위젯 생성자
  ({
    super.key, //키 값
    required this.child, //카드 내부에 표시될 위젯
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //카드 외부 여백 기본값
    this.padding = const EdgeInsets.all(16), //카드 내부 여백 기본값
    this.background, //카드 배경색
    this.borderColor, //카드 테두리 색상
    this.borderWidth = 1.2, //카드 테두리 두께 기본값
    this.borderRadius = 16, //카드 모서리 둥글기 기본값
    this.shadowColor = Colors.black, //카드 그림자 색상 기본값
    this.shadowBlur = 6, //카드 그림자 흐림 정도 기본값
    this.shadowOpacity = 0.25, //카드 그림자 투명도 기본값
    this.onTap, //카드 탭 시 실행될 콜백 함수
  });

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    return GestureDetector //탭 감지기
    (
      onTap: onTap, //탭 시 실행될 콜백 함수
      child: Container //카드 컨테이너
      (
        margin: margin, //카드 외부 여백
        padding: padding, //카드 내부 여백
        decoration: BoxDecoration //카드 장식
        (
          color: background ?? Colors.white, //카드 배경색
          borderRadius: BorderRadius.circular(borderRadius), //카드 모서리 둥글기
          border: Border.all //카드 테두리
          (
            color: borderColor ?? Colors.transparent, //카드 테두리 색상
            width: borderWidth, //카드 테두리 두께
          ),
          boxShadow: //카드 그림자
          [
            BoxShadow //그림자 설정
            (
              color: shadowColor.withOpacity(shadowOpacity), //그림자 색상 및 투명도
              blurRadius: shadowBlur, //그림자 흐림 정도
              offset: const Offset(0, 2), //그림자 위치 오프셋
            ),
          ],
        ),
        child: child, //카드 내부에 표시될 위젯
      ),
    );
  }
}