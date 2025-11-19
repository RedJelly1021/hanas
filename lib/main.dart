import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // super.key 사용

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HANAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Material 3 스타일 사용
      ),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: const LoginScreen(),
    );
  }
}
