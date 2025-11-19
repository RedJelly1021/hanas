// chat.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key}); // const + super.key

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');

    void sendMessage() {
      if (messageController.text.isEmpty) return;
      messages.add({
        'text': messageController.text,
        'sender': FirebaseAuth.instance.currentUser!.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messages.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['text'] ?? ''),
                      subtitle: Text(data['sender'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
