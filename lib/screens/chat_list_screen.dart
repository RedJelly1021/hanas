import 'package:flutter/material.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:hanas/widgets/hanas_card.dart';
import 'package:hanas/widgets/hanas_header.dart';
import 'package:provider/provider.dart';

class ChatPreview //채팅 미리보기 모델 클래스
{
  final String friendName; //친구 이름
  final String emoji; //친구 이모지
  final String lastMessage; //마지막 메시지
  final String time; //마지막 메시지 시간

  ChatPreview(this.friendName, this.emoji, this.lastMessage, this.time); //생성자
}

final mockChats = //모의 채팅 데이터
[
  ChatPreview("아람찌", "😍", "내일 영화 보러 갈래?", "오후 10:30"),
  ChatPreview("윤이", "👧🏻", "오늘 저녁 뭐 먹을래?", "오전 11:15"),
  ChatPreview("유리", "🌼", "응응! 알겠어", "오후 12:00"),
];

class ChatListScreen extends StatelessWidget //채팅 목록 화면 클래스
{
  const ChatListScreen({super.key}); //생성자

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    
    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //연한 핑크색 배경
      body: Column //세로 레이아웃
      (
        children: //자식 위젯들
        [
          //헤더 영역
          HanasHeader
          (
            title: "채팅", //헤더 제목
            onBack: () => Navigator.pop(context), //뒤로가기 콜백
          ),
          //채팅 목록 영역
          Expanded //확장 위젯
          (
            child: ListView.builder //채팅 목록 리스트뷰
            (
              padding: const EdgeInsets.symmetric(vertical: 10), //세로 패딩
              itemCount: mockChats.length, //아이템 개수
              itemBuilder: (context, index) //아이템 빌더
              {
                final chat = mockChats[index]; //현재 채팅 미리보기
                
                return HanasCard //탭 감지기
                (
                  background: theme.cardColor, //카드 배경색
                  borderColor: theme.borderColor.withOpacity(0.7), //테두리 색상
                  shadowColor: theme.shadowColor, //그림자 색상
                  shadowOpacity: 0.35, //그림자 불투명도
                  onTap: () //탭했을 때
                  {
                    Navigator.pushNamed //채팅 화면으로 이동
                    (
                      context, //빌드 컨텍스트
                      '/chat', //채팅 화면 경로
                      arguments: chat.friendName, //친구 이름 전달
                    );
                  },
                  child: Row //가로 레이아웃
                  (
                    children: //자식 위젯들
                    [
                      //emoji avatar
                      CircleAvatar //원형 아바타
                      (
                        radius: 28, //반지름
                        backgroundColor: theme.primary.withOpacity(0.12), //핑크색 반투명 배경
                        child: Text //이모지 텍스트
                        (
                          chat.emoji, //이모지
                          style: const TextStyle(fontSize: 28), //이모지 크기
                        ),
                      ),
                      const SizedBox(width: 16), //간격
                      //name + last message
                      Expanded //확장 위젯
                      (
                        child: Column //세로 레이아웃
                        (
                          crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                          children: //자식 위젯들
                          [
                            Text //친구 이름
                            (
                              chat.friendName, //친구 이름
                              style: TextStyle //텍스트 스타일
                              (
                                fontSize: 18, //폰트 크기
                                fontWeight: FontWeight.bold, //굵게
                                color: theme.foreground, //글자 색상
                              ),
                            ),
                            const SizedBox(height: 6), //간격
                            Text //마지막 메시지
                            (
                              chat.lastMessage, //마지막 메시지 텍스트
                              maxLines: 1, //최대 1줄
                              overflow: TextOverflow.ellipsis, //넘치면 말줄임표
                              style: TextStyle //텍스트 스타일
                              (
                                color: theme.foreground.withOpacity(0.65), //연한 글자 색상
                                fontSize: 14, //폰트 크기
                              ),
                            ),
                          ],
                        ),
                      ),
                      //time
                      Text //시간 텍스트
                      (
                        chat.time, //시간
                        style: TextStyle //텍스트 스타일
                        (
                          color: theme.foreground.withOpacity(0.5), //연한 글자 색상
                          fontSize: 12, //폰트 크기
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*
return Card //채팅 카드
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
      chat.emoji, //이모지 텍스트
      style: const TextStyle(fontSize: 32), //이모지 크기
    ),
    title: Text //친구 이름
    (
      chat.friendName, //이름 텍스트
      style: const TextStyle //텍스트 스타일
      (
        color: theme.primary, //핑크색 텍스트
        fontWeight: FontWeight.w600, //약간 굵게
      ),
    ),
    subtitle: Text(chat.lastMessage), //마지막 메시지
    trailing: const Icon(Icons.chevron_right, color: theme.primary), //오른쪽 화살표 아이콘
    onTap: () //탭 이벤트
    {
      Navigator.pushNamed //채팅 화면으로 이동
      (
        context, //현재 컨텍스트
        '/chat', //경로
        arguments: chat.friendName, //친구 이름 전달
      );
    },
  ),
);
*/