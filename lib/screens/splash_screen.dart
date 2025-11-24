import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget
{
  const SplashScreen({super.key}); 

  @override
  State<SplashScreen> createState() => _SplashScreenState(); 
}

class _SplashScreenState extends State<SplashScreen>
  with SingleTickerProviderStateMixin
{
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState()
  {
    super.initState();

    //간단한 투명도 애니메이션
    _controller = AnimationController
    (
      vsync: this, 
      duration: const Duration(seconds: 1), //1초 동안 애니메이션
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller); //0에서 1로 변화

    _controller.forward(); //애니메이션 시작

    //1초 뒤 로그인 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () 
      {
        if (!mounted) return; //context 안전하게 보호, 위젯이 여전히 트리에서 마운트되어 있는지 확인
        Navigator.pushReplacementNamed(context , '/login'); //로그인 화면으로 이동
      });
    });
  }

  //리소스 해제
  @override
  void dispose()
  {
    _controller.dispose(); //애니메이션 컨트롤러 해제
    super.dispose(); //부모 클래스의 dispose 호출
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: const Color(0xFFFFDDEB), //연한 핑크색 배경
      body: Center //가운데 정렬
      (
        child: FadeTransition //페이드 애니메이션
        (
          opacity: _opacityAnimation, //투명도 애니메이션 적용
          child: Column //세로 정렬
          (
            mainAxisSize: MainAxisSize.min, //중앙에 모이도록 설정
            children:  //자식 위젯들
            [
              // 꽃 아이콘은 우선 emoji로 대체
              const Text
              (
                '🌸',
                style: TextStyle(fontSize: 60), //아이콘 크기
              ),
              const SizedBox(height: 20), //아이콘과 텍스트 사이 간격
              const Text //앱 이름 텍스트
              (
                'HANAS',
                style: TextStyle //텍스트 스타일
                (
                  fontSize: 32, //글자 크기
                  fontWeight: FontWeight.bold, //굵게
                  color: Colors.pinkAccent, //핑크색 글자
                ),
              ),
            ],
          )
        )
      )
    );
  }
}