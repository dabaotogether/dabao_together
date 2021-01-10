import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class MyPastRequestsScreen extends StatefulWidget {
  static const String id = 'my_past_requests_screen';
  // MainActivityContainer({@required this.colour, this.cardChild, this.onPress});
  //
  // final Color colour;
  // final Widget cardChild;
  // final Function onPress;
  @override
  _MyPastRequestsScreenState createState() => _MyPastRequestsScreenState();
}

class _MyPastRequestsScreenState extends State<MyPastRequestsScreen> {
  Stream<QuerySnapshot> requestStream;

  @override
  void initState() {
    requestStream = newStream();
    super.initState();
  }

  Stream<QuerySnapshot> newStream() {
    var requestsDoc = firestoreInstance
        .collection('requests')
        .where('expired', isEqualTo: 1)
        .where('user_id', isEqualTo: _auth.currentUser.uid)
        .snapshots();

    print('newStream');
    return requestsDoc;
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
        appBar: AppBar(title: Text('My Jio History')),
        drawer: AppDrawer(
          username: _auth.currentUser.displayName == null
              ? 'Error'
              : _auth.currentUser.displayName,
          selectedIndex: 2,
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
                                  "No jio history or no expired jio yet. Please post to jio your neighbours!"
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
}
