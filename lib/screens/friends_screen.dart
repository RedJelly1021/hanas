import 'package:flutter/material.dart';

class Friend //친구 모델 클래스
{
  final String name; //친구 이름
  final String emoji; //친구 이모지

  Friend(this.name, this.emoji); //생성자
}

final mockFriends = //모의 친구 데이터
[
  Friend("아람찌", "😍"),
  Friend("윤이", "👧🏻"),
  Friend("유리", "🌼"),
];

class FriendsScreen extends StatelessWidget //친구 목록 화면 클래스
{
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    return Scaffold //기본 화면 구조
    (
      backgroundColor: const Color(0xFFFFDDEB), //연한 핑크색 배경
      appBar: AppBar //앱 바
      (
        backgroundColor: const Color(0xFFFFDDEB), //연한 핑크색 배경
        elevation: 0, //앱 바 그림자 제거
        title: const Text //앱 바 제목
        (
          '내 친구', //텍스트
          style: TextStyle //텍스트 스타일
          (
            color: Colors.pinkAccent, //핑크색 텍스트
            fontWeight: FontWeight.bold, //굵게
          ),
        ),
        actions: //앱 바 우측 아이콘 버튼들
        [
          IconButton //친구 추가 버튼
          (
            icon: const Icon(Icons.person_add, color: Colors.pinkAccent), //아이콘
            onPressed: () //버튼 눌렀을 때
            {
              ScaffoldMessenger.of(context).showSnackBar //Snackbar 표시
              (
                const SnackBar(content: Text("친구 추가 기능은 나중에!")), //Snackbar 내용
              );
            },
          )
        ],
      ),

      //친구 목록
      body: ListView.builder //친구 목록 리스트뷰
      (
        itemCount: mockFriends.length, //아이템 개수
        itemBuilder: (context, index) //각 아이템 빌더
        {
          final friend = mockFriends[index]; //현재 친구 데이터 
          
          return Card //카드 위젯
          (
            color: Colors.white, //흰색 카드
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //카드 마진
            shape: RoundedRectangleBorder //둥근 모서리
            (
              borderRadius: BorderRadius.circular(16), //모서리 반경
            ),
            child: ListTile //리스트 타일
            (
              leading: Text //친구 이모지
              (
                friend.emoji, //이모지 텍스트
                style: const TextStyle(fontSize: 32), //이모지 크기
              ),
              title: Text //친구 이름
              (
                friend.name, //이름 텍스트
                style: const TextStyle //텍스트 스타일
                (
                  fontSize: 18, //글자 크기
                  fontWeight: FontWeight.w600, //글자 두께
                  color: Colors.pinkAccent, //글자 색상
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.pinkAccent), //오른쪽 화살표 아이콘
              onTap: () //탭했을 때
              {
                Navigator.pushNamed(context, '/chat'); //채팅 화면으로 이동
              },
            ),
          );
        },
      ),
    );
  }
}