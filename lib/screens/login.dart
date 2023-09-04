import 'package:flutter/material.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/start.dart';

import 'Signup.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _PasswordControllerLog = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/14.jpg'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  height: 380,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            labelText: 'User Name',

                            suffixIcon: Icon(
                              Icons.person_outline_outlined,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: TextFormField(
                          controller: _PasswordControllerLog,
                          obscureText: true,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            labelText: 'Password',

                            suffixIcon: Icon(
                              Icons.password,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(
                                  const Color.fromARGB(255, 184, 79, 116))),
                          onPressed: () {
                            _login();


                          },
                          child: Text('Login')),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't have any account? ",
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 235, 235, 235))),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Signup();
                              }));
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 184, 79, 116),
                                  fontWeight: FontWeight.w800),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _login() async {
    final _username = _nameController.text;

    final _password = _PasswordControllerLog.text;

   final value= await DatabaseHelper.instance.logincheck(_username, _password);
    print('vvaal $value');
   if(value.isNotEmpty){
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
       return Start(userInfo: value);
     },), (route) => false);
   }else{
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromRGBO(255, 0, 0, 1),
          behavior: SnackBarBehavior.floating,
          
          margin: EdgeInsets.all(10),
          duration: Duration(milliseconds: 700),
          content: Text("USEENAME OR PASSWORD DOES' NOT MATCH"),
        ),
      );
   }
  }
}
