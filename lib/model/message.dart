import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId, 
    required this.senderEmail, 
    required this.receiverId, 
    required this.message,
    required this.timestamp, 
    String? imageUrl,
  });

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

class GroupMessage {
  final String senderId;
  final String senderEmail;
  final String groupId; // Group ID for identifying the chat group
  final String message;
  final Timestamp timestamp;

  GroupMessage({
    required this.senderId,
    required this.senderEmail,
    required this.groupId,
    required this.message,
    required this.timestamp,
    String? imageUrl,
  });

  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'groupId': groupId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}