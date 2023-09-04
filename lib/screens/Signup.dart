import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/start.dart';

import '../widgets/textfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

final Formkey = GlobalKey<FormState>();


class _SignupState extends State<Signup> {
  final _nameController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _ConfirmPasswordController = TextEditingController();
  final _mailcontroller = TextEditingController();
  File? image;
  bool imagecheck = false;

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.sizeOf(context).height;
    double devicewidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        body: Container(
      height: deviceheight,
      color: const Color.fromARGB(255, 0, 0, 0),
      width: devicewidth,
      child: SingleChildScrollView(
        child: Stack(children: [
          Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 20),
                  child: Text(
                    'Let  me guide your\n journey. ',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                width: devicewidth,
                height: deviceheight / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/1.jpg'),
                        fit: BoxFit.fill)),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                    height: deviceheight * 2 / 3,
                    color: Color.fromARGB(255, 0, 0, 0),
                    child: Form(
                      key: Formkey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                          ),
                          CustomTextField(
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[a-zA-Z]+$').hasMatch(value!)) {
                                return 'Enter Correct Name';
                              } else {
                                return null;
                              }
                            },
                            controller: _nameController,
                            icon: Icons.person,
                            label: 'Enter your name',
                          ),
                          CustomTextField(
                            controller: _PasswordController,
                            obscureText: true,
                            icon: Icons.password,
                            label: 'Enter Your Password',
                          ),
                          CustomTextField(
                              validator: (value) {
                                if (_PasswordController.text !=
                                    _ConfirmPasswordController.text) {
                                  return 'Make sure both password are same';
                                } else {
                                  return null;
                                }
                              },
                              controller: _ConfirmPasswordController,
                              obscureText: true
                              ,
                              icon: Icons.password,
                              label: 'Re-Enter Your Password'),
                          CustomTextField(
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                        .hasMatch(value!)) {
                                  return 'Enter Correct mail/remove blank spaces';
                                } else {
                                  return null;
                                }
                              },
                              controller: _mailcontroller,
                              icon: Icons.mail,
                              label: 'Enter your Mail'),
                          SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _totelform();
                            },
                            child: Text('Sign Up'),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                backgroundColor: MaterialStatePropertyAll(
                                    const Color.fromARGB(255, 184, 79, 116))),
                          )
                        ],
                      ),
                    )),
              )
            ],
          ),
          Padding(

            padding: const EdgeInsets.only(top: 220,left: 130),
            child: InkWell(
                onTap: () => addimage(),
                child: imagecheck == true
                    ? CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 75,
                      )
                    : Padding(
                      padding: const EdgeInsets.only(left: 10 ),
                      child: CircleAvatar(
                        child: Lottie.asset('assets/images/cam.json',width: 130,height: 130  ,fit: BoxFit.cover),
                        backgroundColor: Colors.white,

                        radius: 75,
                      ),
                    )),
          ),
        ]),
      ),
    ));
  }

  void _totelform() {
    if (Formkey.currentState!.validate()) {
      dataAdd();
    }
  }

  dataAdd() async {
    final _username = _nameController.text.trim();
    final _password = _PasswordController.text.trim();
    final _mail = _mailcontroller.text.trim();

    bool isTaken = await DatabaseHelper.instance.isUsernameTaken(_username);
    if (isTaken) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 184, 79, 116),
          content: Text('Username is already taken')));
    } else {
      Map<String, dynamic> userinfo = {
        DatabaseHelper.ColumnName: _username,
        DatabaseHelper.ColumnPassword: _password,
        DatabaseHelper.ColumnMail: _mail,
        DatabaseHelper.Columnimage: image!.path,
        DatabaseHelper.Columnislogin: 1,
        
      };

      print(userinfo);

      await DatabaseHelper.instance.insertRecords(userinfo);
      var db = await DatabaseHelper.instance.queryDatabase();
      print(db);
      final loggeduser =await DatabaseHelper.instance.getloggeduser();


      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return Start(
            userInfo: loggeduser! ,
          );
        },
      ));
    }
  }

  Future<void>  addimage() async {
    final Imagepath =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (Imagepath == null) {
      return;
    }
    final Imagetemp = File(Imagepath.path);

    setState(() {
      imagecheck = true;
      image = Imagetemp;
    });
  }
}
