import 'package:flutter/material.dart'; //플러터 머티리얼 패키지
import 'package:provider/provider.dart'; //프로바이더 패키지

import 'package:hanas/models/friend.dart'; //친구 모델

import 'package:hanas/widgets/chat_bubble.dart'; //채팅 말풍선 위젯
import 'package:hanas/widgets/hanas_header.dart'; //하나스 헤더 위젯

import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더
import 'package:hanas/providers/chat_provider.dart'; //채팅 프로바이더
import 'package:hanas/providers/friend_nickname_provider.dart'; //친구 별명 프로바이더

class ChatScreen extends StatefulWidget //채팅 화면 클래스
{
  const ChatScreen({super.key}); //생성자

  @override
  State<ChatScreen> createState() => _ChatScreenState(); //상태 생성
}

class _ChatScreenState extends State<ChatScreen> //채팅 화면 상태 클래스
{
  String? _editingMessageId; //편집 중인 메시지 ID
  final TextEditingController _editController = TextEditingController(); //텍스트 컨트롤러
  final ScrollController _scrollController = ScrollController(); //스크롤 컨트롤러

  bool _didMarkReadOnce = false; //읽음 상태 표시 변수

  void _markRead(Friend friend) //메시지 읽음 상태 표시 메서드
  {
    final chatProvider = context.read<ChatProvider>(); //채팅 프로바이더 가져오기
    chatProvider.markAsRead(friend); //메시지 읽음 상태 업데이트
  }

  int _prevMessageCount = 0; //이전 메시지 개수 변수

  @override
  void dispose() //해제 메서드
  {
    _editController.dispose(); //텍스트 컨트롤러 해제
    _scrollController.dispose(); //스크롤 컨트롤러 해제
    super.dispose(); //부모 해제 호출
  }

  @override
  void didChangeDependencies() //종속성 변경 메서드
  {
    super.didChangeDependencies(); //부모 메서드 호출

    if (!_didMarkReadOnce) //아직 읽음 상태가 아니면
    {
      final friend = ModalRoute.of(context)!.settings.arguments as Friend; //인자 받아오기
      _markRead(friend); //메시지 읽음 상태 표시
      _didMarkReadOnce = true; //읽음 상태로 표시
    }
  }

  void _sendMessage(Friend friend) //메시지 전송 메서드
  {
    final text = _editController.text.trim(); //텍스트 가져오기
    if (text.isEmpty) return; //빈 텍스트면 리턴

    final chatProvider = context.read<ChatProvider>(); //채팅 프로바이더 가져오기
    chatProvider.sendMessage(friend, text);
    _editController.clear(); //텍스트 필드 비우기

    _scrollToBottom(); //아래로 스크롤
  }

  void _scrollToBottom() //아래로 스크롤 메서드
  {
    WidgetsBinding.instance.addPostFrameCallback((_) //프레임 후 콜백
    {
      if (_scrollController.hasClients) //스크롤 컨트롤러가 유효하면
      {
        _scrollController.animateTo //스크롤 애니메이션
        (
          _scrollController.position.maxScrollExtent, //최하단으로 스크롤
          duration: const Duration(milliseconds: 300), //애니메이션 지속 시간
          curve: Curves.easeOutCubic, //애니메이션 곡선
        );

        final friend = ModalRoute.of(context)!.settings.arguments as Friend; //인자 받아오기
        _markRead(friend); //메시지 읽음 상태 표시
      }
    });
  }

  //날짜 같은지 비교 메서드
  bool _isSameDay(DateTime a, DateTime b) //같은 날인지 비교
  {
    return a.year == b.year && a.month == b.month && a.day == b.day; //년, 월, 일 비교
  }

  //날짜 텍스트 포맷팅 메서드 (예: 2024년 6월 15일 (토))
  String _formatDate(DateTime time) //날짜 포맷팅 메서드
  {
    const weekdays = ["월", "화", "수", "목", "금", "토", "일"]; //요일 리스트
    final wd = weekdays[time.weekday - 1]; //요일 가져오기
    return "${time.year}년 ${time.month}월 ${time.day}일 ($wd)"; //포맷된 날짜 반환
  }

  //날짜 구분자 위젯
  Widget _buildDateDivider(DateTime time, dynamic theme) //날짜 구분자 빌더
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(vertical: 8), //수직 패딩
      child: Row //가로 레이아웃
      (
        children: //자식 위젯들
        [
          Expanded //확장 위젯
          (
            child: Divider //구분선
            (
              color: theme.borderColor.withOpacity(0.5), //구분선 색상
              thickness: 0.7, //구분선 두께
            ),
          ),
          Padding //날짜 텍스트 패딩
          (
            padding: const EdgeInsets.symmetric(horizontal: 8), //수평 패딩
            child: Text //날짜 텍스트
            (
              _formatDate(time), //포맷된 날짜
              style: TextStyle //텍스트 스타일
              (
                fontSize: 12, //폰트 크기
                color: theme.foreground.withOpacity(0.7), //텍스트 색상
              ),
            ),
          ),
          Expanded //확장 위젯
          (
            child: Divider //구분선
            (
              color: theme.borderColor.withOpacity(0.5), //구분선 색상
              thickness: 0.7, //구분선 두께
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = context.watch<ThemeProvider>().currentTheme; //현재 테마 가져오기
    final friend = ModalRoute.of(context)!.settings.arguments as Friend; //인자 받아오기

    final nicknameProvider = context.watch<FriendNicknameProvider>(); //친구 별명 프로바이더
    final chatProvider = context.watch<ChatProvider>(); //채팅 프로바이더
    
    final messages = chatProvider.messagesFor(friend); //해당 친구와의 메시지 리스트 가져오기

    WidgetsBinding.instance.addPostFrameCallback((_) //프레임 후 콜백
    {
      _markRead(friend); //메시지 읽음 상태 표시
    });

    final displayName = nicknameProvider.displayName(friend.name); // 표시용 이름 가져오기

    if (messages.length != _prevMessageCount) //메시지 개수가 변경되었으면
    {
      WidgetsBinding.instance.addPostFrameCallback((_) //프레임 후 콜백
      {
        _scrollToBottom(); //아래로 스크롤
      });
      _prevMessageCount = messages.length; //이전 메시지 개수 업데이트
    }

    //키보드 올라올 때 아래로 스크롤    
    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      if (MediaQuery.of(context).viewInsets.bottom > 0) //키보드가 올라왔을 때
      {
        _scrollToBottom(); //아래로 스크롤
      }
    });

    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //연한 핑크색 배경
      body: Column //세로 레이아웃
      (
        children: //자식 위젯들
        [
          //헤더 영역
          HanasHeader //헤더 위젯
          (
            title: GestureDetector
            (
              onTap: () //탭 이벤트
              {
                Navigator.pushNamed //친구 상세 화면으로 이동
                (
                  context, //빌드 컨텍스트
                  '/friendDetail', //친구 상세 화면 경로
                  arguments: friend, //친구 데이터 인자 전달
                );
              },
              child: Row //가로 레이아웃
              (
                mainAxisAlignment: MainAxisAlignment.center, //가운데 정렬
                children: //자식 위젯들
                [
                  Column //세로 레이아웃
                  (
                    crossAxisAlignment: CrossAxisAlignment.center, //가운데 정렬
                    children: //자식 위젯들
                    [
                      Text //별명 또는 원래 이름 텍스트
                      (
                        displayName, //별명 있으면 별명, 없으면 원래 이름
                        style: TextStyle //텍스트 스타일
                        (
                          fontSize: 17, //폰트 크기
                          fontWeight: FontWeight.bold, //굵은 글씨
                          color: theme.foreground, //텍스트 색상
                        ),
                      ),
                      Text //프로필 보기 텍스트
                      (
                        "프로필 보기", //텍스트 내용
                        style: TextStyle //텍스트 스타일
                        (
                          fontSize: 11, //폰트 크기
                          color: theme.foreground.withOpacity(0.6), //텍스트 색상
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onBack: () => Navigator.pop(context), //뒤로가기 콜백
          ),

          //메시지 표시 영역
          Expanded //확장 위젯
          (
            child: ListView.builder //메시지 리스트뷰
            (
              controller: _scrollController, //스크롤 컨트롤러
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //패딩
              itemCount: messages.length, //메시지 개수
              itemBuilder: (_, index) //아이템 빌더
              {
                final msg = messages[index]; //현재 메시지
                final showHeader = index == 0 ||
                    !_isSameDay(msg.createdAt, messages[index - 1].createdAt); //날짜 헤더 표시 여부

                return Column //세로 레이아웃
                (
                  children: //자식 위젯들
                  [
                    if (showHeader) //날짜 헤더 표시 여부
                      _buildDateDivider(msg.createdAt, theme), //날짜 구분자
                    ChatBubble (message: msg,), //채팅 말풍선
                  ],
                );
              },
            ),
          ),

          //메시지 입력 영역
          Container //메시지 입력 컨테이너
          (
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18), //내부 여백
            decoration: BoxDecoration //박스 장식
            (
              color: theme.cardColor, //카드 배경색
              border: Border //테두리
              (
                top: BorderSide(color: theme.borderColor.withOpacity(0.8), width: 1), //위쪽 테두리
              ),
              boxShadow: //박스 그림자
              [
                BoxShadow //그림자
                (
                  color: theme.shadowColor.withOpacity(0.45), //그림자 색상
                  blurRadius: 6, //흐림 반경
                  offset: const Offset(0, -2), //그림자 위치
                ),
              ],
            ),
            child:  Row //가로 레이아웃
            (
              children: //자식 위젯들
              [
                // + 버튼 (파일/사진 등은 나중에)
                IconButton //파일/사진 버튼
                (
                  icon: Icon //아이콘 버튼
                  (
                    Icons.add_circle_outline, //추가 아이콘
                    color: theme.primary, //아이콘 색상
                  ),
                  onPressed: () //버튼 클릭 이벤트
                  {
                    ScaffoldMessenger.of(context).showSnackBar //스낵바 표시
                    (
                      const SnackBar(content: Text("사진/파일 보내기는 나중에!")), //스낵바 내용
                    );
                  },
                ),

                Expanded //확장 위젯
                (
                  child: Container //텍스트 입력 컨테이너
                  (
                    padding: const EdgeInsets.symmetric(horizontal: 12), //내부 여백
                    decoration: BoxDecoration //박스 장식
                    (
                      color: theme.background, //배경색
                      borderRadius: BorderRadius.circular(20), //둥근 테두리
                      border: Border.all //테두리
                      (
                        color: theme.borderColor.withOpacity(0.7), //테두리 색상
                        width: 1, //테두리 두께
                      ),
                    ),
                    child: TextField //텍스트 필드
                    (
                      controller: _editController, //텍스트 컨트롤러
                      style: TextStyle(color: theme.foreground), //텍스트 스타일
                      decoration: InputDecoration //입력 장식
                      (
                        hintText: "메시지 입력...", //힌트 텍스트
                        hintStyle: TextStyle //힌트 텍스트 스타일
                        (
                          color: theme.foreground.withOpacity(0.4), //힌트 텍스트 색상
                        ),
                        border: InputBorder.none, //테두리 없음
                        //isCollapsed: true, //내부 여백 최소화
                      ),
                      onSubmitted: (_) => _sendMessage(friend), //엔터키로 전송
                    ),
                  ),
                ),
                //이모지 버튼
                IconButton //이모지 버튼
                (
                  icon: Icon //아이콘 버튼
                  (
                    Icons.emoji_emotions_outlined, //이모지 아이콘
                    color: theme.primary, //아이콘 색상
                  ),
                  onPressed: () //버튼 클릭 이벤트
                  {
                    ScaffoldMessenger.of(context).showSnackBar //스낵바 표시
                    (
                      const SnackBar(content: Text("이모지 피커는 나중에!")), //스낵바 내용
                    );
                  },
                ),

                //전송 버튼
                IconButton //전송 버튼
                (
                  icon: Icon //아이콘 버튼
                  (
                    Icons.send, //전송 아이콘
                    color: theme.primary, //아이콘 색상
                  ), //핑크색 전송 아이콘
                  onPressed : () => _sendMessage(friend), //전송 버튼 클릭
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}