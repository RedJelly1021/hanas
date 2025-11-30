import 'package:flutter/material.dart'; //Flutter 기본 패키지
import 'package:provider/provider.dart'; //상태 관리 패키지
import 'package:hanas/widgets/hanas_card.dart'; //커스텀 카드 위젯
import 'package:hanas/widgets/hanas_header.dart'; //커스텀 헤더 위젯
import 'package:hanas/providers/theme_provider.dart'; //테마 제공자
import 'package:hanas/providers/friends_provider.dart'; //친구 제공자

class FriendsScreen extends StatefulWidget //친구 목록 화면 클래스
{
  const FriendsScreen({super.key}); //생성자

  @override
  State<FriendsScreen> createState() => _FriendsScreenState(); //상태 생성
}

class _FriendsScreenState extends State<FriendsScreen> //친구 목록 화면 상태 클래스
{
  String _searchQuery = ""; //검색 쿼리 상태 변수

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = context.watch<ThemeProvider>().currentTheme; //현재 테마 가져오기
    final friendsProvider = context.watch<FriendsProvider>(); //친구 제공자 가져오기

    //1) Provider에서 친구 목록 가져오기
    final friends = friendsProvider.friends; //내 친구 목록 가져오기

    //2) 검색 + 즐겨찾기 정렬 있으면 같이 처리
    final filtered = friends.where((friend) //검색 필터링
    {
      final display = friendsProvider.displayName(friend.name); //표시용 이름 가져오기
      if(_searchQuery.isEmpty) return true; //검색어 없으면 모두 표시
      return display.contains(_searchQuery) || friend.name.contains(_searchQuery); //이름 또는 별명에 검색어 포함 여부
    }).toList();

    //3) 즐겨찾기 우선 정렬
    final sortedFriends = [...filtered]; //필터링된 친구 목록 복사
    sortedFriends.sort((a, b) { //즐겨찾기 우선 정렬
      final aFav = friendsProvider.isFavorite(a.name); //a가 즐겨찾기인지
      final bFav = friendsProvider.isFavorite(b.name); //b가 즐겨찾기인지
      if (aFav&&!bFav) return -1; //a가 즐겨찾기고 b가 아니면 a가 먼저
      if (!aFav&&bFav) return 1; //b가 즐겨찾기고 a가 아니면 b가 먼저
      return a.name.compareTo(b.name); //둘 다 같으면 이름순 정렬
    });
    
    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //연한 핑크색 배경
      //hanas header
      body: Column //세로 레이아웃
      (
        children: //자식 위젯들
        [
          //헤더 영역
          HanasHeader //헤더 위젯
          (
            title: Row //헤더 제목 영역
            (
              mainAxisAlignment: MainAxisAlignment.center, //가운데 정렬
              children: //자식 위젯들
              [
                Text
                (
                  "내 친구", //헤더 제목
                  style: TextStyle //텍스트 스타일
                  (
                    fontSize: 20, //폰트 크기
                    fontWeight: FontWeight.bold, //굵게
                    color: theme.foreground, //글자 색상
                  ),
                ),
              ],
            ),
            rightActions: //오른쪽 액션들
            [
              IconButton //친구 추가 아이콘 버튼
              (
                icon: Icon(Icons.person_add, color: theme.foreground), //친구 추가 아이콘
                onPressed: () => //탭했을 때
                  Navigator.pushNamed(context, '/friendAdd'), //친구 추가 화면으로 이동
              ),
              IconButton //채팅 아이콘 버튼
              (
                icon: Icon(Icons.chat_bubble, color: theme.foreground), //채팅 아이콘
                onPressed: () => //탭했을 때
                  Navigator.pushNamed(context, '/chatList'), //채팅 목록 화면으로 이동
              ),
              IconButton //설정 아이콘 버튼
              (
                icon: Icon(Icons.settings, color: theme.foreground), //설정 아이콘
                onPressed: () => //탭했을 때
                  Navigator.pushNamed(context, '/settings'), //설정 화면으로 이동
              ),
            ],
          ),
          
          //검색창
          Padding
          (
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), //패딩 설정
            child: TextField //텍스트 필드 위젯
            (
              decoration: InputDecoration //입력 장식
              (
                hintText: "친구 검색...", //힌트 텍스트
                prefixIcon: Icon(Icons.search), //검색 아이콘
                filled: true, //채워진 스타일
                fillColor: theme.cardColor, //채우기 색상
                contentPadding: const EdgeInsets.symmetric(vertical: 8), //내용 패딩
                border: OutlineInputBorder //외곽선 테두리
                (
                  borderRadius: BorderRadius.circular(24), //둥근 테두리
                  borderSide: BorderSide(color: theme.borderColor.withOpacity(0.6)),//테두리 색상
                ),
                focusedBorder: OutlineInputBorder //포커스된 외곽선 테두리
                (
                  borderRadius: BorderRadius.circular(24), //둥근 테두리
                  borderSide: BorderSide(color: theme.primary, width: 1.5), //포커스된 테두리 색상
                ),
              ),
              onChanged: (value) //텍스트 변경 시
              {
                setState(() => _searchQuery = value.trim()); //검색 쿼리 상태 업데이트
              },
            ),
          ),

          //친구 목록 영역
          Expanded
          (
            child: ListView.builder //친구 목록 리스트뷰
            (
              itemCount: sortedFriends.length, //아이템 개수
              itemBuilder: (context, index) //각 아이템 빌더
              {
                final friend = sortedFriends[index]; //현재 친구 데이터 
                
                return HanasCard //카드 위젯
                (
                  background: theme.cardColor, //카드 배경색
                  borderColor: theme.borderColor.withOpacity(0.7), //테두리 색상
                  shadowColor: theme.shadowColor, //그림자 색상
                  shadowOpacity: 0.35, //그림자 불투명도
                  onTap: () //탭했을 때
                  {
                    Navigator.pushNamed //네비게이터로 화면 이동
                    (
                      context, //현재 컨텍스트
                      '/friendDetail', //친구 상세 화면 경로
                      arguments: friend, //친구 데이터 인자 전달
                    ); //채팅 화면으로 이동
                  },
                  child: ListTile //리스트 타일
                  (
                    leading: Text //친구 이모지
                    (
                      friend.emoji, //이모지 텍스트
                      style: const TextStyle(fontSize: 32), //이모지 크기
                    ),
                    title: Text //친구 이름
                    (
                      //friend.name, //이름 텍스트
                      friendsProvider.displayName(friend.name), //별명 있으면 별명, 없으면 원래 이름
                      style: TextStyle //텍스트 스타일
                      (
                        fontSize: 18, //글자 크기
                        fontWeight: FontWeight.w600, //글자 두께
                        color: theme.foreground, //글자 색상
                      ),
                    ),
                    trailing: Row //오른쪽 아이콘들
                    (
                      mainAxisSize: MainAxisSize.min, //최소 크기
                      children: //자식 위젯들
                      [ 
                        GestureDetector //즐겨찾기 아이콘 감지기
                        (
                          behavior: HitTestBehavior.translucent, //투명한 영역도 탭 감지
                          onTap: () //탭했을 때
                          {
                            friendsProvider.toggleFavorite(friend.name); //즐겨찾기 토글
                          },
                          child: Icon //즐겨찾기 아이콘
                          (
                            friendsProvider.isFavorite(friend.name) //즐겨찾기 여부에 따른 아이콘
                                ? Icons.star //즐겨찾기 아이콘
                                : Icons.star_border, //비즐겨찾기 아이콘
                            color: friendsProvider.isFavorite(friend.name) //아이콘 색상
                                ? theme.primary //즐겨찾기면 주요 색상
                                : theme.foreground.withOpacity(0.4), //비즐겨찾기면 연한 색상
                          ),
                        ),
                        const SizedBox(width: 8), //간격
                        Icon(Icons.chevron_right, color: theme.primary), //오른쪽 화살표 아이콘
                      ],
                    ),

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}