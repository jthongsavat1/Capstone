import 'package:capstone/services/chat/groupchat/groupchatroom.dart';
import 'package:capstone/pages/messagepage.dart';
import 'package:capstone/services/chat/searchscreenchat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:capstone/main.dart';

class ChatPage extends StatefulWidget{
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreenChat()),
              );
            },
            icon: const Icon(Icons.search),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Individual Chats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
          const Divider(), // Add a divider between individual chats and group chats
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Group Chats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _buildGroupChats(),
          ),
        ],
      ),
    );
  }


  //build a list of users expect for the current user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
          .map<Widget>((doc) => _buildUserListItem(doc))
          .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all the users except the current
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['username']),
        leading: const Icon(Icons.account_box, color: Colors.black),
        subtitle: Text(data['email']),
        trailing: const Icon(Icons.chat, color: Colors.black,),
        onTap: () {
          //pass the clicked users UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagePage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }


  // Build the list of group chats
  Widget _buildGroupChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('groups')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        final groups = snapshot.data!.docs;

        if (groups.isEmpty) {
          return const Center(
            child: Text('No Groups Available'),
          );
        }

        final userGroups = groups.where((group) => (group['members'] as List).contains(_auth.currentUser!.email));

        if (userGroups.isEmpty) {
          return const Center(
            child: Text('You are not part of any groups'),
          );
        }

        return ListView.builder(
          itemCount: userGroups.length,
          itemBuilder: (context, index) {
            final group = userGroups.elementAt(index);
            final groupId = group.id;
            final groupName = group['groupName']; // Replace with your group name field

            return ListTile(
              title: Text(groupName),
              leading: const Icon(Icons.group, color: Colors.black),
              trailing: const Icon(Icons.message,color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatRoom(
                      receiverGroupId: groupId, 
                      receiverGroupName: groupName,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


}
