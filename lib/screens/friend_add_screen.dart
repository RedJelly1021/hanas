import 'package:flutter/material.dart'; //Flutter 기본 패키지
import 'package:hanas/models/friend.dart';
import 'package:hanas/providers/friends_provider.dart';
import 'package:provider/provider.dart'; //상태 관리 패키지
import 'package:hanas/widgets/hanas_card.dart'; //커스텀 카드 위젯
import 'package:hanas/widgets/hanas_header.dart'; //커스텀 헤더 위젯
import 'package:hanas/providers/theme_provider.dart'; //테마 제공자
import 'package:hanas/providers/user_profile_provider.dart'; //사용자 프로필 제공자
import 'package:hanas/providers/friend_request_provider.dart'; //친구 요청 제공자

class FriendAddScreen extends StatefulWidget //친구 추가 화면 클래스
{
  const FriendAddScreen({super.key}); //생성자

  @override
  State<FriendAddScreen> createState() => _FriendAddScreenState(); //상태 생성
}

class _FriendAddScreenState extends State<FriendAddScreen> //친구 추가 화면 상태 클래스
{
  final TextEditingController _searchController = TextEditingController(); //검색 입력 컨트롤러
  String _searchQuery = ""; //검색 쿼리 상태 변수

  @override
  void dispose() //상태 해제 메서드
  {
    _searchController.dispose(); //컨트롤러 해제
    super.dispose(); //부모 클래스 해제
  }

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = context.watch<ThemeProvider>().currentTheme; //현재 테마 가져오기
    final myNickname = context.watch<UserProfileProvider>().nickname; //내 닉네임 가져오기
    final friendRequestProvider = context.watch<FriendRequestProvider>(); //친구 요청 제공자 가져오기

    //검색 결과
    final searchResults = friendRequestProvider.searchUsers //검색된 유저들
    (
      _searchQuery, //검색 쿼리
      myName: myNickname, //내 닉네임
    );

    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //배경 색상
      body: SafeArea //안전 영역
      (
        child: Column //세로 정렬
        (
          children: //자식 위젯들
          [
            //상단 헤더
            HanasHeader
            (
              title: Text //헤더 제목 텍스트
              (
                '친구 추가', //헤더 제목
                style: TextStyle //헤더 텍스트 스타일
                (
                  fontSize: 18, //폰트 크기
                  fontWeight: FontWeight.bold, //폰트 굵기
                  color: theme.foreground, //텍스트 색상
                ),
              ),
              onBack: () //뒤로 가기 콜백
              {
                Navigator.pop(context); //이전 화면으로 돌아가기
              },
            ),

            //위 / 아래 반반 레이아웃
            Expanded 
            (
              child: Column //세로 정렬
              (
                children: //자식 위젯들
                [
                  //위쪽 : 친구 검색 + 추가
                  Expanded
                  (
                    child: Padding //패딩 위젯
                    (
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), //패딩 설정
                      child: Column //세로 정렬
                      (
                        crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                        children: //자식 위젯들
                        [
                          Text //섹션 제목
                          (
                            "친구 검색", //섹션 제목
                            style: TextStyle //텍스트 스타일
                            (
                              fontSize: 16, //폰트 크기
                              fontWeight: FontWeight.bold, //폰트 굵기
                              color: theme.foreground, //텍스트 색상
                            ),
                          ),
                          const SizedBox(height: 4), //간격
                          Text
                          (
                            "이름이나 이모지로 친구를 검색해서 추가할 수 있어요.", //섹션 설명
                            style: TextStyle //텍스트 스타일
                            (
                              fontSize: 12, //폰트 크기
                              color: theme.foreground.withOpacity(0.7), //투명도 적용된 텍스트 색상
                            ),
                          ),
                          const SizedBox(height: 12), //간격

                          //검색 입력창
                          TextField //텍스트 필드 위젯
                          (
                            controller: _searchController, //컨트롤러 설정
                            onChanged: (value) 
                            {
                              setState(() //상태 업데이트
                              {
                                _searchQuery = value; //검색 쿼리 업데이트
                              });                              
                            },
                            decoration: InputDecoration //입력창 장식
                            (
                              hintText: "닉네임 또는 이모지를 입력하세요", //힌트 텍스트
                              filled: true, //채워진 스타일
                              fillColor: theme.cardColor, //채우기 색상
                              prefixIcon: const Icon(Icons.search), //검색 아이콘
                              border: OutlineInputBorder //테두리 스타일
                              (
                                borderRadius: BorderRadius.circular(12), //둥근 테두리
                                borderSide: BorderSide(color: theme.borderColor), //테두리 색상
                              ),
                              enabledBorder: OutlineInputBorder //활성화된 테두리 스타일
                              (
                                borderRadius: BorderRadius.circular(12), //둥근 테두리
                                borderSide: BorderSide(color: theme.borderColor), //테두리 색상
                              ),
                              focusedBorder: OutlineInputBorder //포커스된 테두리 스타일
                              (
                                borderRadius: BorderRadius.circular(12), //둥근 테두리
                                borderSide: BorderSide(color: theme.accent, width: 2), //테두리 색상
                              ),
                            ),
                          ),

                          const SizedBox(height: 12), //간격

                          //검색 결과 리스트
                          Expanded
                          (
                            child: searchResults.isEmpty //검색 결과가 없을 때
                            ? Center //중앙 정렬
                            (
                              child: Text //텍스트 위젯
                              (
                                _searchQuery.trim().isEmpty //빈 쿼리일 때
                                  ? "친구를 검색해보세요." //힌트 텍스트
                                  : "검색 결과가 없어요.", //검색 결과 없음 텍스트
                                style: TextStyle //텍스트 스타일
                                (
                                  color: theme.foreground.withOpacity(0.6), //투명도 적용된 텍스트 색상
                                ),
                              ),
                            )
                            : ListView.builder //검색 결과 리스트 뷰
                            (
                              itemCount: searchResults.length, //아이템 개수
                              itemBuilder: (context, index) //아이템 빌더
                              {
                                final user = searchResults[index]; //검색된 사용자
                                final isFriend = context.read<FriendsProvider>().isFriend(user.name); //이미 친구인지 확인
                                final hasIncoming = friendRequestProvider.hasIncomingRequest(user.name); //수신 요청 있는지
                                final hasOutgoing = friendRequestProvider.hasOutgoingRequest(user.name); //발신 요청 있는

                                String statusText = ""; //상태 텍스트
                                Color statusColor = theme.foreground.withOpacity(0.7); //상태 색상
                                bool showAddButton = false; //추가 버튼 표시 여부

                                if (isFriend) //이미 친구인 경우
                                {
                                  statusText = "이미 친구예요"; //상태 텍스트 설정
                                  statusColor = theme.accent; //상태 색상 설정
                                }
                                else if (hasIncoming) //수신 요청 있는 경우
                                {
                                  statusText = "나에게 온 요청이 있어요"; //상태 텍스트 설정
                                  statusColor = theme.accent; //상태 색상 설정
                                }
                                else if (hasOutgoing) //발신 요청 있는 경우
                                {
                                  statusText = "요청을 보냈어요"; //상태 텍스트 설정
                                  statusColor = theme.foreground.withOpacity(0.6); //상태 색상 설정
                                }
                                else //아직 친구 요청을 보내지 않은 경우
                                {
                                  showAddButton = true; //추가 버튼 표시
                                }

                                return Padding //패딩 위젯
                                (
                                  padding: const EdgeInsets.only(bottom: 8), //아래쪽 패딩
                                  child: HanasCard //카드 위젯
                                  (
                                    onTap: null, //탭 콜백 없음
                                    child: Row //행 정렬
                                    (
                                      children: //자식 위젯들
                                      [
                                        //이모지 원형
                                        Container //원형 컨테이너
                                        (
                                          width: 40, //너비
                                          height: 40, //높이
                                          decoration: BoxDecoration //장식
                                          (
                                            color: theme.cardColor, //카드 배경색
                                            shape: BoxShape.circle, //원형 모양
                                            border: Border.all(color: theme.borderColor), //테두리
                                          ),
                                          alignment: Alignment.center, //중앙 정렬
                                          child: Text //이모지 텍스트
                                          (
                                            user.emoji, //사용자 이모지
                                            style: const TextStyle(fontSize: 22), //폰트 크기
                                          ),
                                        ),
                                        const SizedBox(width: 12), //간격
                                        Expanded //확장 위젯
                                        (
                                          child: Column //세로 정렬
                                          (
                                            crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                                            children: //자식 위젯들
                                            [
                                              Text //이름 텍스트
                                              (
                                                user.name, //사용자 이름
                                                style: TextStyle //텍스트 스타일
                                                (
                                                  fontSize: 14, //폰트 크기
                                                  fontWeight: FontWeight.w600, //폰트 굵기
                                                  color: theme.foreground, //텍스트 색상
                                                ),
                                              ),
                                              if (!showAddButton) //추가 버튼이 아닌 경우 상태 텍스트 표시
                                              Text //상태 텍스트
                                              (
                                                statusText, //상태 텍스트
                                                style: TextStyle //텍스트 스타일
                                                (
                                                  fontSize: 12, //폰트 크기
                                                  color: statusColor, //상태 색상
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (showAddButton) //추가 버튼 표시
                                        TextButton //텍스트 버튼
                                        (
                                          onPressed: () //버튼 눌렀을 때
                                          {
                                            final reqProvider = context.read<FriendRequestProvider>(); //친구 요청 제공자
                                            final friendsProvider = context.read<FriendsProvider>(); //친구 제공자 가져오기
                                            reqProvider.sendFriendRequest(user, friendsProvider); //친구 요청 보내기
                                          },
                                          child: Text //버튼 텍스트
                                          (
                                            "친구 추가", //버튼 텍스트
                                            style: TextStyle(color: theme.primary), //텍스트 색상
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //구분선
                  Container //구분선 컨테이너
                  (
                    height: 1, //높이
                    color: theme.borderColor.withOpacity(0.5), //반투명 테두리 색상
                  ),
                  //아래쪽: 나를 친구 추가한 사람 목록
                  Expanded
                  (
                    child: Padding //패딩 위젯
                    (
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), //패딩 설정
                      child: Column //세로 정렬
                      (
                        crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                        children: //자식 위젯들
                        [
                          Row //행 정렬
                          (
                            children: //자식 위젯들
                            [
                              Text //텍스트 위젯
                              (
                                "나를 친구 추가한 사람", //섹션 제목
                                style: TextStyle //텍스트 스타일
                                (
                                  fontSize: 16, //폰트 크기
                                  fontWeight: FontWeight.bold, //굵게
                                  color: theme.foreground, //전경 색상
                                ),
                              ),
                              const SizedBox(width: 6), //간격
                              Container //상태 설명 컨테이너
                              (
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), //패딩 설정
                                decoration: BoxDecoration //박스 장식
                                (
                                  color: theme.accent.withOpacity(0.2), //배경 색상
                                  borderRadius: BorderRadius.circular(999), //둥근 모서리
                                ),
                                child: Text //텍스트 위젯
                                (
                                  "아직 친구가 아니에요", //상태 설명
                                  style: TextStyle //텍스트 스타일
                                  (
                                    fontSize: 11, //폰트 크기
                                    color: theme.foreground.withOpacity(0.7), //투명도 적용된 텍스트 색상
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4), //간격
                          Text //텍스트 위젯
                          (
                            "나를 친구 추가한 사람들의 목록이에요. 친구 요청을 수락해보세요!", //섹션 설명
                            style: TextStyle //텍스트 스타일
                            (
                              fontSize: 12, //폰트 크기
                              color: theme.foreground.withOpacity(0.7), //투명도 적용된 텍스트 색상
                            ),
                          ),
                          const SizedBox(height: 12), //간격

                          Expanded //확장 위젯
                          (
                            child: friendRequestProvider.incomingRequests.isEmpty //수신 요청이 없는 경우
                            ? Center //중앙 정렬
                            (
                              child: Text //텍스트 위젯
                              (
                                "아직 나를 친구 추가한 사람이 없어요.", //빈 상태 텍스트
                                style: TextStyle //텍스트 스타일
                                (
                                  color: theme.foreground.withOpacity(0.6), //투명도 적용된 텍스트 색상
                                ),
                              ),
                            )
                            : ListView.builder //수신 요청 리스트 뷰
                            (
                              itemCount: friendRequestProvider.incomingRequests.length, //아이템 개수
                              itemBuilder: (context, index) //아이템 빌더
                              {
                                final req = friendRequestProvider.incomingRequests[index]; //수신 요청

                                return Padding //패딩 위젯
                                (
                                  padding: const EdgeInsets.only(bottom: 8), //아래쪽 패딩
                                  child: HanasCard //카드 위젯
                                  (
                                    onTap: null, //탭 콜백 없음
                                    child: Row //행 정렬
                                    (
                                      children: //자식 위젯들
                                      [
                                        //이모지 원형
                                        Container //원형 컨테이너
                                        (
                                          width: 40, //너비
                                          height: 40, //높이
                                          decoration: BoxDecoration //박스 장식
                                          (
                                            color: theme.cardColor, //카드 배경색
                                            shape: BoxShape.circle, //원형 모양
                                            border: Border.all(color: theme.borderColor), //테두리
                                          ),
                                          alignment: Alignment.center, //중앙 정렬
                                          child: Text //이모지 텍스트
                                          (
                                            req.emoji, //요청자 이모지
                                            style: const TextStyle(fontSize: 22), //폰트 크기
                                          ),
                                        ),
                                        const SizedBox(width: 12), //간격
                                        Expanded //확장 위젯
                                        (
                                          child: Column //세로 정렬
                                          (
                                            crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                                            children: //자식 위젯들
                                            [
                                              Text //이름 텍스트
                                              (
                                                req.name, //요청자 이름
                                                style: TextStyle //텍스트 스타일
                                                (
                                                  fontSize: 14, //폰트 크기
                                                  fontWeight: FontWeight.w600, //폰트 굵기
                                                  color: theme.foreground, //텍스트 색상
                                                ),
                                              ),
                                              Text //상태 텍스트
                                              (
                                                "나를 친구로 추가했어요", //상태 텍스트
                                                style: TextStyle //텍스트 스타일
                                                (
                                                  fontSize: 12, //폰트 크기
                                                  color: theme.foreground.withOpacity(0.7), //투명도 적용된 텍스트 색상
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton //수락 버튼
                                        (
                                          onPressed: () //버튼 눌렀을 때
                                          {
                                            context.read<FriendRequestProvider>().declineRequest(req.id); //친구 요청 거절
                                          },
                                          child: Text //버튼 텍스트
                                          (
                                            "거절", //버튼 텍스트
                                            style: TextStyle //텍스트 스타일
                                            (
                                              color: theme.foreground.withOpacity(0.7), //텍스트 색상
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4), //간격
                                        TextButton //수락 버튼
                                        (
                                          onPressed: () //버튼 눌렀을 때
                                          {
                                            final reqProvider = context.read<FriendRequestProvider>(); //친구 요청 제공자
                                            final friendProvider = context.read<FriendsProvider>(); //친구 제공자

                                            final reqData = reqProvider.incomingRequests[index]; //요청 데이터
                                            reqProvider.acceptRequest(req.id); //친구 요청 수락
                                            friendProvider.addFriend(Friend //친구 추가
                                            (
                                              name: reqData.name, //이름
                                              emoji: reqData.emoji, //이모지
                                            ));
                                          },
                                          child: Text //버튼 텍스트
                                          (
                                            "수락", //버튼 텍스트
                                            style: TextStyle //텍스트 스타일
                                            (
                                              color: theme.primary, //텍스트 색상
                                              fontWeight: FontWeight.bold, //폰트 굵기
                                            ), //텍스트 스타일
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
