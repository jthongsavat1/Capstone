import 'dart:io';

import 'package:capstone/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send Message
  Future<void> sendMessage(String receiverId, String message, [String? imageUrl]) async {
    //get current user data
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      imageUrl: imageUrl,
      timestamp: timestamp,
    );

    //construct chat room if from current user if and receiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //to sort the ids
    String chatRoomId = ids.join(
      "_" //combines the ids into a single string to use as a chatroomId
    );

    //add new message to database
    await _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());
  }

  //Get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from user ids
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    
    return _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
   }


  Future<void> sendMessageToGroup(String groupId, String senderId, String message, [String? imageUrl]) async {
    try {
      final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

      GroupMessage newMessage = GroupMessage(
        senderId: senderId, // Use the provided senderId
        senderEmail: currentUserEmail, // Use the current user's email
        groupId: groupId,
        message: message,
        imageUrl: imageUrl,
        timestamp: timestamp,
      );

      await _firestore
          .collection('group_chat_rooms')
          .doc(groupId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (error) {
      print('Error sending group message: $error');
      // Handle the error as needed
    }
  }


  // Adjusted method for getting messages for a specific group
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection('group_chat_rooms')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

}