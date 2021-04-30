import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/components/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

// final _firestore = Firestore.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;
final geo = Geoflutterfire();
final _auth = FirebaseAuth.instance;

class Blocked_Users_List_Screen extends StatefulWidget {
  static const String id = 'blocked_users_list_screen';
  // MainActivityContainer({@required this.colour, this.cardChild, this.onPress});
  //
  // final Color colour;
  // final Widget cardChild;
  // final Function onPress;
  @override
  _Blocked_Users_List_ScreenState createState() =>
      _Blocked_Users_List_ScreenState();
}

class _Blocked_Users_List_ScreenState extends State<Blocked_Users_List_Screen> {
  Stream<QuerySnapshot> requestStream;

  @override
  void initState() {
    requestStream = newStream();
    super.initState();
  }

  Stream<QuerySnapshot> newStream() {
    var requestsDoc = firestoreInstance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('active_chat')
        .where('deleted', isEqualTo: 0)
        .where('blocked', isEqualTo: 1)
        .snapshots();

    return requestsDoc;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('My Blocked Users List')),
        drawer: AppDrawer(
          username: _auth.currentUser.displayName == null
              ? 'Error'
              : _auth.currentUser.displayName,
          selectedIndex: 5,
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
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
                                  "No blocked users! You are in luck or possibly too kind."
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
                              String peerId = data.id;
                              String peerName = data.get('username');
                              return Container(
                                margin: EdgeInsets.all(5.0),
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10, left: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.black54),
                                ),
                                child: ListTile(
                                  title: Text(
                                    peerName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  isThreeLine: false,
                                  trailing: buildTrailingItem(context,
                                      _auth.currentUser.uid, peerId, peerName),
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

  Widget buildTrailingItem(BuildContext context, String currentUserId,
      String peerId, String peerName) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Material(
        elevation: 5.0,
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: () {
            firestoreInstance
                .collection('users')
                .doc(currentUserId)
                .collection('active_chat')
                .doc(peerId)
                .update({
              'blocked': 0,
            }).then((_) {
              Flushbar(
                title: "Hey " + _auth.currentUser.displayName,
                message: "You have unblocked " +
                    peerName +
                    ". Messages from " +
                    peerName +
                    " have been restored and you are now able to receive in-app messages from " +
                    peerName,
                duration: Duration(seconds: 4),
              )..show(context);
              print('update request to firestore done!');
            });
          },
          // minWidth: 80.0,
          height: 25.0,
          child: Text(
            'Unblock',
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
