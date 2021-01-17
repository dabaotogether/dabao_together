import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/Add_Request.dart';
import 'package:dabao_together/Screens/ChatHome.dart';
import 'package:dabao_together/Screens/Edit_Request.dart';
import 'package:dabao_together/Screens/Main.dart';
import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';

// final _firestore = Firestore.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;
final geo = Geoflutterfire();
final _auth = FirebaseAuth.instance;

class MyRequestsScreen extends StatefulWidget {
  static const String id = 'my_requests_screen';
  // MainActivityContainer({@required this.colour, this.cardChild, this.onPress});
  //
  // final Color colour;
  // final Widget cardChild;
  // final Function onPress;
  @override
  _MyRequestsScreenState createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  Stream<QuerySnapshot> requestStream;

  @override
  void initState() {
    requestStream = newStream();
    super.initState();
  }

  Stream<QuerySnapshot> newStream() {
    var requestsDoc = firestoreInstance
        .collection('requests')
        .where('expired', isEqualTo: 0)
        .where('user_id', isEqualTo: _auth.currentUser.uid)
        .snapshots();

    print('newStream');
    return requestsDoc;
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        Navigator.pushNamed(
          context,
          ChatHomeScreen.id,
        );
      } else if (_selectedIndex == 0) {
        Navigator.pushNamed(
          context,
          MainActivityContainer.id,
        );
      }
    });
  }

  final _showRequestsFormKey = GlobalKey<FormState>();
  TextEditingController postalCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String postalCode = '';
    String address = '';
    String geox = '';
    String geoy = '';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('My Jios')),
        drawer: AppDrawer(
          username: _auth.currentUser.displayName == null
              ? 'Error'
              : _auth.currentUser.displayName,
          selectedIndex: 1,
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.emoji_people_rounded),
        //       label: 'Find Kakis',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.local_activity_rounded),
        //       label: 'My Requests',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat_rounded),
        //       label: 'Chats',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.amber[800],
        //   onTap: _onItemTapped,
        // ),
        floatingActionButton: FloatingActionButton(
            heroTag: "floatingbutton2",
            backgroundColor: Colors.black87,
            child: Icon(
              Icons.fastfood_rounded,
              color: Colors.white,
            ),
            elevation: 20,
            onPressed: () {
              Navigator.pushNamed(context, AddRequest.id);
            }),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              // stream: firestoreInstance.collection("requests").snapshots(),

              stream: requestStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black87,
                        strokeWidth: 10,
                      ),
                    );
                  default:
                    return snapshot.data == null || snapshot.data.size == 0
                        ? Container(
                            margin: EdgeInsets.all(15.0),
                            child: Center(
                              child: TyperAnimatedTextKit(
                                isRepeatingAnimation: false,
                                // duration: Duration(milliseconds: 8000),
                                text: [
                                  "No active jios yet. Please post to jio your neighbours!"
                                ],
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // itemCount: snapshot.data.documents.length,
                            itemCount: snapshot.data.size,
                            itemBuilder: (context, index) {
                              // List rev = snapshot.data.documents.reversed.toList();

                              DocumentSnapshot data = snapshot.data.docs[index];

                              String requestId = data.id;
                              String requestorName =
                                  data['username'].toString();
                              String requestorId = data['user_id'].toString();
                              Timestamp orderTimeStamp = data['date_time'];
                              DateTime orderDateTime = DateTime.parse(
                                  orderTimeStamp.toDate().toString());
                              DateFormat orderDateTimeFormat =
                                  new DateFormat('dd MMM yyyy hh:mm a');
                              String orderDateTimeString =
                                  orderDateTimeFormat.format(orderDateTime);
                              Image platform = Image.asset('images/others.png');
                              String vendor = data['vendor'];
                              if (data['platform'] != null) {
                                if (data['platform'] == 1) {
                                  platform = Image.asset('images/grabfood.png');
                                } else if (data['platform'] == 2) {
                                  platform =
                                      Image.asset('images/foodpanda.png');
                                } else if (data['platform'] == 3) {
                                  platform =
                                      Image.asset('images/deliveroo.png');
                                } else if (data['platform'] == 4) {
                                  platform = Image.asset('images/whyq.png');
                                }
                              }

                              return Container(
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.black54),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    child: platform,
                                  ),
                                  title: Text(
                                    vendor,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address: ' + data['address'],
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        'Order Time: ' + orderDateTimeString,
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                  trailing: buildTrailingItem(
                                      context,
                                      requestorId,
                                      requestorName,
                                      vendor,
                                      requestId,
                                      data),
                                ),
                              );
                            },
                          );
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget buildTrailingItem(
      BuildContext context,
      String requestorId,
      String requestorName,
      String vendor,
      String requestId,
      DocumentSnapshot documentData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Material(
        elevation: 5.0,
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              EditRequest.id,
              arguments: <String, dynamic>{
                'requestorName': requestorName,
                'requestorId': requestorId,
                'documentSnapshot': documentData,
              },
            );
          },
          // minWidth: 80.0,
          height: 25.0,
          child: Text(
            'Edit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
