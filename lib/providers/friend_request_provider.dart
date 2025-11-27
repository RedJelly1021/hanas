import 'package:flutter/material.dart'; //Flutter 기본 패키지

//친구 검색용 간단 유저 모델
class HanasUserStub
{
  final String name; //유저 이름
  final String emoji; //유저 이모지

  HanasUserStub(this.name, this.emoji); //생성자
}

//친구 요청 모델
class FriendRequest
{
  final String id; //요청 ID
  final String name; //요청자 이름
  final String emoji; //요청자 이모지
  final bool inIncoming; //true = 수신 요청, false = 발신 요청

  FriendRequest //생성자
  ({
    required this.id, //요청 ID
    required this.name, //요청자 이름
    required this.emoji, //요청자 이모지
    required this.inIncoming, //수신/발신 여부
  });
}

class Friend
{
  final String name; //친구 이름
  final String emoji; //친구 이모지

  Friend(this.name, this.emoji); //생성자
}

//친구 요청 / 친구 검색 상태 관리 프로바이더
class FriendRequestProvider extends ChangeNotifier //ChangeNotifier 상속
{
  //내 친구 목록(간단히 이름만 관리)
  final List<Friend> _friends = []; //친구 리스트

  //나에게 온 요청 목록
  final List<FriendRequest> _incomingRequests = []; //수신 요청 리스트

  //내가 보낸 요청 목록
  final List<FriendRequest> _outgoingRequests = []; //발신 요청 리스트

  //앱 안에서만 쓰는 더미 유저 목록 (Firebase 붙이기 전용)
  final List<HanasUserStub> _mockUsers = //모의 유저 데이터
  [
    HanasUserStub("아람찌", "😍"),
    HanasUserStub("윤이", "👧🏻"),
    HanasUserStub("유리", "🌼"),

    HanasUserStub("하늘", "☁️"),
    HanasUserStub("민지", "🐰"),
    HanasUserStub("현우", "🐻"),
    HanasUserStub("다현", "🌸"),
    HanasUserStub("서준", "🌊"),
    HanasUserStub("지우", "⭐"),
    HanasUserStub("예린", "🌼"),
  ];

  FriendRequestProvider() //생성자
  {
    //초기 상태에서 "나를 친구 추가한 사람" 예시
    _incomingRequests.addAll
    ([
      FriendRequest //생성자
      (
        id: "req1",
        name: "하늘",
        emoji: "☁️",
        inIncoming: true,
      ),
      FriendRequest //생성자
      (
        id: "req2",
        name: "민지",
        emoji: "🐰",
        inIncoming: true,
      ),
    ]);

    //이미 친구인 사람 예시
    _friends.addAll
    ([
      Friend("아람찌", "😍"),
      Friend("윤이", "👧🏻"),
      Friend("유리", "🌼"),
    ]);
  }

  //getter 들
  List<Friend> get friends => List.unmodifiable(_friends); //친구 목록
  List<FriendRequest> get incomingRequests => List.unmodifiable(_incomingRequests); //수신 요청 목록
  List<FriendRequest> get outgoingRequests => List.unmodifiable(_outgoingRequests); //발신 요청 목록

  //이름으로 내가 이미 친구인지 확인
  bool isMyFriend(String name) => 
      _friends.any((friend) => friend.name == name); //친구 목록에 이름이 있는지 확인

  //이름 기준으로 나에게 온 요청이 있는지
  bool hasIncomingRequest(String name) =>
      _incomingRequests.any((request) => request.name == name); //수신 요청 목록에 이름이 있는지 확인

  //이름 기준으로 내가 보낸 요청이 있는지
  bool hasOutgoingRequest(String name) =>
      _outgoingRequests.any((request) => request.name == name); //발신 요청 목록에 이름이 있는지 확인
  
  //친구 검색 (더미 데이터에서 이름/이모지 포함 여부로 필터)
  List<HanasUserStub> searchUsers(String query, {String? myName}) //친구 검색 메서드
  {
    final trimmed = query.trim(); //공백 제거
    if (trimmed.isEmpty) return []; //빈 쿼리면 빈 리스트 반환

    final lower = trimmed.toLowerCase(); //소문자 변환

    return _mockUsers.where((user) //필터링
    {
      //자기 자신은 검색 결과에서 빼기
      if (myName != null && user.name == myName) return false; //자기 자신이면 제외

      return user.name.toLowerCase().contains(lower) //이름에 포함 여부
          || user.emoji.contains(trimmed);
    }).toList(); //리스트로 변환하여 반환
  }

  //친구 추가 요청 보내기
  void sendFriendRequest(HanasUserStub user) //친구 요청 메서드
  {
    //이미 친구면 무시
    if (isMyFriend(user.name)) return;

    //이미 보낸 요청이 있으면 무시
    if (hasOutgoingRequest(user.name)) return;

    //상대가 이미 나에게 보낸 요청이 있으면 => 바로 친구 수락으로 처리
    final existingIncoming = _incomingRequests.where((request) => request.name == user.name).toList(); //기존 수신 요청 찾기

    if (existingIncoming.isNotEmpty) //기존 수신 요청이 있으면
    {
      _incomingRequests.removeWhere((req) => req.name == user.name); //기존 수신 요청 제거

      if (!_friends.any((friend) => friend.name == user.name)) //아직 친구가 아니면
      {
        _friends.add(Friend(user.name, user.emoji)); //친구 목록에 추가
      }
      notifyListeners(); //상태 변경 알림
      return;
    }

    //일반적인 "친구 요청" 케이스
    _outgoingRequests.add
    (
      FriendRequest //생성자
      (
        id: "out_${user.name}_${DateTime.now().millisecondsSinceEpoch}", //고유 ID 생성
        name: user.name, //요청자 이름
        emoji: user.emoji, //요청자 이모지
        inIncoming: false, //발신 요청
      ),
    );
    notifyListeners(); //상태 변경 알림
  }

  //친구 요청 수락
  void acceptRequest(String requestId) //수락 메서드
  {
    final index = _incomingRequests.indexWhere((req) => req.id == requestId); //요청 인덱스 찾기

    if (index == -1) return; //요청이 없으면 무시

    final req = _incomingRequests.removeAt(index); //요청 제거

    if (!_friends.any((friend) => friend.name == req.name)) //아직 친구가 아니면
    {
      _friends.add(Friend(req.name, req.emoji)); //친구 목록에 추가
    }
    notifyListeners(); //상태 변경 알림
  }

  //친구 요청 거절
  void declineRequest(String requestId) //거절 메서드
  {
    _incomingRequests.removeWhere((req) => req.id == requestId); //수신 요청에서 제거
    notifyListeners(); //상태 변경 알림
  }

  //친구 삭제
  void removeFriend(String name) //친구 삭제 메서드
  {
    _friends.removeWhere((friend) => friend.name == name); //친구 목록에서 제거
    notifyListeners(); //상태 변경 알림
  }
}