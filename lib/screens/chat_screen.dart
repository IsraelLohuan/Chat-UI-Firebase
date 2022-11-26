import 'package:chat_ui_firebase/models/message_model.dart';
import 'package:chat_ui_firebase/provider/chat_provider.dart';
import 'package:chat_ui_firebase/widgets/input_message_widget.dart';
import 'package:chat_ui_firebase/widgets/message_bubble_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({ Key? key }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatProvider chatProvider;
  late TextEditingController messageEditingController;
  late ScrollController scrollController;

  List<QueryDocumentSnapshot> messageList = [];

  @override 
  void initState() {
    super.initState();
    chatProvider = ChatProvider(firebaseFirestore: FirebaseFirestore.instance);
    messageEditingController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393f),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0XFF23272a),
        elevation: 1,
        title: const Text('My.chat', style: TextStyle(fontSize: 16),),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getMessageList(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  messageList = snapshot.data!.docs;

                  if(messageList.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: messageList.length,
                      reverse: true,
                      controller: scrollController,
                      itemBuilder: (context, index) => _buildItem(index, messageList[index]),
                    );  
                  } 

                  return const Center(
                    child: Text(
                      'Sem mensagens...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ),
          InputMessageWidget(
            messageEditingController: messageEditingController, 
            handleSubmit: sendMessage
          )
        ],
      ),
    );
  }

  void sendMessage(String message) {
    if(message.isNotEmpty) {
      messageEditingController.clear();
      chatProvider.sendMessage(message.trim(), currentUser());
      scrollController.animateTo(
        0, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeOut
      );
    }
  }

  String currentUser() => ModalRoute.of(context)?.settings.arguments as String;

  _buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if(documentSnapshot != null) {
      final chatMessage = MessageModel.fromDocument(documentSnapshot);
      final isMe = chatMessage.author == currentUser();

      return MessageBubbleWidget(chatMessage: chatMessage, isMe: isMe);
    }
  }
}