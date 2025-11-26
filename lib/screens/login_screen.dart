import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:hanas/providers/user_profile_provider.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState(); //로그인 화면 상태 생성
}

class _LoginScreenState extends State<LoginScreen>
{
  final TextEditingController _nameController = TextEditingController(); //닉네임 입력 컨트롤러

  @override
  void dispose() //리소스 해제
  {
    _nameController.dispose(); //컨트롤러 해제
    super.dispose(); //부모 클래스의 dispose 호출
  }

  void _login() //로그인 처리 메서드
  {
    final name = _nameController.text.trim(); //닉네임 가져오기

    if (name.isEmpty) //닉네임이 비어있는 경우
    {
      ScaffoldMessenger.of(context).showSnackBar //Snackbar 표시
      (
        const SnackBar //Snackbar 위젯
        (
          content: Text('닉네임을 입력하세요!'), //경고 메시지
          duration: Duration(seconds: 1), //1초 동안 표시
        )
      );
      return;
    }

    //닉네임을 전역 프로필 상태에 반영
    final profile = Provider.of<UserProfileProvider>(context, listen: false); //프로필 프로바이더 가져오기
    profile.setNickname(name); //닉네임 설정

    //TODO: 실제 로그인 로직은 나중에 Firebase 붙일 때 넣기
    Navigator.pushReplacementNamed(context, '/friends'); //친구 목록 화면으로 이동
    //Navigator.pushReplacementNamed(context, '/chatList'); //원하면 로그인 성공 시 채팅 목록 화면으로 이동
    //Navigator.pushReplacementNamed(context, '/home'); //원하면 로그인 성공 시 Home(Friends+Chats) 화면으로 이동
  }

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기

    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //연한 핑크색 배경
      body: Padding //전체 패딩
      (
        padding: const EdgeInsets.all(24.0), //모든 방향에 24픽셀 패딩
        child: Center //가운데 정렬
        (
          child: Column //세로 정렬
          (
            mainAxisSize: MainAxisSize.min, //중앙에 모이도록 설정
            children:  //위젯들
            [
              Text //앱 로고
              (
                theme.flowerEmoji, //꽃 이모지
                style: const TextStyle(fontSize: 70), //앱 로고 크기
              ),
              const SizedBox(height: 20), //로고와 입력창 사이 간격
              Text //로그인 제목
              (
                'HANAS 로그인',
                style: TextStyle //텍스트 스타일
                (
                  fontSize: 28, //폰트 크기
                  fontWeight: FontWeight.bold, //굵게
                  color: theme.foreground, //텍스트 색상
                ),
              ),
              const SizedBox(height: 40), //제목과 입력창 사이 간격

              //닉네임 입력 필드
              TextField //닉네임 입력창
              (
                controller: _nameController, //컨트롤러 연결
                decoration: InputDecoration //입력창 꾸미기
                (
                  labelText: '닉네임', //레이블 텍스트
                  filled: true, //채워진 스타일
                  fillColor: theme.cardColor, //카드 배경색
                  labelStyle: TextStyle(color: theme.foreground), //레이블 색상
                  enabledBorder: OutlineInputBorder //기본 테두리
                  (
                    borderRadius: BorderRadius.circular(12), //둥근 모서리
                    borderSide: BorderSide(color: theme.borderColor), //테두리 색상
                  ),
                  focusedBorder: OutlineInputBorder //포커스된 테두리
                  (
                    borderRadius: BorderRadius.circular(12), //둥근 모서리
                    borderSide: BorderSide(color: theme.accent, width: 2), //강조 색상 테두리
                  ),
                ),
              ),

              const SizedBox(height: 30), //입력창과 버튼 사이 간격
              
              //로그인 버튼
              SizedBox //가로 꽉 찬 버튼
              (
                width: double.infinity, //가로 최대 크기
                child: ElevatedButton //로그인 버튼
                (
                  onPressed: _login, //로그인 처리 메서드 연결
                  style: ElevatedButton.styleFrom //버튼 스타일
                  (
                    backgroundColor: theme.primary, //핑크색 배경
                    padding: const EdgeInsets.symmetric(vertical: 14), //세로 패딩
                    shadowColor: theme.shadowColor, //그림자 색상
                    shape: RoundedRectangleBorder //둥근 모서리
                    (
                      borderRadius: BorderRadius.circular(12), //모서리 반경 12
                    ),
                  ),
                  child: Text //버튼 텍스트
                  (
                    '입장하기', //버튼 텍스트
                    style: TextStyle(fontSize: 18, color: theme.bubbleOther), //폰트 크기 및 색상
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}