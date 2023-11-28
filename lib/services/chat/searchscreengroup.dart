import 'package:capstone/pages/messagepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreenGroup extends StatefulWidget {
  const SearchScreenGroup({super.key});

  @override
  State<SearchScreenGroup> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreenGroup> {
  String name = "";
  // Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          )
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection('users').snapshots(), 
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
            ? const Center(
              child: CircularProgressIndicator(),
            )
            : ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshots.data!.docs[index].data()
                  as Map<String, dynamic>;

                if (name.isEmpty) {
                  return ListTile(
                    title: Text(
                      data['username'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: const Icon(Icons.account_box, color: Colors.black),
                    subtitle: Text(data['email']),
                    trailing: const Icon(Icons.chat, color: Colors.black,
                    ), 
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
                }

                if(data['username'].toString().toLowerCase().startsWith(name.toLowerCase())) {
                  return ListTile(
                    title: Text(
                      data['username'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: const Icon(Icons.account_box, color: Colors.black),
                    subtitle: Text(data['email']),
                    trailing: const Icon(Icons.chat, color: Colors.black,
                    ), 
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
                }
                return Container();
              },
            );
        }
      )
    );
  }
}