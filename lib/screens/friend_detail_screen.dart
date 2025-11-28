import 'package:flutter/material.dart'; // Flutter 기본 위젯 패키지
import 'package:provider/provider.dart'; // 프로바이더 패키지
import 'package:hanas/widgets/hanas_header.dart'; // 하나스 헤더 위젯
import 'package:hanas/models/friend.dart'; // 친구 모델
import 'package:hanas/providers/theme_provider.dart'; // 테마 프로바이더
import 'package:hanas/providers/favorite_provider.dart'; // 즐겨찾기 프로바이더
import 'package:hanas/providers/friend_nickname_provider.dart'; // 친구 별명 프로바이더
import 'package:hanas/providers/friend_request_provider.dart' hide Friend; // 친구 요청 프로바이더

class FriendDetailScreen extends StatelessWidget // 친구 상세 정보 화면
{
  final Friend friend; // 친구 모델

  const FriendDetailScreen // 생성자
  ({
    super.key, // 키
    required this.friend, // 친구 모델 필수
  });

  @override
  Widget build(BuildContext context) // 빌드 메서드
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme; // 현재 테마 가져오기
    final favoriteProvider = Provider.of<FavoriteProvider>(context); // 즐겨찾기 프로바이더 가져오기
    final nicknameProvider = Provider.of<FriendNicknameProvider>(context); // 친구 별명 프로바이더 가져오기
    final friendRequestProvider = Provider.of<FriendRequestProvider>(context); // 친구 요청 프로바이더 가져오기

    final displayName = nicknameProvider.displayName(friend.name); // 표시용 이름 가져오기
    final currentNickname = nicknameProvider.getNickname(friend.name); // 현재 별명 가져오기(있으면)
    final isFav = favoriteProvider.isFavorite(friend.name); // 즐겨찾기 여부 확인

    return Scaffold // 스캐폴드 위젯
    (
      backgroundColor: theme.background, // 배경색 설정
      body: Column // 세로로 정렬
      (
        children: // 자식 위젯들
        [
          HanasHeader // 하나스 헤더
          (
            title: Row // 제목을 아이콘과 텍스트로 구성
            (
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: // 자식 위젯들
              [
                Text // 텍스트 위젯
                (
                  "친구 정보", // 제목 텍스트
                  style: TextStyle // 텍스트 스타일
                  (
                    fontSize: 20, // 폰트 크기
                    fontWeight: FontWeight.bold, // 폰트 두께
                    color: theme.foreground, // 폰트 색상
                  ),
                ),
              ],
            ),
            onBack: () => Navigator.pop(context), // 뒤로가기 동작
          ),

          const SizedBox(height: 30), // 간격

          //친구 프로필 이미지
          Text
          (
            friend.emoji, // 친구 이모지
            style: const TextStyle(fontSize: 100), // 폰트 크기
          ),

          const SizedBox(height: 20), // 간격

          //친구 닉네임
          Text
          (
            displayName, // 표시용 이름
            style: TextStyle // 텍스트 스타일
            (
              fontSize: 28, // 폰트 크기
              fontWeight: FontWeight.bold, // 폰트 두께
              color: theme.foreground, // 폰트 색상
            ),
          ),
          //별명 있으면 별명 표시
          if (currentNickname != null) ...[
            const SizedBox(height: 4), // 간격
            //원래 이름
            Text
            (
              "친구가 저장한 이름: ${friend.name}", // 원래 이름 텍스트
              style: TextStyle // 텍스트 스타일
              (
                fontSize: 12, // 폰트 크기
                color: theme.foreground.withOpacity(0.5), // 폰트 색상 (반투명)
              ),
            ),
          ],

          const SizedBox(height: 10), // 간격

          //상태 메시지
          Text // 상태 메시지 위젯
          (
            "Love you❤", // 상태 메시지
            style: TextStyle // 텍스트 스타일
            (
              fontSize: 14, // 폰트 크기
              color: theme.foreground.withOpacity(0.6), // 폰트 색상 (반투명)
            ),
          ),

          const SizedBox(height: 40), // 간격
          //즐겨찾기 토글 버튼
          Container // 컨테이너 위젯
          (
            width: double.infinity, // 가로 최대 크기
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // 여백 설정
            child: ElevatedButton // 상승 버튼
            (
              style: ElevatedButton.styleFrom // 버튼 스타일
              (
                backgroundColor: isFav ? theme.primary : theme.cardColor, // 배경색 설정
                padding: const EdgeInsets.symmetric(vertical: 14), // 패딩 설정
                shape: RoundedRectangleBorder // 모서리 모양 설정
                (
                  borderRadius: BorderRadius.circular(12),// 모서리 둥글게
                  side: BorderSide(color: theme.primary), // 테두리 색상
                ),
              ),
              onPressed: () { // 버튼 클릭 시
                favoriteProvider.toggleFavorite(friend.name); // 즐겨찾기 토글
              },
              child: Text // 버튼 텍스트
              (
                isFav ? "즐겨찾기 해제" : "즐겨찾기 추가 ⭐", // 텍스트 설정
                style: TextStyle // 텍스트 스타일
                (
                  fontSize: 18, // 폰트 크기
                  color: isFav ? Colors.white : theme.primary, // 폰트 색상 설정
                ),
              ),
            ),
          ),

          //별명 설정 버튼
          Container
          (
            width: double.infinity, // 가로 최대 크기
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // 여백 설정
            child: OutlinedButton // 외곽선 버튼
            (
              style: OutlinedButton.styleFrom // 버튼 스타일
              (
                padding: const EdgeInsets.symmetric(vertical: 12), // 패딩 설정
                side: BorderSide(color: theme.primary), // 테두리 색상
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // 모서리 둥글게
                backgroundColor: theme.cardColor, // 배경색 설정
              ),
              onPressed: () async // 버튼 클릭 시
              {
                final controller = TextEditingController(text: currentNickname ?? friend.name); // 텍스트 컨트롤러 초기화
                final result = await showDialog<String> // 다이얼로그 표시
                (
                  context: context, // 컨텍스트
                  builder: (context) // 빌더 함수
                  {
                    return AlertDialog // 알림 대화상자
                    (
                      title: const Text("별명 설정"), // 제목
                      content: TextField // 텍스트 필드
                      (
                        controller: controller, // 컨트롤러 설정
                        decoration: const InputDecoration // 입력 장식
                        (
                          hintText: "이 친구를 뭐라고 부를까? 🌸", // 힌트 텍스트
                        ),
                      ),
                      actions: // 액션 버튼들
                      [
                        TextButton // 텍스트 버튼
                        (
                          onPressed: () => Navigator.pop(context),  // 취소 동작
                          child: const Text("취소") // 버튼 텍스트
                        ),
                        TextButton // 텍스트 버튼
                        (
                          onPressed: () => Navigator.pop(context, controller.text), // 저장 동작
                          child: const Text("저장") // 버튼 텍스트
                        ),
                      ],
                    );
                  },
                );
                if (result != null) // 결과가 있으면
                {
                  nicknameProvider.setNickname(friend.name, result); // 별명 설정
                }
              },
              child: Text // 버튼 텍스트
              (
                currentNickname == null ? "별명 추가하기" : "별명 수정하기", // 텍스트 설정
                style: TextStyle // 텍스트 스타일
                (
                  color: theme.primary, // 폰트 색상 설정
                  fontSize: 16, // 폰트 크기 설정
                ),
              ),
            ),
          ),

          //채팅하기 버튼
          Container
          (
            width: double.infinity, // 가로 최대 크기
            margin: const EdgeInsets.symmetric(horizontal: 20), // 여백 설정
            child: ElevatedButton // 상승 버튼
            (
              style: ElevatedButton.styleFrom // 버튼 스타일
              (
                backgroundColor: theme.primary, // 배경색 설정
                padding: const EdgeInsets.symmetric(vertical: 14), // 패딩 설정
                shape: RoundedRectangleBorder // 모서리 모양 설정
                (
                  borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                ),
              ),
              onPressed: () // 버튼 클릭 시
              {
                Navigator.pushNamed // 채팅 화면으로 이동
                (
                  context, // 컨텍스트
                  '/chat', // 경로
                  arguments: 
                  {
                    'name': friend.name, // 친구 이름 전달
                    'emoji': friend.emoji, // 친구 이모지 전달
                  },
                );
              },
              child: const Text // 버튼 텍스트
              (
                "채팅하기", // 텍스트 설정
                style: TextStyle // 텍스트 스타일
                (
                  fontSize: 18, // 폰트 크기
                  fontWeight: FontWeight.bold, // 폰트 두께
                  color: Colors.white, // 폰트 색상
                ),
              ),
            ),
          ),

          const SizedBox(height: 24), // 간격

          // 친구 삭제 버튼
          Container
          (
            width: double.infinity, // 가로 최대 크기
            margin: const EdgeInsets.symmetric(horizontal: 20), // 여백 설정
            child: OutlinedButton // 외곽선 버튼
            (
              style: OutlinedButton.styleFrom // 버튼 스타일
              (
                padding: const EdgeInsets.symmetric(vertical: 12), // 패딩 설정
                side: const BorderSide(color: Colors.redAccent), // 테두리 색상
                shape: RoundedRectangleBorder // 모서리 모양 설정
                (
                  borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                ),
              ),
              onPressed: ()
              {
                showDialog
                (
                  context: context, // 컨텍스트
                  builder: (context) // 빌더 함수
                  {
                    return AlertDialog // 알림 대화상자
                    (
                      title: const Text("정말 친구를 삭제할까요?"), // 제목
                      content: Text
                      (
                        "$displayName 님을 친구 목록에서 삭제합니다.",
                      ), // 내용
                      actions: // 액션 버튼들
                      [
                        TextButton // 텍스트 버튼
                        (
                          onPressed: () => Navigator.pop(context), // 취소 동작
                          child: const Text("취소") // 버튼 텍스트
                        ),
                        TextButton // 텍스트 버튼
                        (
                          onPressed: () // 삭제 동작
                          {
                            Navigator.pop(context);
                            friendRequestProvider.removeFriend(friend.name); // 친구 삭제
                            Navigator.pop(context); // 이전 화면으로 돌아가기

                            ScaffoldMessenger.of(context).showSnackBar // 스낵바 표시
                            (
                              SnackBar // 스낵바 위젯
                              (
                                content: Text("$displayName 님이 친구 목록에서 삭제되었습니다."), // 스낵바 내용
                              ),
                            );
                          },
                          child: const Text
                          (
                            "삭제", // 버튼 텍스트
                            style: TextStyle(color: Colors.redAccent), // 텍스트 스타일
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text // 버튼 텍스트
              (
                "친구 삭제", // 텍스트 설정
                style: TextStyle // 텍스트 스타일
                (
                  color: Colors.redAccent, // 폰트 색상 설정
                  fontSize: 16, // 폰트 크기 설정
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}