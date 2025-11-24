import 'package:flutter/material.dart';
import 'package:hanas/screens/friends_screen.dart'; //친구 목록 화면 임포트
import 'package:hanas/screens/login_screen.dart'; //로그인 화면 임포트
import 'package:hanas/screens/splash_screen.dart'; //스플래시 화면 임포트

void main()
{
  //main.dart
  WidgetsFlutterBinding.ensureInitialized(); // Missing parentheses added here
  runApp(const HanasApp()); //HANAS 앱 실행
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
        '/friends': (context) => const FriendsScreen(), //친구 목록 화면
        '/chat': (context) => const PlaceholderHome(), //채팅 화면
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
