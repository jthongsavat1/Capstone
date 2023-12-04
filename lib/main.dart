import 'package:capstone/components/square_tile.dart';
import 'package:capstone/pages/notificationpage.dart';
import 'package:capstone/services/auth/auth_gate.dart';
import 'package:capstone/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'pages/accounts/accountpage.dart';
import 'pages/chatpage.dart';
import 'services/chat/groupchat/groupspage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_options.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseApi().initNotifications();
  runApp(
    ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 155, 46, 19),
      )),
      home: const AuthGate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex= 0;
  
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const MainPage();
        break;
      case 1:
        page = const GroupsPage();
        break;
      case 2:
        page = const ChatPage();
        break;
      case 3:
        page = const AccountPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                        backgroundColor: Colors.black,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.people),
                        label: 'Groups',
                        backgroundColor: Colors.black,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.message), 
                        label: 'Chat',
                        backgroundColor: Colors.black,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person), 
                        label: 'Account',
                        backgroundColor: Colors.black,
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                    fixedColor: Colors.lightBlueAccent,
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    indicatorColor: Colors.white,
                    groupAlignment: 1.0,
                    leading: 
                    SquareTile(
                      onTap: () {}, 
                      imagePath: 'assets/images/logoidea.png',
                    ),
                    trailing: Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              const Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child:
                                Text('Currentlty signed in as: '),
                              ),
                              Text(currentUser.email!)
                            ],
                          ),
                        ),
                      ),
                    selectedIconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    selectedLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 0.8,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2.0,
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 0.8,
                    ),
                    backgroundColor: const Color.fromARGB(255, 155, 46, 19),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.people),
                        label: Text('Groups'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.message), 
                        label: Text('Chat')
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person), 
                        label: Text('Account')
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future < Position > _currentLocation;
  final currentUser = FirebaseAuth.instance.currentUser!.email;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Set<Marker> _markers = {};
  String _selectedGroup = ''; //Store the selected ID
  List<String> _userGroups = []; // List to store user's groups

  //Function to get different marker colors based on the uid 
  Color getMarkerColor(String uid) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];

    //Get the color index based on the uid
    int colorIndex = uid.hashCode % colors.length;
      return colors[colorIndex];
  }

Future<void> _fetchUserGroups() async {
  try {
    QuerySnapshot<Map<String, dynamic>> userGroupsSnapshot = await _firestore
        .collection('groups')
        .where('members', arrayContains: currentUser)
        .get();

    setState(() {
      _userGroups = userGroupsSnapshot.docs.map((doc) => doc['groupName'] as String).toList();
      if (_userGroups.isNotEmpty) {
        _selectedGroup = _userGroups.first;
        _getOtherUsersLocations(
          // _selectedGroup
        );
      }
    });
  } catch (error) {
    print('Error fetching user groups: $error');
  }
}



// Future<void> _getOtherUsersLocations(String groupId) async {
//   try {
//     // Fetch user emails from the selected group
//     DocumentSnapshot<Map<String, dynamic>> groupDoc =
//         await _firestore.collection('groups').doc(groupId).get();

//     List<dynamic> members = groupDoc.data()?['members'] ?? [];

//     Set<Marker> markers = {};

//     for (var i = 0; i < members.length; i++) {
//       String userId = members[i];

//       // Query the 'users' collection for user with the specified userId
//       QuerySnapshot<Map<String, dynamic>> userQuerySnapshot =
//           await _firestore.collection('users').where('userId', isEqualTo: userId).get();

//       if (userQuerySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot<Map<String, dynamic>> userSnapshot = userQuerySnapshot.docs.first;
//         GeoPoint? userGeoPoint = userSnapshot.data()?['location'];

//         if (userGeoPoint != null) {
//           double lat = userGeoPoint.latitude;
//           double lng = userGeoPoint.longitude;

//           String userUsername = userSnapshot.data()?['username'];
//           String userEmail = userSnapshot.data()?['email'];

//           Marker marker = Marker(
//             markerId: MarkerId(userId),
//             position: LatLng(lat, lng),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//             infoWindow: InfoWindow(
//               title: userUsername,
//               snippet: userEmail,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ChatPage(),
//                   ),
//                 );
//               },
//             ),
//           );

//           markers.add(marker);
//         }
//       }
//     }

//     setState(() {
//       _markers = markers; // Update the state with new markers
//     });
//   } catch (error) {
//     print('Error fetching user locations: $error');
//   }
// }




Future<void> _getOtherUsersLocations() async {
  try {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await _firestore.collection('users').get();

    Set<Marker> markers = {};

    setState(() {
      _markers.clear(); // Clear existing markers

      for (var document in usersSnapshot.docs) {
        GeoPoint? userGeoPoint = document['location'];
        if (userGeoPoint != null) {
          double lat = userGeoPoint.latitude;
          double lng = userGeoPoint.longitude;

          String userUsername = document['username'];
          String userEmail = document['email'];

          Marker marker = Marker(
            markerId: MarkerId(document.id),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: userUsername,
              snippet: userEmail,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                );
              },
            ),
          );

          markers.add(marker);
        }
      }

      _markers.addAll(markers); // Add all markers to the _markers set
    });
  } catch (error) {
    print('Error fetching users\' locations: $error');
  }
}



// Function to handle changing groups
  void _changeGroup(String newGroupId) {
    setState(() {
      _selectedGroup = newGroupId;
    });
    _getOtherUsersLocations(
      // newGroupId
    );
  }
  
  
  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator
      .getCurrentPosition();
    _fetchUserGroups();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The Top Bar of the main body
    appBar: AppBar(
      //The Title of the Page
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.group), // Icon for the dropdown
            onSelected: _changeGroup,
            itemBuilder: (BuildContext context) {
              return _userGroups.map((String group) {
                return PopupMenuItem<String>(
                  value: group,
                  child: Text(group), // Adjust text representation
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
            icon: const Icon(Icons.notifications),
            ),
        ],
      ),
      body:
        Stack(
          children: [
              FutureBuilder(
                future: _currentLocation,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      // The user location returned from the snapshot
                      Position? snapshotData = snapshot.data;
                      LatLng userLocation =
                        LatLng(snapshotData!.latitude, snapshotData.longitude);
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: userLocation,
                          zoom: 16,
                        ),
                        markers: Set<Marker>.from(_markers),
                        // {
                        //   Marker(
                        //     markerId: const MarkerId("User Location"),
                        //     infoWindow: InfoWindow(title: "$currentUser Location"),
                        //     position: userLocation),
                        //   },
                      );
                    } else {
                      return const Center(child: Text("Failed to get user location."));
                    }
                  }
                  // While the connection is not in the done state yet
                  return const Center(child: CircularProgressIndicator());
                }
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child:
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: FloatingActionButton(
                    onPressed: () =>
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertUsers();
                        }
                      ),
                    child: const Icon(Icons.access_alarm),
                    ),
                  ),
              ),
        ],
      ),
    );
  }
}



class AlertUsers extends StatelessWidget {
  const AlertUsers ({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        'Do you want to alert other users?',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text(
            'Yes, Please',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}


