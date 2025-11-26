import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hanas/widgets/hanas_header.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:hanas/providers/favorite_provider.dart';
import 'package:hanas/providers/friend_nickname_provider.dart';

class FriendDetailScreen extends StatelessWidget
{
  final String name;
  final String emoji;

  const FriendDetailScreen
  ({
    super.key,
    required this.name,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context)
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final nicknameProvider = Provider.of<FriendNicknameProvider>(context);
    final displayName = nicknameProvider.displayName(name); // 표시용 이름 가져오기
    final currentNickname = nicknameProvider.getNickname(name); // 현재 별명 가져오기(있으면)
    final isFav = favoriteProvider.isFavorite(name);

    return Scaffold
    (
      backgroundColor: theme.background,
      body: Column
      (
        children:
        [
          HanasHeader
          (
            title: "친구 정보",
            onBack: () => Navigator.pop(context),
          ),

          const SizedBox(height: 30),

          //친구 프로필 이미지
          Text
          (
            emoji,
            style: const TextStyle(fontSize: 100),
          ),

          const SizedBox(height: 20),

          //친구 닉네임
          Text
          (
            displayName,
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.foreground,
            ),
          ),
          //별명 있으면 별명 표시
          if (currentNickname != null)
            const SizedBox(height: 4),
            //원래 이름
            Text
            (
              "친구가 저장한 이름: $name",
              style: TextStyle
              (
                fontSize: 12,
                color: theme.foreground.withOpacity(0.5),
              ),
            ),

          const SizedBox(height: 10),

          //상태 메시지
          Text
          (
            "Love you❤",
            style: TextStyle
            (
              fontSize: 14,
              color: theme.foreground.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 40),
          //즐겨찾기 토글 버튼
          Container
          (
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFav ? theme.primary : theme.cardColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.primary),
                ),
              ),
              onPressed: () {
                favoriteProvider.toggleFavorite(name);
              },
              child: Text(
                isFav ? "즐겨찾기 해제 🌙" : "즐겨찾기 추가 ⭐",
                style: TextStyle(
                  fontSize: 18,
                  color: isFav ? Colors.white : theme.primary,
                ),
              ),
            ),
          ),

          //별명 설정 버튼
          Container
          (
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: OutlinedButton
            (
              style: OutlinedButton.styleFrom
              (
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: theme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: theme.cardColor,
              ),
              onPressed: () async
              {
                final controller = TextEditingController(text: currentNickname ?? name);
                final result = await showDialog<String>
                (
                  context: context,
                  builder: (context)
                  {
                    return AlertDialog
                    (
                      title: const Text("별명 설정"),
                      content: TextField
                      (
                        controller: controller,
                        decoration: const InputDecoration
                        (
                          hintText: "이 친구를 뭐라고 부를까? 🌸",
                        ),
                      ),
                      actions:
                      [
                        TextButton
                        (
                          onPressed: () => Navigator.pop(context), 
                          child: const Text("취소")
                        ),
                        TextButton
                        (
                          onPressed: () => Navigator.pop(context, controller.text), 
                          child: const Text("저장")
                        ),
                      ],
                    );
                  },
                );
                if (result != null)
                {
                  nicknameProvider.setNickname(name, result);
                }
              },
              child: Text
              (
                currentNickname == null ? "별명 추가하기" : "별명 수정하기",
                style: TextStyle
                (
                  color: theme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          //채팅하기 버튼
          Container
          (
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton
            (
              style: ElevatedButton.styleFrom
              (
                backgroundColor: theme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: ()
              {
                Navigator.pushNamed
                (
                  context,
                  '/chat',
                  arguments: name,
                );
              },
              child: const Text
              (
                "채팅하기",
                style: TextStyle
                (
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}