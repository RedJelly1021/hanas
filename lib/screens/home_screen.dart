//Home Screen + Tap(Friends, Chats)
import 'package:flutter/material.dart'; //플러터 머티리얼 패키지
import 'package:provider/provider.dart'; //프로바이더 패키지 임포트
import 'package:hanas/widgets/hanas_header.dart'; //헤더 위젯 임포트
import 'package:hanas/screens/friends_screen.dart'; //친구 목록 화면 임포트
import 'package:hanas/screens/chat_list_screen.dart'; //채팅 목록 화면 임포트
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 임포트

class HomeScreen extends StatefulWidget //홈 화면 클래스
{
  const HomeScreen({super.key}); //생성자

  @override
  State<HomeScreen> createState() => _HomeScreenState(); //홈 화면 상태 생성
}

class _HomeScreenState extends State<HomeScreen> //홈 화면 상태 클래스
    with SingleTickerProviderStateMixin //탭 컨트롤러를 위한 믹스인
{
  late TabController _tabController; //탭 컨트롤러 선언

  @override
  void initState() //초기화 메서드
  {
    super.initState(); //부모 클래스 초기화
    _tabController = TabController(length: 2, vsync: this); //탭 컨트롤러 초기화
  }

  @override
  void dispose() //리소스 해제 메서드
  {
    _tabController.dispose(); //탭 컨트롤러 해제
    super.dispose(); //부모 클래스 해제
  }

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //연한 핑크색 배경
      body: Column //세로 레이아웃
      (
        children: //자식 위젯들
        [
          //Hanas Header
          HanasHeader
          (
            title: Row //헤더 제목 영역
            (
              mainAxisAlignment: MainAxisAlignment.center, //가운데 정렬
              children: //자식 위젯들
              [
                Text //헤더 제목
                (
                  "${theme.flowerEmoji} HANAS", //헤더 제목
                  style: TextStyle //텍스트 스타일
                  (
                    fontSize: 26, //폰트 크기
                    fontWeight: FontWeight.bold, //굵게
                    color: theme.foreground, //글자 색상
                    letterSpacing: 1.2, //글자 간격
                  ),
                ),
              ],
            ),
            rightActions: //오른쪽 액션들
            [
              IconButton //설정 아이콘 버튼
              (
                icon: Icon(Icons.settings, color: theme.foreground), //설정 아이콘
                onPressed: () //탭했을 때
                {
                  Navigator.pushNamed(context, '/settings'); //설정 화면으로 이동
                },
              ),
            ],
            //첫 화면이기 때문에 뒤로가기 없음
          ),

          //탭 바
          Container
          (
            decoration: BoxDecoration //박스 장식
            (
              gradient: LinearGradient //선형 그라데이션
              (
                colors: //그라데이션 색상
                [
                  theme.appBarGradientStart, //그라데이션 시작 색상
                  theme.appBarGradientEnd, //그라데이션 끝 색상
                ],
                begin: Alignment.topCenter, //그라데이션 시작점
                end: Alignment.bottomCenter, //그라데이션 끝점
              ),
            ),
            child: TabBar //탭 바
            (
              controller: _tabController, //탭 컨트롤러 연결
              indicatorColor: theme.accent, //탭 바 인디케이터 색상
              labelColor: theme.foreground, //선택된 탭 텍스트 색상
              unselectedLabelColor: theme.foreground.withOpacity(0.5), //선택되지 않은 탭 텍스트 색상
              indicatorWeight: 3, //인디케이터 두께
              tabs: const //탭들
              [
                Tab(icon: Icon(Icons.person), text: "친구"), //친구 탭
                Tab(icon: Icon(Icons.chat_bubble_outline), text: "채팅"), //채팅 탭
              ],
            ),
          ),

          //TabBar content
          Expanded
          (
            child: TabBarView //탭 바 뷰
            (
              controller: _tabController, //탭 컨트롤러 연결
              children: const //탭 뷰들
              [
                FriendsScreen(), //친구 목록 화면
                ChatListScreen(), //채팅 목록 화면
              ],
            ),
          ),
        ],
      ),
    );
  }
}