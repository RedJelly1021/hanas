import 'package:flutter/material.dart'; //플러터 머티리얼 디자인 패키지
import 'package:provider/provider.dart'; //프로바이더 패키지
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더

class SplashScreen extends StatefulWidget //스플래시 화면 클래스
{
  const SplashScreen({super.key}); //생성자

  @override
  State<SplashScreen> createState() => _SplashScreenState(); //스플래시 화면 상태 생성
}

class _SplashScreenState extends State<SplashScreen> //스플래시 화면 상태 클래스
  with SingleTickerProviderStateMixin //애니메이션을 위한 믹스인
{
  late AnimationController _controller; //애니메이션 컨트롤러
  late Animation<double> _opacityAnimation; //투명도 애니메이션
  late Animation<double> _scaleAnimation; //확대 애니메이션

  @override
  void initState() //초기화 메서드
  {
    super.initState(); //부모 클래스 초기화

    //간단한 투명도 애니메이션
    _controller = AnimationController //애니메이션 컨트롤러 초기화
    (
      vsync: this, //싱글 티커 프로바이더
      duration: const Duration(seconds: 2), //2초 동안 애니메이션
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller); //투명도 0에서 1로 변화
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.05).animate 
    (
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack) //부드러운 확대 애니메이션
    );

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
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    return Scaffold //기본 화면 구조
    (
      backgroundColor: theme.background, //연한 핑크색 배경
      body: Container //전체 컨테이너
      (
        decoration: BoxDecoration //배경 그라데이션
        (
          gradient: LinearGradient //선형 그라데이션
          (
            colors: //그라데이션 색상
            [
              theme.appBarGradientStart, //앱 바 그라데이션 시작 색상
              theme.appBarGradientEnd, //앱 바 그라데이션 끝 색상
            ],
            begin: Alignment.topCenter, //그라데이션 시작점
            end: Alignment.bottomCenter, //그라데이션 끝점
          ),
        ),
        child: Center //가운데 정렬
        (
          child: FadeTransition //페이드 애니메이션
          (
            opacity: _opacityAnimation, //투명도 애니메이션 적용
            child: ScaleTransition //확대 애니메이션
            (
              scale: _scaleAnimation, //확대 애니메이션 적용
              child: Column //세로 정렬
              (
                mainAxisSize: MainAxisSize.min, //중앙에 모이도록 설정
                children:  //자식 위젯들
                [
                  // 꽃 아이콘은 우선 emoji로 대체
                  Text
                  (
                    theme.flowerEmoji, //꽃 이모지
                    style: const TextStyle(fontSize: 80), //아이콘 크기
                  ),
                  const SizedBox(height: 20), //아이콘과 텍스트 사이 간격
                  Text //앱 이름 텍스트
                  (
                    'HANAS',
                    style: TextStyle //텍스트 스타일
                    (
                      fontSize: 36, //글자 크기
                      fontWeight: FontWeight.bold, //굵게
                      color: theme.foreground, //텍스트 색상
                      letterSpacing: 2, //글자 간격
                    ),
                  ),

                  const SizedBox(height: 8), //텍스트와 로딩 인디케이터 사이 간격

                  Text
                  (
                    '꽃처럼 피어나는 대화', //앱 슬로건
                    style: TextStyle //텍스트 스타일
                    (
                      color: theme.foreground.withOpacity(0.75), //연한 핑크색 텍스트
                      fontSize: 14, //글자 크기
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}