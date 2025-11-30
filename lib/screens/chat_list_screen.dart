import 'package:flutter/material.dart'; //플러터 머티리얼 패키지
import 'package:provider/provider.dart'; //프로바이더 패키지

import 'package:hanas/widgets/hanas_card.dart'; //하나스 카드 위젯 패키지
import 'package:hanas/widgets/hanas_header.dart'; //하나스 헤더 위젯 패키지

import 'package:hanas/models/chat_preview.dart'; //채팅 미리보기 모델 패키지

import 'package:hanas/providers/chat_provider.dart'; //채팅 프로바이더 패키지
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 패키지
import 'package:hanas/providers/friends_provider.dart'; //친구 프로바이더 패키지
import 'package:hanas/providers/friend_nickname_provider.dart'; //친구 별명 프로바이더 패키지

String formatChatTimeSmart(DateTime time)
{
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final targetDay = DateTime(time.year, time.month, time.day);

  final diff = today.difference(targetDay).inDays;

  //오늘
  if (diff == 0)
  {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = isAm ? "오전" : "오후";
    return "$period $displayHour:$minute";
  }
  //어제
  if (diff == 1)
  {
    return "어제";
  }
  //7일 이내
  if (diff < 7)
  {
    return "$diff일 전";
  }
  //올해 안
  final nowYear = now.year;
  if (time.year == nowYear)
  {
    return "${time.month}월 ${time.day}일";
  }
  //그 외
  return "${time.year}.${time.month}.${time.day}";
}

class ChatListScreen extends StatelessWidget //채팅 목록 화면 클래스
{
  const ChatListScreen({super.key}); //생성자

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = context.watch<ThemeProvider>().currentTheme; //현재 테마 가져오기
    final chatProvider = context.watch<ChatProvider>(); //채팅 프로바이더 가져오기
    final friendsProvider = context.watch<FriendsProvider>(); //친구 프로바이더 가져오기
    final nicknameProvider = context.watch<FriendNicknameProvider>(); //친구 별명 프로바이더 가져오기

    final sortedChats = [...chatProvider.chatPreviews]; //채팅 목록 복사

    sortedChats.sort((a, b) //채팅 목록 정렬
    {
      final timeA = a.time; //시간 파싱
      final timeB = b.time; //시간 파싱

      bool aFav = friendsProvider.isFavorite(a.friendName); //즐겨찾기 여부 확인
      bool bFav = friendsProvider.isFavorite(b.friendName); //즐겨찾기 여부 확인

      if (aFav && !bFav) return -1; //a가 즐겨찾기고 b가 아니면 a가 먼저
      if (!aFav && bFav) return 1; //b가 즐겨찾기고 a가 아니면 b가 먼저

      return timeB.compareTo(timeA); //시간 내림차순 정렬
    });

    final favoriteChats = //즐겨찾기 채팅 목록
      sortedChats.where((chat) => friendsProvider.isFavorite(chat.friendName)).toList();
    final normalChats = //일반 채팅 목록
      sortedChats.where((chat) => !friendsProvider.isFavorite(chat.friendName)).toList();

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
            title: Row //헤더 제목 행
            (
              mainAxisAlignment: MainAxisAlignment.center, //가운데 정렬
              children: //자식 위젯들
              [
                Text //헤더 텍스트
                (
                  "채팅", //헤더 제목
                  style: TextStyle //텍스트 스타일
                  (
                    fontSize: 22, //폰트 크기
                    fontWeight: FontWeight.bold, //굵게
                    color: theme.foreground, //글자 색상
                  ),
                ),
              ],
            ),
            onBack: () => Navigator.pop(context), //뒤로가기 콜백
          ),
          //채팅 목록 영역
          Expanded //확장 위젯
          (
            child: ListView //채팅 목록 리스트뷰
            (
              padding: const EdgeInsets.symmetric(vertical: 10), //세로 패딩
              children: //자식 위젯들
              [
                if (favoriteChats.isNotEmpty) ...[ //조건부 렌더링
                //즐겨찾기 채팅들
                Padding
                (
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //패딩
                  child: Text //즐겨찾기 텍스트
                  (
                    "즐겨찾기", //텍스트 내용
                    style: TextStyle //텍스트 스타일
                    (
                      color: theme.foreground.withOpacity(0.8), //글자 색상
                      fontWeight: FontWeight.bold, //굵게
                      fontSize: 15, //폰트 크기
                    ),
                  ),
                ),
                ...favoriteChats.map((chat) => _buildChatCard(context, chat, theme, nicknameProvider, friendsProvider)), //즐겨찾기 채팅 카드들
                ],
                Padding //전체 채팅 텍스트
                (
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), //패딩
                  child: Text //전체 채팅 텍스트
                  (
                    "전체 채팅", //텍스트 내용
                    style: TextStyle //텍스트 스타일
                    (
                      color: theme.foreground.withOpacity(0.8), //글자 색상
                      fontWeight: FontWeight.bold, //굵게
                      fontSize: 15, //폰트 크기
                    ),
                  ),
                ),
                ...normalChats.map((chat) => _buildChatCard(context, chat, theme, nicknameProvider, friendsProvider)), //일반 채팅 카드들
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard //채팅 카드 빌더 메서드
  (
    BuildContext context, //빌드 컨텍스트
    ChatPreview chat, //채팅 미리보기 모델
    theme, //하나스 테마
    FriendNicknameProvider nicknameProvider, //친구 별명 프로바이더
    FriendsProvider friendsProvider, //친구 프로바이더
  )
  {
    String lastMsg; //마지막 메시지 텍스트 변수
    if (chat.isDeleted)
    {
      lastMsg = "[삭제된 메시지]"; //삭제된 메시지 표시
    }
    else
    {
      switch (chat.type) //메시지 타입에 따른 처리
      {
        case "image":
          lastMsg = "📷 사진"; //이미지 메시지
          break;
        case "file":
          lastMsg = "📎 파일"; //파일 메시지
          break;
        case "system":
          lastMsg = "📝 시스템 메시지"; //시스템 메시지
          break;
        default:
          lastMsg = chat.lastMessage; //텍스트 메시지
      }
    }
    final unread = chat.unreadCount; //읽지 않은 메시지 수

    return HanasCard //탭 감지기
    (
      background: theme.cardColor, //카드 배경색
      borderColor: theme.borderColor.withOpacity(0.7), //테두리 색상
      shadowColor: theme.shadowColor, //그림자 색상
      shadowOpacity: 0.35, //그림자 불투명도
      onTap: () //탭했을 때
      {
        final friend = friendsProvider.getFriend(chat.friendName); //친구 데이터 가져오기
        if (friend == null) return; //친구가 없으면 리턴

        Navigator.pushNamed //네비게이터로 화면 이동
        (
          context, //현재 컨텍스트
          '/chat', //채팅 화면 경로
          arguments: friend, //친구 데이터 인자 전달
        ); //채팅 화면으로 이동
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
                  //chat.friendName, //친구 이름
                  nicknameProvider.displayName(chat.friendName), //별명 있으면 별명, 없으면 원래 이름
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
                  lastMsg, //마지막 메시지 텍스트
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

          Column
          (
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              Text
              (
                formatChatTimeSmart(chat.time), //시간 포맷팅
                style: TextStyle
                (
                  color: theme.foreground.withOpacity(0.5), //연한 글자 색상
                  fontSize: 12, //폰트 크기
                ),
              ),

              if (unread > 0) ...[//읽지 않은 메시지가 있으면
                  const SizedBox(height: 4), //간격
                  Container //읽지 않은 메시지 수 컨테이너
                  (
                    height: 20, //높이
                    padding: const EdgeInsets.symmetric(horizontal: 6), //가로 패딩
                    alignment: Alignment.center, //가운데 정렬
                    decoration: BoxDecoration //박스 장식
                    (
                      color: theme.primary, //핑크색 배경
                      borderRadius: BorderRadius.circular(10), //둥근 모서리
                    ),
                    child: Text //읽지 않은 메시지 수 텍스트
                    (
                      unread.toString(), //읽지 않은 메시지 수
                      style: const TextStyle //텍스트 스타일
                      (
                        color: Colors.white, //흰색 글자
                        fontSize: 11, //폰트 크기
                        fontWeight: FontWeight.bold, //굵게
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}