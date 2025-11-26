import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hanas/widgets/chat_bubble.dart';
import 'package:hanas/widgets/hanas_header.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:hanas/providers/friend_nickname_provider.dart';

class ChatScreen extends StatefulWidget //채팅 화면 클래스
{
  const ChatScreen({super.key}); //생성자

  @override
  State<ChatScreen> createState() => _ChatScreenState(); //상태 생성
}

class _ChatScreenState extends State<ChatScreen> //채팅 화면 상태 클래스
{
  List<String> messages = []; //채팅 메시지 리스트
  final TextEditingController _controller = TextEditingController(); //텍스트 컨트롤러

  void _sendMessage() //메시지 전송 메서드
  {
    final text = _controller.text.trim(); //텍스트 가져오기
    if (text.isEmpty) return; //빈 텍스트면 리턴

    setState(() //상태 변경
    {
      messages.add(text); //메시지 리스트에 추가
    });

    _controller.clear(); //텍스트 필드 비우기
  }

  String _formatTime()
  {
    final now = DateTime.now(); //현재 시간 가져오기
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}"; //시간 형식화
  }

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    final friendName = 
        (ModalRoute.of(context)?.settings.arguments ?? "알 수 없음") as String; //친구 이름 가져오기
    final nicknameProvider = Provider.of<FriendNicknameProvider>(context);
    final displayName = nicknameProvider.displayName(friendName); // 표시용 이름 가져오기

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
            //title: friendName, //헤더 제목
            title: displayName, //별명 있으면 별명, 없으면 원래 이름
            onBack: () => Navigator.pop(context), //뒤로가기 콜백
          ),
          //메시지 표시 영역
          Expanded
          (
            child: ListView.builder //메시지 리스트뷰
            (
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //패딩
              itemCount: messages.length, //메시지 개수
              itemBuilder: (context, index) //아이템 빌더
              {
                final isMine = index % 2 == 0; //임시로 짝수 인덱스를 내 메시지로 간주

                return ChatBubble //채팅 말풍선
                (
                  message: messages[index], //메시지 내용
                  isMine: isMine, //내 메시지 여부
                  time: _formatTime(), //메시지 시간
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
                IconButton
                (
                  icon: Icon
                  (
                    Icons.add_circle_outline, 
                    color: theme.primary,
                  ),
                  onPressed: () 
                  {
                    ScaffoldMessenger.of(context).showSnackBar //스낵바 표시
                    (
                      const SnackBar(content: Text("사진/파일 보내기는 나중에!")), //스낵바 내용
                    );
                  },
                ),

                Expanded //확장 위젯
                (
                  child: Container
                  (
                    padding: const EdgeInsets.symmetric(horizontal: 12), //내부 여백
                    decoration: BoxDecoration //박스 장식
                    (
                      color: theme.background, //배경색
                      borderRadius: BorderRadius.circular(20), //둥근 테두리
                      border: Border.all
                      (
                        color: theme.borderColor.withOpacity(0.7), //테두리 색상
                        width: 1, //테두리 두께
                      ),
                    ),
                    child: TextField //텍스트 필드
                    (
                      controller: _controller, //텍스트 컨트롤러
                      style: TextStyle(color: theme.foreground), //텍스트 스타일
                      decoration: InputDecoration //입력 장식
                      (
                        hintText: "메시지 입력...", //힌트 텍스트
                        hintStyle: TextStyle //힌트 텍스트 스타일
                        (
                          color: theme.foreground.withOpacity(0.4), //힌트 텍스트 색상
                        ),
                        border: InputBorder.none, //테두리 없음
                        isCollapsed: true, //내부 여백 최소화
                      ),
                      onSubmitted: (_) => _sendMessage(), //엔터키로 전송
                    ),
                  ),
                ),
                //이모지 버튼
                IconButton //이모지 버튼
                (
                  icon: Icon
                  (
                    Icons.emoji_emotions_outlined, 
                    color: theme.primary,
                  ),
                  onPressed: () 
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
                  icon: Icon
                  (
                    Icons.send,
                    color: theme.primary
                  ), //핑크색 전송 아이콘
                  onPressed: _sendMessage, //전송 버튼 클릭
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}