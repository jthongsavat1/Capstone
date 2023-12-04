import 'dart:io';
import 'package:capstone/components/chat_bubble.dart';
import 'package:capstone/components/my_text_field.dart';
import 'package:capstone/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagePage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const MessagePage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Function to send user's location
  void sendUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Construct Google Maps link
      String mapsLink =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

      // Send location as a message
      String locationMessage = 'Location: $mapsLink';

      await _chatService.sendMessage(
        widget.receiverUserID,
        locationMessage,
      );
      
      // Launch URL when the message is sent
      launchUrl(mapsLink as Uri); // Open the Google Maps link
    } else {
      // Handle if location permission is not granted
      print('Location permission not granted');
    }
  }

  void sendMessage() async {
    //only send messages if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserID, 
        _messageController.text);
      //clear the text controller after sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail),
      centerTitle: true,
      ),
      body: Column(
        children: [
          //messages
          Expanded( 
          child: _buildMessageList(),
          ),

          //user inout
          _buildMessageInput(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid), 
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading...');
      }

      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
    });
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
            onPressed: () async {
              String? imagePath = await _getImageFromDevice();
              if (imagePath != null) {
                String imageUrl = await uploadImageToFirebaseStorage(imagePath);
                await _chatService.sendMessage(
                  widget.receiverUserID,
                  '', // Optional message text for image
                  imageUrl,
                );
              }
            },
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
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )
          ),

          //send location button
          IconButton(
            color: Colors.black,
            onPressed: sendUserLocation,
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

Future<String?> _getImageFromDevice() async {
  final picker = ImagePicker();
  
  try {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      // User canceled image picking
      return null;
    }
  } catch (e) {
    print("Error picking image: $e");
    return null;
  }
}

Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('chat_images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = ref.putFile(File(imagePath));
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
