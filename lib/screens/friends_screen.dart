import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hanas/widgets/hanas_card.dart';
import 'package:hanas/widgets/hanas_header.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:hanas/providers/favorite_provider.dart';
import 'package:hanas/providers/friend_nickname_provider.dart';

class Friend //친구 모델 클래스
{
  final String name; //친구 이름
  final String emoji; //친구 이모지

  Friend(this.name, this.emoji); //생성자
}

final mockFriends = //모의 친구 데이터
[
  Friend("아람찌", "😍"),
  Friend("윤이", "👧🏻"),
  Friend("유리", "🌼"),
];

class FriendsScreen extends StatefulWidget //친구 목록 화면 클래스
{
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> 
{
  String _searchQuery = ""; //검색 쿼리 상태 변수

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final nicknameProvider = Provider.of<FriendNicknameProvider>(context);

    // 검색 + 즐겨찾기 정렬 있으면 같이 처리
    final filtered = mockFriends.where((friend) 
    {
      final display = nicknameProvider.displayName(friend.name);
      if(_searchQuery.isEmpty) return true;
      return display.contains(_searchQuery) || friend.name.contains(_searchQuery);
    }).toList();

    final sortedFriends = [...filtered];
    sortedFriends.sort((a, b) {
      final aFav = favoriteProvider.isFavorite(a.name);
      final bFav = favoriteProvider.isFavorite(b.name);
      if (aFav&&!bFav) return -1;
      if (!aFav&&bFav) return 1;
      return a.name.compareTo(b.name);
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
            title: Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                Icon(Icons.person_outline, color: theme.accent, size: 20),
                const SizedBox(width: 8),
                Text
                (
                  "내 친구", //헤더 제목
                  style: TextStyle
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
                onPressed: () //탭했을 때
                {
                  //TODO : 친구 추가 기능 구현
                  ScaffoldMessenger.of(context).showSnackBar //Snackbar 표시
                  (
                    const SnackBar(content: Text("친구 추가 기능은 나중에!")), //Snackbar 내용
                  );
                },
              ),
              IconButton
              (
                icon: Icon(Icons.chat_bubble, color: theme.foreground), //채팅 아이콘
                onPressed: () => //탭했을 때
                  Navigator.pushNamed(context, '/chatList'), //채팅 목록 화면으로 이동
              ),
              IconButton
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
                    Navigator.pushNamed
                    (
                      context,
                      '/friendDetail',
                      arguments: 
                      {
                        'name': friend.name, //친구 이름 전달
                        'emoji': friend.emoji, //친구 이모지 전달
                        //'displayName': nicknameProvider.displayName(friend.name), // 표시용 이름 전달
                      },
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
                      nicknameProvider.displayName(friend.name), //별명 있으면 별명, 없으면 원래 이름
                      style: TextStyle //텍스트 스타일
                      (
                        fontSize: 18, //글자 크기
                        fontWeight: FontWeight.w600, //글자 두께
                        color: theme.foreground, //글자 색상
                      ),
                    ),
                    trailing: Row
                    (
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            favoriteProvider.toggleFavorite(friend.name);
                          },
                          child: Icon(
                            favoriteProvider.isFavorite(friend.name)
                                ? Icons.star
                                : Icons.star_border,
                            color: favoriteProvider.isFavorite(friend.name)
                                ? theme.primary
                                : theme.foreground.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: theme.primary),
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