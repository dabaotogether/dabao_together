import 'dart:async';
import 'dart:convert' as convert;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/Screens/Add_Request.dart';
import 'package:dabao_together/Screens/ChatHome.dart';
import 'package:dabao_together/Screens/ChatScreen.dart';
import 'package:dabao_together/Screens/Edit_Request.dart';
import 'package:dabao_together/Screens/GoogleMapScreen.dart';
import 'package:dabao_together/Screens/My_Requests.dart';
import 'package:dabao_together/components/app_drawer.dart';
import 'package:dabao_together/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// final _firestore = Firestore.instance;
User loggedInUser;
final firestoreInstance = FirebaseFirestore.instance;
final geo = Geoflutterfire();
final _auth = FirebaseAuth.instance;

class MainActivityScreen extends StatefulWidget {
  // static const String id = 'main_activity_screen';
  @override
  _MainActivityScreenState createState() => _MainActivityScreenState();
}

class _MainActivityScreenState extends State<MainActivityScreen> {
  final _auth = FirebaseAuth.instance;
  String userName = '';
  String displayName;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    print('getCurrentUser');
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        displayName = user.displayName;
        if (loggedInUser != null) {
          setState(() {
            userName = loggedInUser.displayName;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseUser user = await _auth.currentUser();
    String title;
    return Container(
      child: Expanded(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(title: Text('test qwe'));
        },
      )),
    );
  }
}

class MainActivityContainer extends StatefulWidget {
  static const String id = 'main_activity_screen';
  // MainActivityContainer({@required this.colour, this.cardChild, this.onPress});
  //
  // final Color colour;
  // final Widget cardChild;
  // final Function onPress;
  @override
  _MainActivityContainerState createState() => _MainActivityContainerState();
}

class _MainActivityContainerState extends State<MainActivityContainer> {
  Stream<List<DocumentSnapshot>> requestStream;
  GeoFirePoint center =
      geo.point(latitude: 1.434572639, longitude: 103.8317969);

  @override
  void initState() {
    requestStream = newStream(center);
    super.initState();
  }

  Stream<List<DocumentSnapshot>> newStream(GeoFirePoint newCenter) {
    var queryRef =
        firestoreInstance.collection('requests').where('expired', isEqualTo: 0);
    // .where("date_time", isGreaterThan: new DateTime.now());
    Stream<List<DocumentSnapshot>> doc = geo
        .collection(collectionRef: queryRef)
        .within(
            center: newCenter, radius: 1, field: 'geo_point', strictMode: true);
    print('newStream');
    return doc;
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        Navigator.pushNamed(
          context,
          ChatHomeScreen.id,
        );
      }
      if (_selectedIndex == 1) {
        Navigator.pushNamed(
          context,
          MyRequestsScreen.id,
        );
      }
    });
  }

  void _isNewChatPeer(String user_id, String username, String requestorId,
      String requestorName, String vendor) {
    print('_isNewChatPeer');
    print(user_id);
    print(username);
    firestoreInstance
        .collection('users')
        .doc(requestorId)
        .collection('active_chat')
        .doc(user_id)
        .set({
      'username': username,
      'vendor': vendor,
      'created_time': FieldValue.serverTimestamp(),
      'deleted': 0,
    });
    firestoreInstance
        .collection('users')
        .doc(user_id)
        .collection('active_chat')
        .doc(requestorId)
        .set({
      'username': requestorName,
      'vendor': vendor,
      'created_time': FieldValue.serverTimestamp(),
      'deleted': 0,
    });

    // DocumentReference documentReference =
    //     firestoreInstance.collection("users").doc(user_id);
    // Map<String, dynamic> activeChatMainMap = new Map();
    // Map<String, String> activeChatMap = new Map();
    // Map<String, dynamic> activeRequestorChatMainMap = new Map();
    // Map<String, String> activeRequestorChatMap = new Map();
    // documentReference.get().then((data) {
    //   if (data.exists) {
    //     print('first');
    //
    //     // print(data['active_chat'].toString());
    //     if (data.data()['active_chat'] == null) {
    //       print('second');
    //       activeChatMap[requestorId] = requestorName;
    //       activeChatMainMap['active_chat'] = activeChatMap;
    //       activeRequestorChatMap[user_id] = username;
    //       activeRequestorChatMainMap['active_chat'] = activeRequestorChatMap;
    //     } else {
    //       activeChatMap = data['active_chat'];
    //       if (!activeChatMap.containsKey(requestorId)) {
    //         activeChatMap[requestorId] = requestorName;
    //         activeChatMainMap['active_chat'] = activeChatMap;
    //         activeRequestorChatMap[user_id] = username;
    //         activeRequestorChatMainMap['active_chat'] = activeRequestorChatMap;
    //       }
    //     }
    //     firestoreInstance
    //         .collection('users')
    //         .doc(user_id)
    //         .set(activeChatMainMap, SetOptions(merge: true));
    //     firestoreInstance
    //         .collection('users')
    //         .doc(requestorId)
    //         .set(activeRequestorChatMainMap, SetOptions(merge: true));
    //
    //   } else {
    //     print("No such user");
    //   }
    // });
  }

  void _isNewChatPeerTemp(String user_id, String username, String requestorId,
      String requestorName) {
    print('_isNewChatPeer');
    print(user_id);
    print(username);
    DocumentReference documentReference =
        firestoreInstance.collection("users").doc(user_id);
    Map<String, dynamic> activeChatMainMap = new Map();
    Map<String, String> activeChatMap = new Map();
    Map<String, dynamic> activeRequestorChatMainMap = new Map();
    Map<String, String> activeRequestorChatMap = new Map();
    documentReference.get().then((data) {
      if (data.exists) {
        print('first');

        // print(data['active_chat'].toString());
        if (data.data()['active_chat'] == null) {
          print('second');
          activeChatMap[requestorId] = requestorName;
          activeChatMainMap['active_chat'] = activeChatMap;
          activeRequestorChatMap[user_id] = username;
          activeRequestorChatMainMap['active_chat'] = activeRequestorChatMap;
        } else {
          activeChatMap = data['active_chat'];
          if (!activeChatMap.containsKey(requestorId)) {
            activeChatMap[requestorId] = requestorName;
            activeChatMainMap['active_chat'] = activeChatMap;
            activeRequestorChatMap[user_id] = username;
            activeRequestorChatMainMap['active_chat'] = activeRequestorChatMap;
          }
        }
        firestoreInstance
            .collection('users')
            .doc(user_id)
            .set(activeChatMainMap, SetOptions(merge: true));
        firestoreInstance
            .collection('users')
            .doc(requestorId)
            .set(activeRequestorChatMainMap, SetOptions(merge: true));
      } else {
        print("No such user");
      }
    });
  }

  final _showRequestsFormKey = GlobalKey<FormState>();
  TextEditingController postalCodeController = TextEditingController();
  bool searchStarted = false;
  @override
  Widget build(BuildContext context) {
    String postalCode = '';
    String address = '';
    String geox = '';
    String geoy = '';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Find Kakis')),
        drawer: AppDrawer(
          username: _auth == null ? 'Error' : _auth.currentUser.displayName,
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
            heroTag: "floatingbutton1",
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
            Container(
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Form(
                key: _showRequestsFormKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: postalCodeController,
                      decoration: new InputDecoration(
                        prefixIcon: Icon(
                          Icons.my_location_rounded,
                          size: 40,
                        ),
                        labelText: "My Postal Code",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length != 6) {
                          return "Please enter a valid Singapore 6-digit postal code";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value.length == 6) {
                          postalCode = value;
                          print(postalCode);
                        }
                      },
                      onSaved: (value) {
                        postalCode = value;
                      },
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    RoundedSmallButton(
                      title: 'Find My Kakis!',
                      colour: Colors.black87,
                      onPressed: () async {
                        if (_showRequestsFormKey.currentState.validate()) {
                          _showRequestsFormKey.currentState.save();
                          var url =
                              'https://developers.onemap.sg/commonapi/search?searchVal=$postalCode&returnGeom=Y&getAddrDetails=Y&pageNum=1';

                          // Await the http get response, then decode the json-formatted response.
                          var response = await http.get(url);
                          //TODO to do a pop up for user to choose if there are more than 1 result?
                          if (response.statusCode == 200) {
                            var jsonResponse =
                                convert.jsonDecode(response.body);
                            var result = jsonResponse['found'];
                            int resultCount = int.parse(result.toString());
                            if (resultCount != 0) {
                              searchStarted = true;
                              var blkNo = jsonResponse['results'][0]['BLK_NO'];
                              var roadName =
                                  jsonResponse['results'][0]['ROAD_NAME'];
                              geoy = jsonResponse['results'][0]['LATITUDE'];
                              geox = jsonResponse['results'][0]['LONGITUDE'];

                              center = geo.point(
                                  latitude: double.parse(geoy),
                                  longitude: double.parse(geox));
                              setState(() {
                                requestStream = newStream(center);
                              });
                              // address = blkNo.toString() + ' ' + roadName.toString();
                              // addressController.text =
                              //     blkNo.toString() + ' ' + roadName.toString();
                            } else {
                              postalCodeController.text = '';
                            }

                            print(jsonResponse);
                          } else {
                            print(
                                'Request failed with status: ${response.statusCode}.');
                          }
                        }

                        // requestStream = requestStreamController.stream;
                      },
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),

            Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
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
                    if (snapshot.hasError) {
                      return Container(
                        margin: EdgeInsets.all(15.0),
                        child: Center(
                          child: TyperAnimatedTextKit(
                            isRepeatingAnimation: false,
                            // duration: Duration(milliseconds: 8000),
                            text: [
                              "There is a technical glitch, please try again."
                            ],
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      );
                    }
                    return (snapshot.data == null ||
                                snapshot.data.length == 0) &&
                            searchStarted
                        ? Container(
                            margin: EdgeInsets.all(15.0),
                            child: Center(
                              child: TyperAnimatedTextKit(
                                isRepeatingAnimation: false,
                                // duration: Duration(milliseconds: 8000),
                                text: [
                                  "Unable to find any kakis within 1km yet! Do try again later and help us to share the app with your neighbours group chat or Facebook group. Thanks!"
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
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              // List rev = snapshot.data.documents.reversed.toList();

                              DocumentSnapshot data = snapshot.data[index];
                              GeoPoint requestGeoPoint =
                                  data['geo_point']['geopoint'];
                              double dist = center.distance(
                                      lat: requestGeoPoint.latitude,
                                      lng: requestGeoPoint.longitude) *
                                  1000;
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
                              String remarks = data['remarks'];
                              if (remarks.length == 0) {
                                remarks = 'NA';
                              }
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
                              String shareDeliveryFee = 'Yes';
                              if (data['fees'] != null) {
                                if (data['fees'] == 2) {
                                  shareDeliveryFee =
                                      'No (Rem to say thank you!)';
                                }
                              }

                              //For next release
                              // String cuisineString = '';
                              // List<String> cuisineOptions = [
                              //   'Fast Food',
                              //   'Bubble Tea',
                              //   'Hawker',
                              //   'Western',
                              //   'Chinese',
                              //   'Muslim',
                              //   'Indian',
                              //   'Thai',
                              //   'Korean',
                              //   'Japanese',
                              //   'Others'
                              // ];
                              // List<dynamic> selectedCuisineOptions = [
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              //   false,
                              // ];

                              // if (data['type_of_food'] != null) {
                              //   selectedCuisineOptions = data['type_of_food'];
                              //   int index = 0;
                              //   for (bool type in selectedCuisineOptions) {
                              //     if (type) {
                              //       if (cuisineString.length == 0)
                              //         cuisineString = cuisineOptions[index];
                              //       else
                              //         cuisineString = cuisineString +
                              //             ',' +
                              //             cuisineOptions[index];
                              //     }
                              //     index++;
                              //   }
                              // }
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
                                      // Text(
                                      //   'Type of cuisine: ' + cuisineString,
                                      //   style:
                                      //       TextStyle(color: Colors.black87),
                                      // ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Address: ',
                                                style: TextStyle(
                                                    color: Colors.black87)),
                                            TextSpan(
                                                text: data['address'],
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          GoogleMapScreen.id,
                                                          arguments: <String,
                                                              dynamic>{
                                                            'latitude':
                                                                requestGeoPoint
                                                                    .latitude,
                                                            'longitude':
                                                                requestGeoPoint
                                                                    .longitude,
                                                          },
                                                        );
                                                      }),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Order Time: ' + orderDateTimeString,
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        'Split Delivery fee: ' +
                                            shareDeliveryFee,
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        'Distance: ' +
                                            dist.round().toString() +
                                            'm',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        'Remarks: ' + remarks,
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
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 10.0),
                                  //   child: Material(
                                  //     elevation: 5.0,
                                  //     color: Colors.black87,
                                  //     borderRadius: BorderRadius.circular(20.0),
                                  //     child: MaterialButton(
                                  //       onPressed: () {
                                  //         _isNewChatPeer(
                                  //             _auth.currentUser.uid,
                                  //             _auth.currentUser.displayName,
                                  //             requestorId,
                                  //             requestorName,
                                  //             vendor);
                                  //         Navigator.pushNamed(
                                  //           context,
                                  //           Chat.id,
                                  //           arguments: <String, String>{
                                  //             'requestorName': requestorName,
                                  //             'requestorId': requestorId,
                                  //             'vendor': vendor,
                                  //           },
                                  //         );
                                  //       },
                                  //       minWidth: 80.0,
                                  //       height: 35.0,
                                  //       child: Text(
                                  //         'Chat',
                                  //         style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 16,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              );
                            },
                          );
                }
              },
            ))
            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Padding(
            //           padding: EdgeInsets.only(right: 30, bottom: 30),
            //           child: FloatingActionButton(
            //               backgroundColor: Colors.black87,
            //               child: Icon(Icons.add),
            //               elevation: 20,
            //               onPressed: () {
            //                 Navigator.pushNamed(context, AddRequest.id);
            //               })),
            //     ],
            //   ),
            // )
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
    print('buildTrailingItem');
    if (_auth.currentUser.uid == requestorId) {
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
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Material(
          elevation: 5.0,
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20.0),
          child: MaterialButton(
            onPressed: () {
              _isNewChatPeer(
                  _auth.currentUser.uid,
                  _auth.currentUser.displayName,
                  requestorId,
                  requestorName,
                  vendor);
              Navigator.pushNamed(
                context,
                Chat.id,
                arguments: <String, String>{
                  'requestorName': requestorName,
                  'requestorId': requestorId,
                  'vendor': vendor,
                },
              );
            },
            minWidth: 80.0,
            height: 35.0,
            child: Text(
              'Chat',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      );
    }
  }
}
