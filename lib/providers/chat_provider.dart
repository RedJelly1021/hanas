import 'package:flutter/material.dart'; //Flutter의 ChangeNotifier 사용

import 'package:hanas/models/friend.dart'; //Friend 모델 임포트
import 'package:hanas/models/chat_message.dart'; //ChatMessage 모델 임포트
import 'package:hanas/models/chat_preview.dart'; //ChatPreview 모델 임포트

class ChatProvider extends ChangeNotifier //채팅 관리 프로바이더
{
  // 1) 채팅 미리보기 리스트
  final List<ChatPreview> _previews = []; //채팅 미리보기 리스트 초기화

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
    final now = DateTime.now(); //현재 시간 저장

    final message = ChatMessage //새 메시지 생성
    (
      id: "msg_${now.millisecondsSinceEpoch}", //고유 메시지 ID 생성
      sender: "me", //보낸 사람 설정
      text: text, //메시지 텍스트
      createdAt: now, //현재 시간
      updatedAt: null, //업데이트 시간 초기화
      isMine: true, //내 메시지 여부
      isRead: false, //읽음 여부
      isDeleted: false, //삭제 여부
      type: 'text', //메시지 타입
    );

    final list = messagesFor(friend); //친구의 메시지 리스트 가져오기
    list.add(message); //메시지 리스트에 새 메시지 추가

    _updatePreview(friend, message); //미리보기 업데이트

    notifyListeners(); //변경 사항 알림
  }

  // 4) 메시지 삭제 (soft delete)
  void deleteMessage(Friend friend, String messageId) //메시지 삭제 함수
  {
    final list = messagesFor(friend); //친구 이름에 해당하는 메시지 리스트 가져오기
    final index = list.indexWhere((msg) => msg.id == messageId); //메시지 ID로 인덱스 찾기
    if (index == -1) return; //없으면 종료

    final old = list[index]; //기존 메시지 가져오기

    final deleted = ChatMessage //삭제된 메시지 객체 생성
    (
      id: old.id, //기존 ID 유지
      sender: old.sender, //기존 보낸 사람 유지
      text: "[삭제된 메시지]", //삭제된 메시지 표시
      createdAt: old.createdAt, //기존 생성 시간 유지
      updatedAt: DateTime.now(), //업데이트 시간 현재로 설정
      isMine: old.isMine, //기존 내 메시지 여부 유지
      isRead: old.isRead, //기존 읽음 여부 유지
      isDeleted: true, //삭제 상태로 설정
      type: old.type, //기존 타입 유지
    );

    list[index] = deleted; //메시지 리스트에 삭제된 메시지로 업데이트

    _updatePreview(friend, deleted); //미리보기 업데이트

    notifyListeners(); //변경 사항 알림
  }

  // 5) 읽음 상태 업데이트
  void markAsRead(Friend friend) //메시지 읽음 상태 업데이트 함수
  {
    final list = messagesFor(friend); //친구 이름에 해당하는 메시지 리스트 가져오기

    for (int i = 0; i < list.length; i++) //메시지 리스트 순회
    {
      if (!list[i].isRead && !list[i].isMine) //읽지 않은 메시지인 경우
      {
        final msg = list[i]; //기존 메시지 가져오기
        list[i] = msg.copyWith(isRead: true); //읽음 상태로 복사본 생성
      }
    }

    final idx = _previews.indexWhere((preview) => preview.friendName == friend.name); //미리보기 인덱스 찾기
    if (idx != -1)
    {
      _previews[idx] = _previews[idx].copyWith(unreadCount: 0); //읽지 않은 메시지 수 0으로 설정
    }

    notifyListeners(); //변경 사항 알림
  }

  // 6) 채팅 미리보기 보장
  ChatPreview _ensurePreview(Friend friend) //채팅 미리보기 보장 함수
  {
    final idx = _previews.indexWhere((preview) => preview.friendName == friend.name); //미리보기 인덱스 찾기
    
    if (idx != -1) return _previews[idx]; //이미 존재하면 반환

    final preview = ChatPreview //새 채팅 미리보기 생성
    (
      friendName: friend.name, //친구 이름
      emoji: friend.emoji, //친구 이모지
      lastMessage: '', //마지막 메시지 초기화
      time: DateTime.fromMicrosecondsSinceEpoch(0), //시간 초기화
      isDeleted: false, //삭제 상태 초기화
      isMine: false, //내 메시지 여부 초기화
      type: 'text', //타입 초기화
      unreadCount: 0, //읽지 않은 메시지 수 초기화
    );

    _previews.add(preview); //미리보기 리스트에 추가
    return preview; //새 미리보기 반환
  }

  // 7) 채팅 미리보기 업데이트
  void _updatePreview(Friend friend, ChatMessage message) //채팅 미리보기 업데이트 함수
  {
    final idx = _previews.indexWhere((preview) => preview.friendName == friend.name); //미리보기 인덱스 찾기
    final preview = _ensurePreview(friend); //미리보기 보장

    final updated = preview.copyWith //미리보기 복사본 생성
    (
      lastMessage: message.isDeleted ? "[삭제된 메시지]" : message.text, //마지막 메시지 설정
      time: message.createdAt, //시간 설정
      isDeleted: message.isDeleted, //삭제 상태 설정
      isMine: message.isMine, //내 메시지 여부 설정
      type: message.type, //타입 설정
      unreadCount: message.isMine ? preview.unreadCount : preview.unreadCount + 1, //읽지 않은 메시지 수 설정
    );

    if (idx == -1) //미리보기가 없으면 추가
    {
      _previews.add(updated); //미리보기 리스트에 추가
    }
    else //미리보기가 있으면 업데이트
    {
      _previews[idx] = updated; //미리보기 리스트 업데이트
    }
  }
}
