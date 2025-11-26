import 'package:flutter/material.dart'; //Flutter 머티리얼 패키지 임포트
import 'package:hanas/providers/theme_provider.dart'; //테마 프로바이더 임포트
import 'package:hanas/widgets/hanas_header.dart'; //헤더 위젯 임포트
import 'package:provider/provider.dart'; //프로바이더 패키지 임포트

class SettingsScreen extends StatelessWidget //설정 화면 클래스
{
  const SettingsScreen({super.key}); //생성자

  @override
  Widget build(BuildContext context) //빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; //현재 테마 가져오기
    return Scaffold //기본 화면 구조
    (
      body: Column
      (
        children: 
        [
          //헤더 영역
          HanasHeader
          (
            title: Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                Icon(Icons.settings_outlined, color: theme.accent, size: 20),
                const SizedBox(width: 8),
                Text
                (
                  "설정", //헤더 제목
                  style: TextStyle
                  (
                    fontSize: 20, //폰트 크기
                    fontWeight: FontWeight.bold, //굵게
                    color: theme.foreground, //글자 색상
                  ),
                ),
              ],
            ),
            onBack: () => Navigator.pop(context), //뒤로가기 콜백
          ),
          //설정 항목 영역
          Expanded
          (
            child: ListView //설정 항목 리스트뷰
            (
              padding: const EdgeInsets.only(top: 16), //상단 패딩
              children: //위젯들
              [
                //section 1 : my account
                _buildSectionTitle("내 정보", theme), //섹션 제목
                _buildMenuItem //메뉴 아이템
                (
                  icon: Icons.person, //사람 아이콘
                  label: "프로필 보기", //레이블
                  color: theme.foreground, //테마 색상
                  trailingColor: theme.primary, //오른쪽 아이콘 색상
                  onTap: () => 
                    Navigator.pushNamed(context, "/profile"),
                ),
                
                //section 2 : themes
                _buildSectionTitle("테마", theme), //섹션 제목
                _buildMenuItem //메뉴 아이템
                (
                  icon: Icons.color_lens, //팔레트 아이콘
                  label: "테마 변경", //레이블
                  color: theme.foreground, //테마 색상
                  trailingColor: theme.primary, //오른쪽 아이콘 색상
                  onTap: () =>//탭했을 때
                    Navigator.pushNamed(context, '/theme'), //테마 선택 화면으로 이동
                ),
                
                //section 3 : notifications
                _buildSectionTitle("알림", theme), //섹션 제목
                SwitchListTile //푸시 알림 스위치
                (
                  title: Text //레이블
                  (
                    "푸시 알림", //레이블 텍스트
                    style: TextStyle(color: theme.foreground, fontSize: 16), //핑크색 텍스트
                  ),
                  value: true, //스위치 상태 (기본값 켜짐)
                  onChanged: (v) //스위치 변경 시
                  {
                    //TODO :이후 기능 구현
                  },
                  activeColor: theme.primary, //활성화 색상
                ),

                //section 4 : app info
                _buildSectionTitle("HANAS", theme), //섹션 제목
                _buildMenuItem //메뉴 아이템
                (
                  icon: Icons.info_outline, //정보 아이콘
                  label: "앱 정보", //레이블
                  color: theme.foreground, //테마 색상
                  trailingColor: theme.primary, //오른쪽 아이콘 색상
                  onTap: () //탭했을 때
                  {
                    showAboutDialog //앱 정보 다이얼로그 표시
                    (
                      context: context, //빌드 컨텍스트
                      applicationName: "HANAS", //앱 이름
                      applicationVersion: "v0.1.0", //앱 버전
                      applicationIcon: const Text("🌸", style: TextStyle(fontSize: 32)), //앱 아이콘
                      children: const //추가 정보
                      [
                        Text("귀엽고 깔끔한 감성 채팅앱, HANAS 🌸"), //설명 텍스트
                      ],
                    );
                  }, 
                ),

                const SizedBox(height: 20), //간격

                //logout (firebase auth 연동 후)
                _buildMenuItem //메뉴 아이템
                (
                  icon: Icons.logout, //아이콘
                  label: "로그아웃", //레이블
                  color: Colors.redAccent, //색상
                  trailingColor: Colors.redAccent, //오른쪽 아이콘 색상
                  onTap: () => //탭했을 때
                    //TODO : 이후 기능 구현
                    _snack(context, "로그아웃 기능은 준비 중!"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //section title widget
  Widget _buildSectionTitle(String title, dynamic theme) //섹션 제목 빌드 메서드
  {
    return Padding //패딩 위젯
    (
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), //수평 20, 수직 8 패딩
      child: Text //텍스트 위젯
      (
        title, //섹션 제목 텍스트
        style: TextStyle //텍스트 스타일
        (
          color: theme.primary, //핑크색 텍스트
          fontWeight: FontWeight.bold, //굵게
          fontSize: 17, //폰트 크기
        ),
      ),
    );
  }

  //menu item widget
  Widget _buildMenuItem //메뉴 아이템 빌드 메서드
  ({
    required IconData icon, //아이콘
    required String label, //레이블
    required VoidCallback onTap, //탭 콜백
    required Color color, //색상
    required Color trailingColor, //오른쪽 아이콘 색상
  })
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), //외부 여백
      decoration: BoxDecoration //박스 장식
      (
        color: Colors.white.withOpacity(0.95), //반투명 흰색 배경
        borderRadius: BorderRadius.circular(14), //둥근 모서리
        border: Border.all
        (
          color: color.withOpacity(0.2), //테두리 색상
        ),
        boxShadow: //박스 그림자
        [
          BoxShadow //그림자
          (
            color: color.withOpacity(0.15), //그림자 색상
            blurRadius: 6, //흐림 반경
            offset: const Offset(0, 3), //그림자 위치
          ),
        ],
      ),
      child: ListTile //리스트 타일 위젯
      (
        leading: Icon(icon, color: color), //아이콘
        title: Text //텍스트 위젯
        (
          label, //레이블 텍스트
          style: TextStyle //텍스트 스타일
          (
            color: color, //텍스트 색상
            fontSize: 16, //폰트 크기
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: trailingColor), //오른쪽 화살표 아이콘
        onTap: onTap, //탭 콜백
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}