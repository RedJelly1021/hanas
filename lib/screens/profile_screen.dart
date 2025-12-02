import 'package:flutter/material.dart'; // Flutter 기본 패키지
import 'package:provider/provider.dart'; // 상태 관리를 위한 Provider 패키지
import 'package:hanas/widgets/hanas_header.dart'; // 커스텀 헤더 위젯
import 'package:hanas/providers/theme_provider.dart'; // 테마 관련 프로바이더
import 'package:hanas/providers/user_profile_provider.dart'; // 사용자 프로필 관련 프로바이더
import 'package:hanas/providers/firestore_user_provider.dart'; // Firestore 유저 프로바이더

class ProfileScreen extends StatelessWidget // 프로필 화면 위젯
{
  const ProfileScreen({super.key}); //생성자

  @override
  Widget build(BuildContext context) // 빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; // 현재 테마 가져오기
    final profile = Provider.of<UserProfileProvider>(context); // 사용자 프로필 가져오기

    return Scaffold // 기본 화면 구조
    (
      backgroundColor: theme.background, // 배경 색상 설정
      body: Column // 세로 레이아웃
      (
        children: // 자식 위젯들
        [
          HanasHeader // 커스텀 헤더 위젯
          (
            title: Row // 헤더 제목 영역
            (
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: // 자식 위젯들
              [
                Text // 헤더 텍스트
                (
                "내 프로필", // "My Profile" 텍스트
                  style: TextStyle // 텍스트 스타일
                  (
                    fontSize: 20, // 폰트 크기
                    fontWeight: FontWeight.bold, // 폰트 굵기
                    color: theme.foreground, // 폰트 색상
                  ),
                ),
              ],
            ),
            onBack: () => Navigator.pop(context), // 뒤로 가기 동작
          ),
          
          const SizedBox(height: 20), // 상단 여백

          //프로필 꽃
          Text
          (
            theme.flowerEmoji, // 꽃 이모지
            style: TextStyle(fontSize: 90), // 이모지 크기
          ),

          const SizedBox(height: 16), // 여백

          //닉네임
          Row // 가로 레이아웃
          (
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            children: // 자식 위젯들
            [
              Text // 닉네임 텍스트
              (
                profile.nickname, // 사용자 닉네임
                style: TextStyle // 텍스트 스타일
                (
                  fontSize: 26, // 폰트 크기
                  fontWeight: FontWeight.bold, // 폰트 굵기
                  color: theme.foreground, // 폰트 색상
                ),
              ),
              const SizedBox(width: 6), // 여백

              //닉네임 편집 버튼
              IconButton
              (
                icon: Icon
                (
                  Icons.edit, // 편집 아이콘
                  size: 20, // 아이콘 크기
                  color: theme.primary, // 아이콘 색상
                ),
                onPressed: () async
                {
                  final controller = TextEditingController(text: profile.nickname); // 텍스트 컨트롤러 초기화
                  final newNickname = await showDialog<String> // 다이얼로그 표시
                  (
                    context: context, // 현재 컨텍스트
                    builder: (context) => AlertDialog
                    (
                      title: const Text("닉네임 수정"), // 제목
                      content: TextField // 텍스트 입력 필드
                      (
                        controller: controller, // 컨트롤러 설정
                        maxLength: 20, // 최대 글자 수
                        decoration: const InputDecoration // 입력 장식
                        (
                          hintText: "새 닉네임을 입력하세요" , // 힌트 텍스트
                        ),
                      ),
                      actions: // 다이얼로그 액션 버튼들
                      [
                        TextButton // 취소 버튼
                        (
                          onPressed: () => Navigator.pop(context), // 다이얼로그 닫기
                          child: const Text("취소") // "Cancel" 텍스트
                        ),
                        TextButton // 저장 버튼
                        (
                          onPressed: () => Navigator.pop(context, controller.text.trim()), // 다이얼로그 닫기 (저장)
                          child: const Text("저장") // "Save" 텍스트
                        ),
                      ],
                    ),
                  );

                  if (newNickname != null && newNickname.isNotEmpty) // 새 닉네임이 유효하면
                  {
                    profile.setNickname(newNickname); // 닉네임 업데이트

                    // Firestore에도 저장
                    final firestoreUser = context.read<FirestoreUserProvider>(); // Firestore 유저 프로바이더 가져오기
                    await firestoreUser.saveUser(profile); // Firestore에 사용자 데이터 저장
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 8), // 여백
          //상태 메시지
          Row
          (
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            children: // 자식 위젯들
            [
              Flexible // 유연한 공간 차지
              (
                child: Text // 상태 메시지 텍스트
                (
                  profile.statusMessage, // 사용자 상태 메시지
                  textAlign: TextAlign.center, // 중앙 정렬
                  style: TextStyle // 텍스트 스타일
                  (
                    fontSize: 14, // 폰트 크기
                    color: theme.foreground.withOpacity(0.6), // 폰트 색상 (투명도 적용)
                  ),
                ),
              ),
              IconButton // 편집 버튼
              (
                icon: Icon(Icons.edit, size: 18, color: theme.primary), // 편집 아이콘
                onPressed: () async // 버튼 클릭 시 동작
                {
                  final controller = TextEditingController(text: profile.statusMessage); // 텍스트 컨트롤러 초기화
                  final newText = await showDialog<String> // 다이얼로그 표시
                  (
                    context: context, // 현재 컨텍스트
                    builder: (context) // 다이얼로그 빌더
                    {
                      return AlertDialog // 알림 대화상자
                      (
                        title: const Text("상태 메시지 수정"), // 제목
                        content: TextField // 텍스트 입력 필드
                        (
                          controller: controller, // 컨트롤러 설정
                          maxLines: 2, // 최대 2줄
                          decoration: const InputDecoration // 입력 장식
                          (
                            hintText: "지금 내 마음을 적어보자 🌸" , // 힌트 텍스트
                          ),
                        ),
                        actions: // 다이얼로그 액션 버튼들
                        [
                          TextButton // 취소 버튼
                          (
                            onPressed: () => Navigator.pop(context), // 다이얼로그 닫기
                            child: const Text("취소") // "Cancel" 텍스트
                          ),
                          TextButton // 저장 버튼
                          (
                            onPressed: () => Navigator.pop(context, controller.text), // 다이얼로그 닫기 (저장)
                            child: const Text("저장") // "Save" 텍스트
                          ),
                        ],
                      );
                    },
                  );
                  if (newText != null) // 새 텍스트가 null이 아니면
                  {
                    profile.setStatusMessage(newText); // 상태 메시지 업데이트

                    // Firestore에도 저장
                    final firestoreUser = context.read<FirestoreUserProvider>(); // Firestore 유저 프로바이더 가져오기
                    await firestoreUser.saveUser(profile); // Firestore에 사용자 데이터 저장
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 30), // 여백

          //테마 정보 카드
          Container
          (
            margin: const EdgeInsets.symmetric(horizontal: 20), // 좌우 여백
            padding: const EdgeInsets.all(20), // 내부 여백
            decoration: BoxDecoration // 박스 장식
            (
              color: theme.cardColor, // 카드 배경 색상
              borderRadius: BorderRadius.circular(16), // 둥근 모서리
              border: Border.all // 테두리
              (
                color: theme.borderColor.withOpacity(0.7), // 테두리 색상
                width: 1.2, // 테두리 두께
              ),
              boxShadow: // 그림자
              [
                BoxShadow // 그림자 효과
                (
                  color: theme.shadowColor.withOpacity(0.3), // 그림자 색상
                  blurRadius: 6, // 흐림 반경
                  offset: const Offset(0, 2), // 그림자 위치
                ),
              ],
            ),
            child: Row // 가로 레이아웃
            (
              children: // 자식 위젯들
              [
                Text // 테마 꽃 이모지
                (
                  theme.flowerEmoji, // 꽃 이모지
                  style: const TextStyle(fontSize: 42), // 이모지 크기
                ),
                const SizedBox(width: 20), // 가로 여백
                Column // 세로 레이아웃
                (
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                  children: // 자식 위젯들
                  [
                    Text // 테마 이름 텍스트
                    (
                      theme.name, // 테마 이름
                      style: TextStyle // 텍스트 스타일
                      (
                        fontSize: 18, // 폰트 크기
                        fontWeight: FontWeight.bold, // 폰트 두께
                        color: theme.foreground, // 텍스트 색상
                      ),
                    ),
                    const SizedBox(height: 4), // 세로 여백
                    Text // 현재 적용 중인 테마 텍스트
                    (
                      "현재 적용 중인 테마", // "Currently applied theme" 텍스트
                      style: TextStyle // 텍스트 스타일
                      (
                        fontSize: 13, // 폰트 크기
                        color: theme.foreground.withOpacity(0.6), // 텍스트 색상 (투명도 0.6)
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}