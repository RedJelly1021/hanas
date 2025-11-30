import 'package:flutter/material.dart'; //Flutter의 ChangeNotifier 사용
import 'package:hanas/models/chat_message.dart'; //ChatMessage 모델 임포트
import 'package:hanas/models/chat_preview.dart';
import 'package:hanas/providers/friend_request_provider.dart'; //ChatPreview 모델 임포트

class ChatProvider extends ChangeNotifier //채팅 관리 프로바이더
{
  // 1) 채팅 미리보기 리스트
  final List<ChatPreview> _previews = 
  [
    ChatPreview //채팅 미리보기 예시 데이터
    (
      friendName: "민수", //친구 이름
      emoji: "🐱", //친구 이모지
      lastMessage: "어제 고마웠어!", //마지막 메시지
      time: DateTime.now().subtract(const Duration(minutes: 5)), //마지막 메시지 시간
    ),
    ChatPreview //두 번째 채팅 미리보기
    (
      friendName: "지연", //친구 이름
      emoji: "🐰", //친구 이모지
      lastMessage: "사진 봤어?", //마지막 메시지
      time: DateTime.now().subtract(const Duration(hours: 1)), //마지막 메시지 시간
    ),
  ];

  List<ChatPreview> get chatPreviews => List.unmodifiable(_previews); //채팅 미리보기 리스트 getter

  // 2) 친구별 메세지
  final Map<String, List<ChatMessage>> _messages = {}; //친구 이름별 메시지 맵

  List<ChatMessage> messagesFor(Friend friend) //친구 이름으로 메시지 리스트 반환
  {
    return _messages[friend.name] ??= []; //없으면 빈 리스트 반환
  }

  // 3) 메시지 전송
  void sendMessage(Friend friend, String text) //메시지 전송 함수
  {
    final message = ChatMessage //새 메시지 생성
    (
      text: text, //메시지 텍스트
      time: DateTime.now(), //현재 시간
      isMine: true, //내 메시지 여부
    );

    _messages[friend.name] ??= []; //친구 이름에 해당하는 메시지 리스트 초기화
    _messages[friend.name]!.add(message); //메시지 추가

    // 미리보기 업데이트
    final idx = _previews.indexWhere((preview) => preview.friendName == friend.name); //친구 이름에 해당하는 미리보기 인덱스 찾기

    if (idx >= 0) //미리보기가 존재하면
    {
      _previews[idx] = ChatPreview //미리보기 업데이트
      (
        friendName: friend.name, //친구 이름
        emoji: _previews[idx].emoji, //기존 이모지 유지
        lastMessage: text, //새로운 마지막 메시지
        time: message.time, //새로운 시간
      );
    }

    notifyListeners(); //변경 사항 알림
  }
}
