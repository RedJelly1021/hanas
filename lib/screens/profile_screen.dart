import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hanas/widgets/hanas_header.dart';
import 'package:hanas/providers/theme_provider.dart';
import 'package:hanas/providers/user_profile_provider.dart';

class ProfileScreen extends StatelessWidget
{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final profile = Provider.of<UserProfileProvider>(context);

    return Scaffold
    (
      backgroundColor: theme.background,
      body: Column
      (
        children:
        [
          HanasHeader
          (
            title: "내 프로필",
            onBack: () => Navigator.pop(context),
          ),
          
          const SizedBox(height: 20),

          //프로필 꽃
          Text
          (
            theme.flowerEmoji,
            style: TextStyle(fontSize: 90),
          ),

          const SizedBox(height: 16),

          //닉네임
          Text
          (
            profile.nickname,
            style: TextStyle
            (
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: theme.foreground,
            ),
          ),

          const SizedBox(height: 8),
          //상태 메시지
          Row
          (
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              Flexible
              (
                child: Text
                (
                  profile.statusMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle
                  (
                    fontSize: 14,
                    color: theme.foreground.withOpacity(0.6),
                  ),
                ),
              ),
              IconButton
              (
                icon: Icon(Icons.edit, size: 18, color: theme.primary),
                onPressed: () async
                {
                  final controller = TextEditingController(text: profile.statusMessage);
                  final newText = await showDialog<String>
                  (
                    context: context,
                    builder: (context) 
                    {
                      return AlertDialog
                      (
                        title: const Text("상태 메시지 수정"),
                        content: TextField
                        (
                          controller: controller,
                          maxLines: 2,
                          decoration: const InputDecoration
                          (
                            hintText: "지금 내 마음을 적어보자 🌸" ,
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
                  if (newText != null) 
                  {
                    profile.setStatusMessage(newText);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          //테마 정보 카드
          Container
          (
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration
            (
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all
              (
                color: theme.borderColor.withOpacity(0.7),
                width: 1.2,
              ),
              boxShadow:
              [
                BoxShadow
                (
                  color: theme.shadowColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row
            (
              children:
              [
                Text
                (
                  theme.flowerEmoji,
                  style: const TextStyle(fontSize: 42),
                ),
                const SizedBox(width: 20),
                Column
                (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Text
                    (
                      theme.name,
                      style: TextStyle
                      (
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text
                    (
                      "현재 적용 중인 테마",
                      style: TextStyle
                      (
                        fontSize: 13,
                        color: theme.foreground.withOpacity(0.6),
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