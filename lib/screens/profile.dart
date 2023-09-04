import 'package:flutter/material.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'dart:io';

import 'package:travel_/screens/start.dart';

import '../widgets/textformfileldWidget.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.userInfo});
  Map<String, dynamic> userInfo;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String Username;
  late String Mail;
  @override
  void initState() {
    Username = widget.userInfo['name'];
    Mail = widget.userInfo['Mail'];
    super.initState();
  }
  getUserData()async{
    final user =await DatabaseHelper.instance.getloggeduser();
      Username=user!['name'];
      Mail=user['Mail'];
  }
  Widget build(BuildContext context) {
    getUserData();
    TextStyle color1 = TextStyle(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 20,
        fontWeight: FontWeight.w500);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PROFILE',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return Start(userInfo: widget.userInfo);
              },
            ));
          },
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      width: 2,
                      color: const Color.fromARGB(255, 184, 79, 116),
                    ),
                    color: Color.fromARGB(255, 25, 24, 24),
                  ),
                ),
                SizedBox(
                  height: 10
                ),
                FutureBuilder(
                    future: DatabaseHelper.instance.getloggeduser(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return Text('Somthing went wrong');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        final user = snapshot.data;
                        return Container(
                          margin: EdgeInsets.only(top: 40, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(user!["image"])),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user["name"],
                                    style: color1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    user["Mail"],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton.icon(
                                      onPressed: () {
                                        final val = editProfile(
                                            context, widget.userInfo);
                                        if (val) {
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                      label: Text(
                                        'Edit Profile',
                                        style: color1,
                                      )),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool editProfile(BuildContext context, Map<String, dynamic> userInfo) {
    TextEditingController name = TextEditingController();
    name.text = Username;

    TextEditingController newmail = TextEditingController();
    newmail.text = Mail;
    showModalBottomSheet(
        backgroundColor: Colors.black,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, refresh) {
            return Padding(
              padding: const EdgeInsets.all(22.0),
              child: Container(
                color: Colors.black,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Details',
                            style: TextStyle(color: Colors.white),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await DatabaseHelper.instance.updateProfile(
                                    widget
                                        .userInfo[DatabaseHelper.ColumnUserId],
                                    name.text,
                                    newmail.text);

                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              child: Text(
                                'Done',
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                            )),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Change Username',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                        controller: name,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Change Mail',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                        controller: newmail,
                      )
                    ]),
              ),
            );
          });
        });
    return true;
  }
}
