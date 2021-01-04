import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabao_together/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final _auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;

User loggedInUser;

class AddRequest extends StatefulWidget {
  static const String id = 'add_request_screen';

  @override
  _AddRequestState createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDateTime = DateTime.now();
  String shopName = '';
  String postalCode = '';
  String address = '';
  String remarks = '';
  String geox = '';
  String geoy = '';
  bool toSplitFee = true;
  String platform = '';
  int deliveryFeeChoiceChipValue = 1;
  int platformChoiceChipValue = 1;
  TextEditingController datePickerController = TextEditingController();
  TextEditingController timePickerController = TextEditingController();
  TextEditingController stallController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  bool isFirstLoad = true;
  final _addRequestFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    datePickerController.dispose();
    timePickerController.dispose();
    stallController.dispose();
    postalCodeController.dispose();
    addressController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime defaultDateTime = DateTime.now().add(Duration(minutes: 30));
    if (isFirstLoad) {
      datePickerController.text =
          DateFormat('dd-MMM-yyyy').format(defaultDateTime);
      timePickerController.text = DateFormat('hh:mm a').format(defaultDateTime);
      selectedDate = selectedDate.add(Duration(minutes: 30));
      selectedTime =
          TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 30)));
      isFirstLoad = false;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _addRequestFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30, right: 10, left: 10),
                  child: TextFormField(
                    // initialValue: DateFormat('yyyy-MMM-dd').format(DateTime.now()),
                    readOnly: true,
                    controller: datePickerController,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today_rounded,
                        size: 40,
                      ),
                      labelText: "Date of Order",
                      // fillColor: Colors.white,
                      // focusColor: Colors.black87,

                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      try {
                        DateTime pickedDate =
                            DateFormat('dd-MMM-yyyy').parse(val);
                        if (pickedDate.isBefore(
                                DateTime.now().subtract(Duration(days: 1))) ||
                            pickedDate.isAfter(
                                DateTime.now().add(Duration(days: 2)))) {
                          return "Please enter a future date within next 3 days";
                        }
                        return null;
                      } catch (e) {
                        return "Please enter a valid date format (e.g. 20-Nov-2020)";
                      }
                    },
                    onTap: () async {
                      DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 1)),
                      );

                      if (pickedDate != null) {
                        selectedDate = pickedDate;

                        datePickerController.text =
                            DateFormat('dd-MMM-yyyy').format(pickedDate);
                      }
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: TextFormField(
                    readOnly: true,
                    controller: timePickerController,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.access_time_rounded,
                        size: 40,
                      ),
                      labelText: "Time of Order",
                      // fillColor: Colors.white,
                      // focusColor: Colors.black87,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      try {
                        selectedTime.format(context);
                        return null;
                      } catch (e) {
                        return "Please enter a valid time format (e.g. 09:30 PM)";
                      }
                    },
                    onTap: () async {
                      TimeOfDay pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        selectedTime = pickedTime;
                        print(selectedTime);
                        timePickerController.text =
                            selectedTime.format(context);
                      }
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: TextFormField(
                    controller: stallController,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.store_mall_directory_rounded,
                        size: 40,
                      ),
                      labelText: "Shop/Restaurant",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length < 2) {
                        return "Please enter Shop/Restaurant with at least 3 characters";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      shopName = value;
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                //For next release
                // SizedBox(height: 10),
                // Stack(children: [
                //   Container(
                //     padding: EdgeInsets.only(
                //         top: 20, left: 10, right: 10, bottom: 10),
                //     margin: EdgeInsets.all(8.0),
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(30),
                //       border: Border.all(color: Colors.black54),
                //     ),
                //     child: Wrap(
                //       // height: 30,
                //       children: _buildFoodTypeChips(),
                //     ),
                //   ),
                //   Positioned(
                //       left: 40,
                //       // top: -10,
                //       child: Container(
                //         color: Colors.white,
                //         child: Text(
                //           'Type of Food',
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 12,
                //             fontFamily: "Poppins",
                //             // decoration: TextDecoration.underline,
                //             backgroundColor: Colors.white,
                //           ),
                //         ),
                //       )),
                // ]),
                Container(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: TextFormField(
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
                      if (addressController.text.length == 0) {
                        return "Please enter a valid Singapore 6-digit postal code";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) async {
                      if (value.length == 6) {
                        postalCode = value;
                        print(postalCode);
                        var url =
                            'https://developers.onemap.sg/commonapi/search?searchVal=$postalCode&returnGeom=Y&getAddrDetails=Y&pageNum=1';

                        // Await the http get response, then decode the json-formatted response.
                        var response = await http.get(url);
                        //TODO to do a pop up for user to choose if there are more than 1 result?
                        if (response.statusCode == 200) {
                          var jsonResponse = convert.jsonDecode(response.body);
                          var result = jsonResponse['found'];
                          int resultCount = int.parse(result.toString());
                          if (resultCount != 0) {
                            var blkNo = jsonResponse['results'][0]['BLK_NO'];
                            var roadName =
                                jsonResponse['results'][0]['ROAD_NAME'];
                            geoy = jsonResponse['results'][0]['LATITUDE'];
                            geox = jsonResponse['results'][0]['LONGITUDE'];
                            // address = blkNo.toString() + ' ' + roadName.toString();
                            addressController.text =
                                blkNo.toString() + ' ' + roadName.toString();
                          } else {
                            addressController.text = '';
                          }

                          print(jsonResponse);
                        } else {
                          print(
                              'Request failed with status: ${response.statusCode}.');
                        }
                      }
                    },
                    onSaved: (value) {
                      postalCode = value;
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                  child: TextFormField(
                    readOnly: true,
                    controller: addressController,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.home_work_rounded,
                        size: 40,
                      ),
                      labelText: "Address",
                      hintText: '*Fill in the Postal Code*',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    onSaved: (value) {
                      address = value;
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 10),
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Row(
                      // height: 30,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ChoiceChip(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          label: Text(
                            'To split',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          elevation: 10,
                          pressElevation: 5,
                          // shadowColor: Colors.teal,
                          backgroundColor: Colors.black38,
                          selectedColor: Colors.black54,
                          selected: deliveryFeeChoiceChipValue == 1,
                          onSelected: (bool selected) {
                            setState(() {
                              deliveryFeeChoiceChipValue = selected ? 1 : 2;
                            });
                          },
                        ),
                        ChoiceChip(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          label: Text(
                            'On the house!',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          elevation: 10,
                          pressElevation: 5,
                          // shadowColor: Colors.teal,
                          backgroundColor: Colors.black38,
                          selectedColor: Colors.black54,
                          selected: deliveryFeeChoiceChipValue == 2,
                          onSelected: (bool selected) {
                            setState(() {
                              deliveryFeeChoiceChipValue = selected ? 2 : 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 40,
                      // top: -10,
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          'Delivery Fee',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: "Poppins",
                            // decoration: TextDecoration.underline,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )),
                ]),
                Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 10),
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Column(
                      // height: 30,
                      // spacing: 10,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChoiceChip(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                'GrabFood',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              elevation: 10,
                              pressElevation: 5,
                              // shadowColor: Colors.teal,
                              backgroundColor: Colors.black38,
                              selectedColor: Colors.black54,
                              selected: platformChoiceChipValue == 1,
                              onSelected: (bool selected) {
                                setState(() {
                                  platformChoiceChipValue = selected ? 1 : 2;
                                });
                              },
                            ),
                            ChoiceChip(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                'FoodPanda',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              elevation: 10,
                              pressElevation: 5,
                              // shadowColor: Colors.teal,
                              backgroundColor: Colors.black38,
                              selectedColor: Colors.black54,
                              selected: platformChoiceChipValue == 2,
                              onSelected: (bool selected) {
                                setState(() {
                                  platformChoiceChipValue = selected ? 2 : 1;
                                });
                              },
                            ),
                            ChoiceChip(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                'Deliveroo',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              elevation: 10,
                              pressElevation: 5,
                              // shadowColor: Colors.teal,
                              backgroundColor: Colors.black38,
                              selectedColor: Colors.black54,
                              selected: platformChoiceChipValue == 3,
                              onSelected: (bool selected) {
                                setState(() {
                                  platformChoiceChipValue = selected ? 3 : 1;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChoiceChip(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                'WhyQ',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              elevation: 10,
                              pressElevation: 5,
                              // shadowColor: Colors.teal,
                              backgroundColor: Colors.black38,
                              selectedColor: Colors.black54,
                              selected: platformChoiceChipValue == 4,
                              onSelected: (bool selected) {
                                setState(() {
                                  platformChoiceChipValue = selected ? 4 : 1;
                                });
                              },
                            ),
                            ChoiceChip(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                'Others',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              elevation: 10,
                              pressElevation: 5,
                              // shadowColor: Colors.teal,
                              backgroundColor: Colors.black38,
                              selectedColor: Colors.black54,
                              selected: platformChoiceChipValue == 5,
                              onSelected: (bool selected) {
                                setState(() {
                                  platformChoiceChipValue = selected ? 5 : 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 40,
                      // top: -10,
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          'App/Platform',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: "Poppins",
                            // decoration: TextDecoration.underline,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )),
                ]),
                Container(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: TextFormField(
                    controller: remarksController,
                    maxLines: 3,
                    maxLength: 100,
                    maxLengthEnforced: true,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.info_outline_rounded,
                        size: 40,
                      ),
                      labelText: "Remarks",
                      hintText: "e.g. more info: type of food, contact number",

                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    onSaved: (value) {
                      remarks = value;
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedSmallButton(
                        title: 'Submit',
                        colour: Colors.black87,
                        onPressed: () {
                          if (_addRequestFormKey.currentState.validate()) {
                            // print(addressController.value);
                            _addRequestFormKey.currentState.save();

                            selectedDateTime = new DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            Geoflutterfire geo = Geoflutterfire();
                            GeoFirePoint location = geo.point(
                                latitude: double.parse(geoy),
                                longitude: double.parse(geox));

                            firestoreInstance.collection("requests").add({
                              "username": _auth.currentUser.displayName,
                              "user_id": _auth.currentUser.uid,
                              "date_time": selectedDateTime,
                              "vendor": shopName,
                              "type_of_food": _foodTypeSelected,
                              "postal_code": postalCode,
                              "address": address,
                              "geo_x": geox,
                              "geo_y": geoy,
                              "geo_point": location.data,
                              "fees": deliveryFeeChoiceChipValue,
                              "platform": platformChoiceChipValue,
                              "created_time": FieldValue.serverTimestamp(),
                              "expired": 0,
                              "remarks": remarks,
                            }).then((_) {
                              Flushbar(
                                title: "Hey " + _auth.currentUser.displayName,
                                message:
                                    "Your jio has been posted! Sit back and wait for kakis.",
                                duration: Duration(seconds: 3),
                              )..show(context);
                              print('saving to firestore done!');
                            });
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: RoundedSmallButton(
                        title: 'Cancel',
                        colour: Colors.black87,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO to remove after testing

  List<String> _foodTypeOptions = [
    'Fast Food',
    'Bubble Tea',
    'Hawker',
    'Western',
    'Chinese',
    'Muslim',
    'Indian',
    'Thai',
    'Korean',
    'Japanese',
    'Others'
  ];
  List<bool> _foodTypeSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List<Widget> _buildFoodTypeChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _foodTypeOptions.length; i++) {
      FilterChip filterChip = FilterChip(
        selected: _foodTypeSelected[i],
        label: Text(_foodTypeOptions[i], style: TextStyle(color: Colors.white)),
        // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        // shadowColor: Colors.teal,

        backgroundColor: Colors.black38,
        selectedColor: Colors.black54,
        onSelected: (bool selected) {
          setState(() {
            _foodTypeSelected[i] = selected;
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: filterChip));
    }

    return chips;
    // return ListView(
    //   // This next line does the trick.
    //   scrollDirection: Axis.horizontal,
    //   children: chips,
    // );
  }

  List<String> _feesOptions = [
    'To split fee',
    'On the house!',
  ];
  int _value = 1;

  List<Widget> _buildFeesChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _feesOptions.length; i++) {
      ChoiceChip filterChip = ChoiceChip(
        selected: _value == i,
        label: Text(_feesOptions[i], style: TextStyle(color: Colors.white)),
        // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        // shadowColor: Colors.teal,
        backgroundColor: Colors.black38,
        selectedColor: Colors.black54,
        onSelected: (bool value) {
          setState(() {
            _value = value ? i : null;
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: filterChip));
    }

    return chips;
    // return ListView(
    //   // This next line does the trick.
    //   scrollDirection: Axis.horizontal,
    //   children: chips,
    // );
  }
}
