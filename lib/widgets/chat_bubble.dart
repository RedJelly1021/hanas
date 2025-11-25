import 'package:flutter/material.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget //채팅 말풍선 위젯 클래스
{
  final String message; //메시지 내용
  final bool isMine; //내 메시지 여부
  final String time; //메시지 시간

  const ChatBubble //채팅 말풍선 위젯 생성자
  (
    {
      super.key, //키 값
      required this.message, //메시지 내용
      required this.isMine, //내 메시지 여부
      required this.time, //메시지 시간
    }
  );

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    final bubbleColor = isMine ? theme.bubbleMine : theme.bubbleOther; //말풍선 배경색
    final textColor = isMine ? Colors.white : theme.primary; //텍스트 색상
    final borderColor = isMine ? Colors.transparent : theme.primary.withOpacity(0.3); //테두리 색상

    return Align //정렬 위젯
    (
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft, //내 메시지면 오른쪽 정렬
      child: Container //컨테이너 위젯
      (
        margin: const EdgeInsets.symmetric(vertical: 6), //세로 마진
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), //내부 여백
        decoration: BoxDecoration //박스 장식
        (
          color: bubbleColor, //말풍선 배경색
          border: Border.all(color: borderColor), //테두리
          borderRadius: BorderRadius.only //테두리 반경
          (
            topLeft: const Radius.circular(16), //왼쪽 위 모서리 반경
            topRight: const Radius.circular(16), //오른쪽 위 모서리 반경
            bottomLeft: isMine ? const Radius.circular(16) : Radius.zero, //왼쪽 아래 모서리 반경
            bottomRight: isMine ? Radius.zero : const Radius.circular(16), //오른쪽 아래 모서리 반경
          ),

          boxShadow: isMine 
          ? [
            BoxShadow
            (
              color: theme.primary.withOpacity(0.25), //핑크색 반투명
              blurRadius: 8, //흐림 반경
              offset: const Offset(1, 2), //그림자 위치
            )
          ]
          : [
            BoxShadow
            (
              color: Colors.black12, //연한 검정색
              blurRadius: 4, //흐림 반경
              offset: const Offset(1, 2), //그림자 위치
            )
          ]
        ),
        child: Column //열 위젯
        (
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start, //내 메시지면 오른쪽 정렬
          children: //자식 위젯들
          [
            Text //텍스트 위젯
            (
              message, //메시지 내용
              style: TextStyle(color: textColor, fontSize: 16), //텍스트 스타일
            ),
            const SizedBox(height: 4), //간격
            Row //행 위젯
            (
              mainAxisSize: MainAxisSize.min, //최소 크기
              children: //자식 위젯들
              [
                Text //시간 텍스트
                (
                  time, //메시지 시간
                  style: TextStyle //텍스트 스타일
                  (
                    fontSize: 11, //폰트 크기
                    color: isMine ? Colors.white70 : theme.primary, //색상
                  ),
                ),
                if (isMine) //내 메시지면
                  Padding //패딩 위젯
                  (
                    padding: EdgeInsets.only(left: 4), //왼쪽 패딩
                    child: Text(theme.flowerEmoji, style: TextStyle(fontSize: 12)), //꽃 이모지
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}