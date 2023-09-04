import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/Addfirst.dart';

import 'package:travel_/screens/start.dart';

import '../widgets/textfield.dart';

class Addfinal extends StatefulWidget {
  const Addfinal({
    super.key,
    required this.addtripdata,
    required this.userInfo,
  });
  final Map<String, dynamic> addtripdata;
  final Map<String, dynamic> userInfo;

  @override
  State<Addfinal> createState() => _AddfinalState();
}

final Formkey3 = GlobalKey<FormState>();
final _BudgetContoller = TextEditingController();

final _noteController = TextEditingController();

class _AddfinalState extends State<Addfinal> {
  List<String> Transportaions = [
    'Mountains',
    'Lanscape',
    'Beach',
    'Forest',
    'Desert'
  ];
  int isSelected = 0;
  @override
  void initState() {
   _BudgetContoller.clear(); 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Icon(Icons.abc),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Form(
            key: Formkey3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Your Trip\nDetails   ',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill the field';
                      }

                      RegExp budgetRegex = RegExp(r'^\d+(\.\d{1,2})?$');
                      if (!budgetRegex.hasMatch(value)) {
                        return 'Invalid budget format. Please enter a valid number';
                      }
                      return null;
                    },
                    controller: _BudgetContoller,
                    icon: Icons.currency_rupee_rounded,
                    label: 'Enter your Budget'),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Destiny Type',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / .6, crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return ChoiceChip(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          height: 40,
                          width: 60,
                          child: Text(Transportaions[index],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          alignment: Alignment.center),
                      selectedColor: Color.fromARGB(255, 184, 79, 116),
                      selected: index == isSelected,
                      onSelected: (NewBoolValue) {
                        setState(() {
                          isSelected = NewBoolValue ? index : -1;
                        });
                      },
                    );
                  },
                  itemCount: Transportaions.length,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Write your trip notes',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 255, 255, 255))),
                  child: TextFormField(
                    controller: _noteController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    maxLines: 5,
                    maxLength: 500,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          _Addall();
                        },
                        child: Text("   Finish   "))),
                SizedBox(
                  height: deviceheight / 2 - 390,
                ),
                LinearPercentIndicator(
                  lineHeight: 10,
                  percent: 1,
                  progressColor: Color.fromRGBO(184, 79, 116, 1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _Addall() {
    //print('kjjjj');
    if (Formkey3.currentState!.validate()) {
      addDB();
      // print('*******');
    }
  }

  addDB() async {
    final _budget = _BudgetContoller.text;
    final _destination = Transportaions[isSelected];
    final _note = _noteController.text;

    widget.addtripdata[DatabaseHelper.ColumnBudget] = _budget;
    widget.addtripdata[DatabaseHelper.Columntriptype] = _destination;
    widget.addtripdata[DatabaseHelper.ColumnNote] = _note;
    widget.addtripdata[DatabaseHelper.ColumnUserId] = widget.userInfo['id'];
    final tripData = widget.addtripdata;
    // print(widget.addtripdata);
    //   print(widget.userInfo);
    await DatabaseHelper.instance.tripInsertRecords(tripData, companionList);
    //  print('Database Added');
    var db = await DatabaseHelper.instance.queryDatabase2();
    print('trips:********************');
    print(db);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) {
        return Start(userInfo: widget.userInfo);
      },
    ), (route) => false);
  }
}
