import 'package:flutter/material.dart'; //플러터 머티리얼 패키지
import 'package:provider/provider.dart'; //프로바이더 패키지
import 'package:hanas/theme/hanas_theme.dart'; //하나스 테마 패키지
import 'package:hanas/widgets/hanas_card.dart'; //하나스 카드 위젯 패키지
import 'package:hanas/widgets/hanas_header.dart'; //하나스 헤더 위젯 패키지
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 패키지
import 'package:hanas/providers/favorite_provider.dart'; //즐겨찾기 프로바이더 패키지
import 'package:hanas/providers/friend_nickname_provider.dart'; //친구 별명 프로바이더 패키지

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

  DateTime _parseTime(String time) //시간 문자열을 DateTime으로 변환하는 헬퍼 메서드
  {
    final isPm = time.contains("오후"); //오후인지 확인
    final cleaned = time.replaceAll("오전", "").replaceAll("오후", "").trim(); //불필요한 부분 제거
    final parts = cleaned.split(":"); //시간과 분 분리
    int hour = int.parse(parts[0]); //시간 파싱
    int minute = int.parse(parts[1]); //분 파싱

    if (isPm && hour != 12) //오후이고 12시가 아니면
    {
      hour += 12; //12시간 더하기
    }
    else if (!isPm && hour == 12) //오전이고 12시이면
    {
      hour = 0; //0시로 설정
    }

    return DateTime(2024, 1, 1, hour, minute); //임의의 날짜로 DateTime 객체 생성
  }

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    final nicknameProvider = Provider.of<FriendNicknameProvider>(context); //친구 별명 프로바이더 가져오기
    final favoriteProvider = Provider.of<FavoriteProvider>(context); //즐겨찾기 프로바이더 가져오기

    final sortedChats = [...mockChats]; //채팅 목록 복사

    sortedChats.sort((a, b) //채팅 목록 정렬
    {
      final timeA = _parseTime(a.time); //시간 파싱
      final timeB = _parseTime(b.time); //시간 파싱

      bool aFav = favoriteProvider.isFavorite(a.friendName); //즐겨찾기 여부 확인
      bool bFav = favoriteProvider.isFavorite(b.friendName); //즐겨찾기 여부 확인

      if (aFav && !bFav) return -1; //a가 즐겨찾기고 b가 아니면 a가 먼저
      if (!aFav && bFav) return 1; //b가 즐겨찾기고 a가 아니면 b가 먼저

      return timeB.compareTo(timeA); //시간 내림차순 정렬
    });

    final favoriteChats = //즐겨찾기 채팅 목록
      sortedChats.where((chat) => favoriteProvider.isFavorite(chat.friendName)).toList();
    final normalChats = //일반 채팅 목록
      sortedChats.where((chat) => !favoriteProvider.isFavorite(chat.friendName)).toList();

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
                ...favoriteChats.map((chat) => _buildChatCard(context, chat, theme, nicknameProvider)), //즐겨찾기 채팅 카드들
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
                ...normalChats.map((chat) => _buildChatCard(context, chat, theme, nicknameProvider)), //일반 채팅 카드들
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
    HanasTheme theme, //하나스 테마
    FriendNicknameProvider nicknameProvider, //친구 별명 프로바이더
  )
  {
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