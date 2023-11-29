import 'package:capstone/components/chat_bubble.dart';
import 'package:capstone/components/my_text_field.dart';
import 'package:capstone/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatRoom extends StatefulWidget {
  final String receiverGroupId; // Changed to group ID
  final String receiverGroupName; // Optional: name of the group

  const GroupChatRoom({
    Key? key,
    required this.receiverGroupId,
    required this.receiverGroupName,
  }) : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessageToGroup() async {
    // Only send messages if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessageToGroup(
        widget.receiverGroupId, // Use the group ID
        _firebaseAuth.currentUser!.uid, // Sender's ID
        _messageController.text,
      );
      // Clear the text controller after sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverGroupName), // Display group name in the app bar
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // User input
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Build message list for the group
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getGroupMessages(widget.receiverGroupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final document = snapshot.data!.docs[index];
            return _buildMessageItem(document);
          },
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages accordingly
    var alignment = (data['senderId'] ==  _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

      return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: 
            (data['senderId'] ==  _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
            mainAxisAlignment: (data['senderId'] ==  _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,

            children: [
              Text(data['senderEmail']),
              const SizedBox(height: 5),
              ChatBubble(message: data['message']),
            ],
              ),
        )
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //send Image button
          IconButton(
            color: Colors.black,
            onPressed: () {},
            icon: const Icon(
              Icons.image,
              size: 20,
            )
          ),

          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter Message',
              obscureText: false,
            ),
          ),
    
          //send button
          IconButton(
            color: Colors.black,
            onPressed: sendMessageToGroup,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )
          ),

          //send location button
          IconButton(
            color: Colors.black,
            onPressed: () {},
            icon: const Icon(
              Icons.map_rounded,
              size: 40,
            )
          ),
        ],
      ),
    );
  }
}
