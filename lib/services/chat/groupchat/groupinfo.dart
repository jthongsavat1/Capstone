// import 'package:capstone/pages/messagepage.dart';
import 'package:capstone/pages/accounts/viewaccountpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupId;

  const GroupMembersScreen({super.key, required this.groupId});

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final currentUser = FirebaseAuth.instance.currentUser!.email;

  Future<List<dynamic>> getGroupMembers() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
          await _firestore.collection('groups').doc(widget.groupId).get();

      if (groupSnapshot.exists) {
        List<dynamic> members = groupSnapshot.data()?['members'];
        return members;
      }
      return [];
    } catch (error) {
      return [];
    }
  }

  Future<void> searchAndAddUserToGroup(BuildContext context) async {
    String selectedUserId = ''; // Store the selected user's ID

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = ''; // Store the search query

        return AlertDialog(
          title: const Text('Search and Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  searchQuery = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Search User',
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  // Implement the logic to search users in Firestore based on 'searchQuery'
                  QuerySnapshot<Map<String, dynamic>> querySnapshot =
                      await _firestore
                          .collection('users')
                          .where('email', isEqualTo: searchQuery)
                          .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    // Display the search results, allowing selection of a user
                    // For demonstration, just selecting the first user in the query
                    selectedUserId = querySnapshot.docs.first.id;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User found!'),
                      ),
                    );
                  } else {
                    // No user found with the provided email
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No user found with this email'),
                      ),
                    );
                  }
                },
                child: const Text('Search'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add User'),
              onPressed: () async {
                if (selectedUserId.isNotEmpty) {
                  // Add selectedUserId to the group
                  try {
                    await _firestore
                        .collection('groups')
                        .doc(widget.groupId)
                        .update({
                      'members': FieldValue.arrayUnion([selectedUserId]),
                    });
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User added to the group with ID: $selectedUserId'),
                      ),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error adding user to the group: $error'),
                      ),
                    );
                  }
                } else {
                  // No user selected to add
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No user selected'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> leaveGroup(BuildContext context, String email) async {
    try {
      // Remove the user from the 'members' array of the group
      await _firestore.collection('groups').doc(widget.groupId).update({
        'members': FieldValue.arrayRemove([email]),
      });
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have left the group'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error leaving the group: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              searchAndAddUserToGroup(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getGroupMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> members = snapshot.data ?? [];

            if (members.isEmpty) {
              return const Center(child: Text('No members in this group'));
            }

            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                String memberId = members[index];
                // var data = members[index]
                //   as Map<String, dynamic>;

                return ListTile(
                  title: Text(memberId),
                  leading: const Icon(Icons.account_box, color: Colors.black),
                  onTap: () {
                  // Navigate to the user's account page
                  navigateToAccountPage(context, memberId);
                },
                  // You can customize the ListTile based on the member data
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.exit_to_app),
        onPressed: () async {

        // Check if the current user is a member of the group
        List<dynamic> members = await getGroupMembers();
        if (members.contains(currentUser!)) {
          // If the current user is a member, then leave the group
          await leaveGroup(context, currentUser!);
        } else {
          // If the user is not a member, show a message (for illustration purposes)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are not a member of this group'),
            ),
          );
        }
      },
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
    void navigateToAccountPage(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAccountPage(userId: userId),
      ),
    );
  }
}