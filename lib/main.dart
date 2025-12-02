import 'package:flutter/material.dart'; //플러터 머티리얼 패키지 임포트
import 'package:provider/provider.dart'; //프로바이더 패키지 임포트
import 'package:firebase_core/firebase_core.dart'; //파이어베이스 코어 패키지 임포트
import 'firebase_options.dart'; //파이어베이스 옵션 임포트

import 'package:hanas/models/friend.dart'; //Friend 모델 임포트

import 'package:hanas/screens/splash_screen.dart'; //스플래시 화면 임포트
import 'package:hanas/screens/home_screen.dart'; //홈 화면 임포트
import 'package:hanas/screens/login_screen.dart'; //로그인 화면 임포트
import 'package:hanas/screens/chat_screen.dart'; //채팅 화면 임포트
import 'package:hanas/screens/chat_list_screen.dart'; //채팅 목록 화면 임포트
import 'package:hanas/screens/friend_detail_screen.dart'; //친구 상세 화면 임포트
import 'package:hanas/screens/friends_screen.dart'; //친구 목록 화면 임포트
import 'package:hanas/screens/profile_screen.dart'; //프로필 화면 임포트
import 'package:hanas/screens/settings_screen.dart'; //설정 화면 임포트
import 'package:hanas/screens/theme_select_screen.dart'; //테마 선택 화면 임포트
import 'package:hanas/screens/friend_add_screen.dart'; //친구 추가 화면 임포트

import 'package:hanas/providers/chat_provider.dart'; //채팅 프로바이더 임포트
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 임포트
import 'package:hanas/providers/friends_provider.dart'; //친구 프로바이더 임포트
import 'package:hanas/providers/user_profile_provider.dart'; //유저 프로필 프로바이더 임포트
import 'package:hanas/providers/friend_request_provider.dart'; //친구 요청 프로바이더 임포트
import 'package:hanas/providers/friend_nickname_provider.dart'; //친구 닉네임 프로바이더 임포트
import 'package:hanas/providers/firestore_friend_provider.dart'; // Firestore 친구 프로바이더 임포트
import 'package:hanas/providers/firestore_user_provider.dart'; // Firestore 유저 프로바이더 임포트
import 'package:hanas/providers/firestore_chat_provider.dart'; // Firestore 채팅 프로바이더 임포트

void main() async
{
  //main.dart
  WidgetsFlutterBinding.ensureInitialized(); //플러터 바인딩 초기화
  await Firebase.initializeApp( //파이어베이스 초기화
    options: DefaultFirebaseOptions.currentPlatform, //플랫폼별 옵션 적용
  );
  runApp //프로바이더 적용
  (
    MultiProvider //ChangeNotifierProvider로 감싸기
    (
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), //테마 프로바이더 생성
        ChangeNotifierProvider(create: (_) => UserProfileProvider()), //유저 프로필 프로바이더 생성
        ChangeNotifierProvider(create: (_) => FriendsProvider()), //친구 프로바이더 생성
        ChangeNotifierProvider(create: (_) => ChatProvider()), //채팅 프로바이더 생성
        ChangeNotifierProvider(create: (_) => FriendNicknameProvider()), //친구 닉네임 프로바이더 생성
        ChangeNotifierProvider(create: (_) => FriendRequestProvider()), //친구 요청 프로바이더 생성

        // Firestore 기반 프로바이더들 생성 (연동 예정)
        ChangeNotifierProvider(create: (_) => FirestoreFriendProvider()), // Firestore 친구 프로바이더 생성
        ChangeNotifierProvider(create: (_) => FirestoreUserProvider()), // Firestore 유저 프로바이더 생성
        ChangeNotifierProvider(create: (_) => FirestoreChatProvider()), // Firestore 채팅 프로바이더 생성
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
    return Builder
    (
      builder: (context) 
      {
        final themeProvider = context.watch<ThemeProvider>(); //테마 프로바이더 가져오기
        return MaterialApp
        (
          debugShowCheckedModeBanner: false, //우측 상단 디버그 배너 제거
          title: 'HANAS', //앱 제목
          theme: themeProvider.materialTheme, //현재 테마 적용
          initialRoute: '/splash', //초기 화면을 스플래시 화면으로 설정
          routes: //화면 라우트 설정
          {
            '/splash': (_) => const SplashScreen(), //스플래시 화면
            '/login': (_) => const LoginScreen(), //로그인 화면
            '/home': (_) => const HomeScreen(), //홈 화면
            '/friends': (_) => const FriendsScreen(), //친구 목록 화면
            '/chatList': (_) => const ChatListScreen(), //채팅 목록 화면
            '/chat': (_) => const ChatScreen(), //채팅 화면
            '/settings': (_) => const SettingsScreen(), //설정 화면
            '/profile': (_) => const ProfileScreen(), //프로필 화면
            '/theme': (_) => const ThemeSelectScreen(), //테마 선택 화면
            '/friendAdd': (_) => const FriendAddScreen(), //친구 추가 화면

            '/friendDetail': (context) //친구 상세 화면 라우트
            {
              final friend = ModalRoute.of(context)!.settings.arguments as Friend; //인자 가져오기
              return FriendDetailScreen //친구 상세 화면
              (
                friend: friend, //친구 인자
              );
            },
          },
        );
      }
    );
  }
}