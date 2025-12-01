import 'package:flutter/material.dart'; //플러터 머티리얼 패키지
import 'package:provider/provider.dart'; //프로바이더 패키지

import 'package:hanas/models/chat_message.dart'; //채팅 메시지 모델

import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더

class ChatBubble extends StatelessWidget //채팅 말풍선 위젯 클래스
{
  final ChatMessage message; //메시지 내용
  final bool isEditing; //편집 모드 여부
  final TextEditingController? editingController; //편집 컨트롤러
  final void Function()? onLongPress; //롱프레스 콜백
  final void Function(String newText)? onEditSubmit; //편집 제출 콜백

  const ChatBubble //채팅 말풍선 위젯 생성자
  (
    {
      super.key, //키 값
      required this.message, //메시지 내용
      this.isEditing = false, //편집 모드 여부
      this.editingController, //편집 컨트롤러
      this.onLongPress, //롱프레스 콜백
      this.onEditSubmit, //편집 제출 콜백
    }
  );

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = context.watch<ThemeProvider>().currentTheme; //테마 프로바이더에서 테마 가져오기

    final isMine = message.isMine; //내 메시지인지 여부
    final bubbleColor = isMine ? theme.bubbleMine : theme.bubbleOther; //말풍선 배경색
    final textColor = isMine ? Colors.white : theme.primary; //텍스트 색상
    final borderColor = isMine ? Colors.transparent : theme.primary.withOpacity(0.3); //테두리 색상

    final isDeleted = message.isDeleted; //메시지 삭제 여부

    return GestureDetector
    (
      onLongPress: ()
      {
        Feedback.forLongPress(context); //롱프레스 피드백
        onLongPress?.call(); //콜백 호출
      },
      child: TweenAnimationBuilder<double> //트윈 애니메이션 빌더
      (
        tween: Tween<double>(begin: 0.0, end: 1.0), //애니메이션 트윈
        duration: const Duration(milliseconds: 300), //애니메이션 지속 시간
        curve: Curves.easeOutCubic, //애니메이션 곡선
        builder: (context, value, child) //빌더 메서드
        {
          return Opacity //투명도 위젯
          (
            opacity: value, //투명도 값
            child: Transform.translate //변환 위젯
            (
              offset: Offset(isMine ? 10 * (1 - value) : -10 * (1 - value), 4 * (1 - value)), //이동 오프셋
              child: child, //자식 위젯
            ),
          );
        },
        
        child: Align //정렬 위젯
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
        
              boxShadow: 
              [
                BoxShadow //박스 그림자
                (
                  color: isMine
                      ? theme.primary.withOpacity(0.3)
                      : Colors.black12, //그림자 색상
                  blurRadius: isMine ? 8 : 4, //블러 반경
                  offset: const Offset(0, 2), //오프셋
                ),
              ],
            ),
            child: isEditing
                ? _buildEditingUI(isMine) //편집 UI 빌드
                : _buildNormalUI(isMine, isDeleted, textColor, theme), //일반 UI 빌드
          ),
        ),
      ),
    );
  }

  //일반 UI 빌드 메서드
  Widget _buildNormalUI(bool isMine, bool isDeleted, Color textColor, theme)
  {
    return Column //열 위젯
    (
      crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start, //내 메시지면 오른쪽 정렬
      children: //자식 위젯들
      [
        Text //텍스트 위젯
        (
          isDeleted ? "[삭제된 메시지]" : message.text, //메시지 내용
          style: TextStyle //텍스트 스타일
          (
            color: isDeleted
                ? theme.foreground.withOpacity(0.6)
                : textColor, //텍스트 색상
            fontSize: 16, //폰트 크기
            fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal, //삭제된 메시지면 이탤릭체
          ),
        ),

        const SizedBox(height: 4), //세로 간격

        Row
        (
          mainAxisSize: MainAxisSize.min, //최소 크기
          children: 
          [
            if (message.updatedAt != null && !message.isDeleted)
              Padding
              (
                padding: const EdgeInsets.only(right: 4), //오른쪽 패딩
                child: Icon //아이콘 위젯
                (
                  Icons.edit_outlined, //수정 아이콘
                  size: 12, //아이콘 크기
                  color: isMine ? Colors.white70 : theme.primary, //아이콘 색상
                ),
              ),

            Text //텍스트 위젯
            (
              _formatSmartTime(message.createdAt), //시간 포맷팅
              style: TextStyle //텍스트 스타일
              (
                fontSize: 11, //폰트 크기
                color: isMine ? Colors.white70 : theme.primary, //텍스트 색상
              ),
            ),

            if (isMine)
              Padding
              (
                padding: const EdgeInsets.only(left: 4), //왼쪽 패딩
                child: AnimatedSwitcher
                (
                  duration: const Duration(milliseconds: 200), //애니메이션 지속 시간
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child), //전환 애니메이션
                  child: message.isRead
                      ? Text(
                          "✔",
                          key: const ValueKey("read"),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "🌸",
                          key: const ValueKey("unread"),
                          style: TextStyle
                          (
                            fontSize: 12,
                            color: isMine ? Colors.white70 : theme.primary,
                          ),
                        ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  //편집 UI 빌드 메서드
  Widget _buildEditingUI(bool isMine) 
  {
    final controller = editingController ?? TextEditingController(text: message.text); //편집 컨트롤러 설정
    return Row
    (
      mainAxisSize: MainAxisSize.min, //최소 크기
      children: 
      [
        Flexible
        (
          child: Container
          (
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), //내부 여백
            decoration: BoxDecoration //박스 장식
            (
              color: Colors.white.withOpacity(0.15), //배경색
              borderRadius: BorderRadius.circular(12), //테두리 반경
            ),
            child: TextField //텍스트 필드 위젯
            (
              controller: controller, //컨트롤러 설정
              autofocus: true, //자동 포커스
              cursorColor: Colors.white70, //커서 색상
              style: const TextStyle( //텍스트 스타일
                color: Colors.white, //텍스트 색상
                fontSize: 15, //폰트 크기
              ),
              decoration: const InputDecoration //입력 장식
              (
                isDense: true, //조밀한 스타일
                contentPadding: EdgeInsets.zero, //내용 패딩 없음
                border: InputBorder.none, //테두리 없음
                hintText: "메시지 수정...", //힌트 텍스트
                hintStyle: TextStyle( //힌트 텍스트 스타일
                  color: Colors.white60, //힌트 텍스트 색상
                ),
              ),
              onSubmitted: (value) 
              {
                final trimmed = value.trim(); //공백 제거
                if (trimmed.isEmpty) return; //빈 문자열이면 반환
                onEditSubmit?.call(trimmed); //편집 제출 콜백 호출
              },
            ),
          ),
        ),

        const SizedBox(width: 6), //가로 간격

        //체크 버튼 감성적으로(?)
        GestureDetector //제스처 감지기
        (
          onTap: () 
          {
            final trimmed = controller.text.trim(); //공백 제거
            if (trimmed.isEmpty) return; //빈 문자열이면 반환
            onEditSubmit?.call(trimmed); //편집 제출 콜백 호출
          },
          child: Container
          (
            padding: const EdgeInsets.all(6), //내부 여백
            decoration: BoxDecoration //박스 장식
            (
              color: Colors.white.withOpacity(0.15), //배경색
              shape: BoxShape.circle, //원형 모양
            ),
            child: const Icon //아이콘 위젯
            (
              Icons.check, //체크 아이콘
              size: 18, //아이콘 크기
              color: Colors.white, //아이콘 색상
            ),
          ),
        ),
      ],
    );
  }

  //시간 포맷팅 메서드 (예: 14:05 형식)
  String _formatSmartTime(DateTime time) //스마트 시간 포맷팅 메서드
  {
    final now = DateTime.now(); //현재 시간
    final diff = now.difference(time); //시간 차이 계산

    if (diff.inMinutes < 1) return "방금 전"; //1분 미만
    if (diff.inMinutes < 60) return "${diff.inMinutes}분 전"; //1시간 미만

    if (diff.inHours < 24) { //24시간 미만
      final h = time.hour.toString().padLeft(2, '0'); //시간 포맷팅
      final m = time.minute.toString().padLeft(2, '0'); //분 포맷팅
      return "$h:$m";
    }

    if (diff.inDays == 1) return "어제"; //1일 전

    if (diff.inDays < 7) return "${diff.inDays}일 전"; //7일 미만

    return "${time.year}.${time.month}.${time.day}"; //그 외
  }
}