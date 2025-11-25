import 'package:flutter/material.dart';
import 'package:hanas/providers/favorite_provider.dart';
import 'package:hanas/screens/chat_list_screen.dart'; //채팅 목록 화면 임포트
import 'package:hanas/screens/chat_screen.dart'; //채팅 화면 임포트
import 'package:hanas/screens/friend_detail_screen.dart';
import 'package:hanas/screens/friends_screen.dart'; //친구 목록 화면 임포트
import 'package:hanas/screens/home_screen.dart'; //홈 화면 임포트
import 'package:hanas/screens/login_screen.dart'; //로그인 화면 임포트
import 'package:hanas/screens/profile_screen.dart';
import 'package:hanas/screens/splash_screen.dart'; //스플래시 화면 임포트
import 'package:hanas/screens/settings_screen.dart'; //설정 화면 임포트
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 임포트
import 'package:hanas/screens/theme_select_screen.dart'; //테마 선택 화면 임포트
import 'package:provider/provider.dart'; //프로바이더 패키지 임포트

void main()
{
  //main.dart
  //WidgetsFlutterBinding.ensureInitialized(); // Missing parentheses added here
  //runApp(const HanasApp()); //HANAS 앱 실행
  runApp //프로바이더 적용
  (
    MultiProvider //ChangeNotifierProvider로 감싸기
    (
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()), //즐겨찾기 프로바이더 생성
        ChangeNotifierProvider(create: (_) => ThemeProvider()), //테마 프로바이더 생성
      ],
      child: const HanasApp(), //HANAS 앱
    ),
  );
}

class HanasApp extends StatelessWidget //HANAS 앱 메인 클래스
{
  const HanasApp({super.key});

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false, //우측 상단 디버그 배너 제거
      title: 'HANAS', //앱 제목
      theme: ThemeData
      (
        useMaterial3: true, //Material 3 디자인 사용
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent), //시드 색상으로 색상표 생성
        fontFamily: 'NotoSans', //기본 폰트 설정, 나중에 assets에 추가해도 됨
      ),
      initialRoute: '/splash', //초기 화면을 스플래시 화면으로 설정
      routes: //화면 라우트 설정
      {
        '/splash': (context) => const SplashScreen(), //스플래시 화면
        '/login': (context) => const LoginScreen(), //로그인 화면
        '/home': (context) => const HomeScreen(), //홈 화면
        '/friends': (context) => const FriendsScreen(), //친구 목록 화면
        '/chatList': (context) => const ChatListScreen(), //채팅 목록 화면
        '/chat': (context) => const ChatScreen(), //채팅 화면
        '/settings': (context) => const SettingsScreen(), //설정 화면
        '/profile': (context) => const ProfileScreen(), //프로필 화면
        '/theme': (context) => const ThemeSelectScreen(), //테마 선택 화면
        '/friendDetail': (context) 
        {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return FriendDetailScreen
          (
            name: args['name'],
            emoji: args['emoji'],
          );
        },
      },
    );
  }
}

//임시 홈 화면
class PlaceholderHome extends StatelessWidget //임시 홈 화면 클래스
{
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    return Scaffold //기본 화면 구조
    ( 
      appBar: AppBar //앱 바
      (
        title: const Text('HANAS 홈 화면'), //앱 바 제목
      ),
      body: const Center //중앙 정렬
      (
        child: Text
        (
          'HANAS 앱에 오신 것을 환영합니다!',
          style: TextStyle(fontSize: 20), //텍스트 스타일
        ),
      ),
    );
  }
}
