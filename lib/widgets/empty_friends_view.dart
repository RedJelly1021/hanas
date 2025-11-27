import 'package:flutter/material.dart';

class EmptyFriendsView extends StatelessWidget //친구 목록이 비었을 때 표시할 뷰
{
  final String message; //표시할 메시지
  final Color textColor; //텍스트 색상

  const EmptyFriendsView //생성자
  ({
    super.key, //키
    required this.message, //메시지 필수
    required this.textColor, //텍스트 색상 필수
  });

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    return Center //가운데 정렬
    (
      child: Column //세로 정렬
      (
        mainAxisAlignment: MainAxisAlignment.center, //중앙 정렬
        children: //자식 위젯들
        [
          const Text //이모지
          (
            "🫶🏻",
            style: TextStyle(fontSize: 48), //큰 폰트 크기
          ),
          const SizedBox(height: 8), //간격
          Text //메시지 텍스트
          (
            message, //전달받은 메시지
            style: TextStyle //텍스트 스타일
            (
              fontSize: 16, //폰트 크기
              color: textColor.withOpacity(0.8), //전달받은 텍스트 색상
              fontWeight: FontWeight.w500, //중간 굵기
            ),
          ),
          const SizedBox(height: 6), //간격
          Text //부가 설명 텍스트
          (
            "친구를 추가해보세요!", //고정 메시지
            style: TextStyle //텍스트 스타일
            (
              fontSize: 13, //폰트 크기
              color: textColor.withOpacity(0.6), //전달받은 텍스트 색상
            ),
          ),
        ],
      ),
    );
  }
}