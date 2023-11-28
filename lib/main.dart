import 'package:capstone/components/square_tile.dart';
import 'package:capstone/pages/notificationpage.dart';
import 'package:capstone/services/auth/auth_gate.dart';
import 'package:capstone/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'pages/accountpage.dart';
import 'pages/chatpage.dart';
import 'pages/groupchat/groupspage.dart';
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
                      imagePath: 'assets/images/logo.jpg',
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Set<Marker> _markers = {};



  Future<void> _getOtherUsersLocations() async {

    return _firestore.collection('users').get().then((usersSnapshot) {
    setState(() {
      _markers = usersSnapshot.docs
          .map((DocumentSnapshot document) {
        GeoPoint? userGeoPoint = document['location'];
        double lat = userGeoPoint!.latitude;
        double lng = userGeoPoint.longitude;

        String userUsername = document['username'];
        String userEmail = document['email'];

        // Creating a Marker for each user
        return Marker(
          markerId: MarkerId(document.id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: userUsername, 
            snippet: userEmail,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()
                ),
              );
            }
          ),
        );
      }).toSet();
    });
  }).catchError((error) {
    print('Error getting other users locations: $error');
  });
}
  
  
  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator
      .getCurrentPosition();
    _getOtherUsersLocations();
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
                        markers: _markers,
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


