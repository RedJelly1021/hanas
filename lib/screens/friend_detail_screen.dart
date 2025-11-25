import 'package:flutter/material.dart';
import 'package:hanas/providers/favorite_provider.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/hanas_header.dart';

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
            name,
            style: TextStyle
            (
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.foreground,
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