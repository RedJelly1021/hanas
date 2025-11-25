import 'package:flutter/material.dart'; //Flutter 머티리얼 패키지 임포트

class HanasTheme //HANAS 테마 클래스
{
  final String flowerEmoji; //꽃 이모지
  final String name; //테마 이름

  //핵심 색상들
  final Color primary; //포인트 색상
  final Color background; //전체 배경 색상
  final Color foreground; //글자 기본 색상
  final Color accent; //버튼, 포커스, 하이라이트 컬러

  //말풍선 색상
  final Color bubbleMine; //내 채팅 버블 색상
  final Color bubbleOther; //상대방 채팅 버블 색상

  //카드/박스 스타일
  final Color cardColor; //카드 배경 색상 (white or soft)
  final Color borderColor; //테두리 색상
  final Color shadowColor; //그림자 색상

  //앱 바 그라데이션
  final Color appBarGradientStart; //앱 바 그라데이션 시작 색상
  final Color appBarGradientEnd; //앱 바 그라데이션 끝 색상

  HanasTheme //생성자
  ({
    required this.flowerEmoji, //꽃 이모지
    required this.name, //테마 이름

    required this.primary, //포인트 색상
    required this.background, //전체 배경 색상
    required this.foreground, //글자 기본 색상
    required this.accent, //버튼, 포커스, 하이라이트 컬러

    required this.bubbleMine, //내 채팅 버블 색상
    required this.bubbleOther, //상대방 채팅 버블 색상

    required this.cardColor, //카드 배경 색상
    required this.borderColor, //테두리 색상
    required this.shadowColor, //그림자 색상

    required this.appBarGradientStart, //앱 바 그라데이션 시작 색상
    required this.appBarGradientEnd, //앱 바 그라데이션 끝 색상
  });
}

//3가지 꽃 테마 정의 (원하면 추가 가능, 벚꽃, 해바라기, 라벤더, 수국 등)
final List<HanasTheme> hanasThemes = 
[
  HanasTheme //핑크 블라썸 테마
  (
    flowerEmoji: "🌸",
    name: "Pink Blossom",

    primary: const Color(0xFFFF6F9C),        // 밝은 핑크 포인트
    background: const Color(0xFFFFE5EE),     // 전체 배경
    foreground: const Color(0xFF6A0035),     // 글자 기본(진한 핑크)
    accent: const Color(0xFFFFA8C7),         // 포커스/하이라이트

    bubbleMine: const Color(0xFFFF6F9C),     // 내 말풍선
    bubbleOther: Colors.white,               // 상대 말풍선

    cardColor: Colors.white,
    borderColor: const Color(0xFFFF8FB8),
    shadowColor: const Color(0xFFFFA7C7),

    appBarGradientStart: const Color(0xFFFFE5EE),
    appBarGradientEnd: const Color(0xFFFFC8DA),
  ),
  HanasTheme //라벤더 블라썸 테마
  (
    flowerEmoji: "🪻",
    name: "Lavender Blossom",

    primary: const Color(0xFFA98FFF),        // 라벤더 포인트
    background: const Color(0xFFF5EDFF),     // 전체 배경
    foreground: const Color(0xFF4A3F6D),     // 글자 기본
    accent: const Color(0xFFCAB8FF),         // 하이라이트

    bubbleMine: const Color(0xFFA98FFF),
    bubbleOther: Colors.white,

    cardColor: Colors.white,
    borderColor: const Color(0xFFBBA4FF),
    shadowColor: const Color(0xFFD9CCFF),

    appBarGradientStart: const Color(0xFFF5EDFF),
    appBarGradientEnd: const Color(0xFFE6D8FF),
  ),
  HanasTheme //수국 블라썸 테마
  (
    flowerEmoji: "💎",
    name: "Hydrangea Blossom",

    primary: const Color(0xFF78C8FF),        // 수국 포인트
    background: const Color(0xFFE7F6FF),     // 전체 배경
    foreground: const Color(0xFF004F7E),     // 글자 기본
    accent: const Color(0xFFB8E6FF),         // 하이라이트

    bubbleMine: const Color(0xFF78C8FF),
    bubbleOther: Colors.white,

    cardColor: Colors.white,
    borderColor: const Color(0xFF96D6FF),
    shadowColor: const Color(0xFFBCE8FF),

    appBarGradientStart: const Color(0xFFE7F6FF),
    appBarGradientEnd: const Color(0xFFC0E9FF),
  ),
  HanasTheme //해바라기 블라썸 테마
  (
    flowerEmoji: "🌻",
    name: "Sunflower Blossom",

    primary: const Color(0xFFE9C400), // #E9C400 (따뜻한 선플라워 노랑)
    background: const Color(0xFFFFF8D6), // 크림 옐로우 (눈이 편한 톤)
    foreground: const Color(0xFF5A4300), // 짙은 브라운
    accent: const Color(0xFFFFE37B), // 밝고 상큼한 라이트 옐로우

    bubbleMine: const Color(0xFFE9C400), // 포인트 노랑
    bubbleOther: const Color(0xFFFFFFFF),

    cardColor: Colors.white,
    borderColor: const Color(0xFFE0B800),
    shadowColor: const Color(0xFFEDD988),

    appBarGradientStart: const Color(0xFFFFF8D6),
    appBarGradientEnd: const Color(0xFFFFEFA8),
  ),
];