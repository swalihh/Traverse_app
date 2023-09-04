import 'package:flutter/material.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/widgets/Alltrips.dart';
import 'package:travel_/widgets/expenswdgt.dart';
import 'package:travel_/widgets/otherexpence.dart';

class Expenses extends StatefulWidget {
  Expenses({super.key, required this.userInfo, this.expensedata});
  final Map<String, dynamic> userInfo;
  Map<String, dynamic>? expensedata;
  Map<String, dynamic>? tripdata;

  @override
  State<Expenses> createState() => _ExpensesState();
}

final ExpenceController = TextEditingController();

class _ExpensesState extends State<Expenses> {
  String? _selectedCategory;
  double? mainexp;
int? upcoming;
int?finished;
  @override
  void initState() {
    print('jjjj');
    getExpence();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tripBudget = widget.tripdata != null
        ? double.parse(widget.tripdata!['Budget'].toString())
        : 0.0;

    double totalExpenses = widget.expensedata != null
        ? double.parse(widget.expensedata!['Expence'].toString())
        : 0.0;

    double balance = tripBudget - totalExpenses;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            'Expenses',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: const Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ongoing Expenses',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    ExpenseWidget(
                        first: ' Trip\nBudget',
                        cash: widget.tripdata != null
                                    ? widget.tripdata!['Budget'].toString()
                                    : '0.0',
                        last: 'Balance: ₹ $balance'),
                    SizedBox(
                      width: 33,
                    ),
                    Container(
                      height: 143,
                      width: 155,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Trip Expenses:',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                widget.expensedata != null
                                    ? widget.expensedata!['Expence'].toString()
                                    : '0.0',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.black,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(22.0),
                                                child: Container(
                                                  height: 200,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Add Expenses',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 20,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final tripdata =
                                                                  await DatabaseHelper
                                                                      .instance
                                                                      .readOngoingTrips(
                                                                          widget
                                                                              .userInfo['id']);
                                                              final tripId =
                                                                  tripdata.first[
                                                                      'userid'];
                                                              if (_selectedCategory !=
                                                                      null &&
                                                                  ExpenceController
                                                                      .text
                                                                      .isNotEmpty) {
                                                                double
                                                                    expenseAmount =
                                                                    double.parse(
                                                                        ExpenceController
                                                                            .text);

                                                                await DatabaseHelper
                                                                    .instance
                                                                    .addtoExpense(
                                                                  tripId,
                                                                  _selectedCategory!,
                                                                  expenseAmount,
                                                                );
                                                                
                                                                await getExpence();
                                                                print('99999');
                                                                ExpenceController
                                                                    .text = '';
                                                                Navigator.pop(
                                                                    context);
                                                              } else {}
                                                            },
                                                            child: Text('Add'),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            ExpenceController,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: const Color.fromARGB(
                                                                        255, 184, 79, 116),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        4)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: const Color.fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                    width: 2),
                                                                borderRadius: BorderRadius.circular(4)),
                                                            hintText: 'Enter Amount ',
                                                            hintStyle: TextStyle(color: Colors.white)),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                      SizedBox(
                                                        height: 12,
                                                      ),
                                                      DropdownButtonFormField<
                                                          String>(
                                                        hint: Text('choose'),
                                                        value:
                                                            _selectedCategory,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            _selectedCategory =
                                                                newValue;
                                                          });
                                                        },
                                                        dropdownColor:
                                                            Colors.black,
                                                        items: [
                                                          DropdownMenuItem(
                                                            value: 'food',
                                                            child: Text(
                                                              'Food',
                                                              style: TextStyle(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255)),
                                                            ),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'travel',
                                                            child: Text(
                                                              'Travel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'hotel',
                                                            child: Text(
                                                              'Hotel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 'others',
                                                            child: Text(
                                                              'Others',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                        decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.add_box_outlined,
                                      size: 35,
                                    ),
                                    color:
                                        const Color.fromARGB(255, 184, 79, 116),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Add New',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                Row(
                  children: [
                    OtherExpense(
                        money: widget.expensedata != null
                                    ? widget.expensedata!['food'].toString()
                                    : '0.0', food: 'food', icons: Icons.food_bank),
                    SizedBox(
                      width: 35,
                    ),
                    OtherExpense(
                        money: widget.expensedata != null
                                    ? widget.expensedata!['travel'].toString()
                                    : '0.0',
                        food: 'Travel',
                        icons: Icons.airport_shuttle),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    OtherExpense(
                        money: widget.expensedata != null
                                    ? widget.expensedata!['hotel'].toString()
                                    : '0.0', food: 'Hotel', icons: Icons.hotel),
                    SizedBox(
                      width: 35,
                    ),
                    OtherExpense(
                        money: widget.expensedata != null
                                    ? widget.expensedata!['others'].toString()
                                    : '0.0', food: 'Other', icons: Icons.earbuds),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'All Trips',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Alltrips(
                      first: '${upcoming??0}',
                      cash: 'Upcoming\nTrips',
                    ),
                    SizedBox(
                      width: 33,
                    ),
                    Container(
                      height: 143,
                      width: 155,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${finished??0}',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Completed\nTrips',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  getExpence() async {
    final tripdata =
        await DatabaseHelper.instance.getOngoingtripId(widget.userInfo['id']);
    final exp = await DatabaseHelper.instance.getExpences(tripdata['userid']);
 final result=   await DatabaseHelper.instance.readUpcomingTrips(widget.userInfo['id']);
 final finish =await DatabaseHelper.instance.readCompletedTrip(widget.userInfo['id']);
    setState(() {
     finished =finish.length;
      upcoming=result.length;
      widget.tripdata=tripdata;
      
    });
      if (exp != null) {
    final expMapList = exp.toList(); // Convert the QueryResultSet to a List<Map<String, dynamic>>
    if (expMapList.isNotEmpty) {
      setState(() {
        widget.expensedata = expMapList.first; // Assuming you want to use the first item in the list
      });
    }
  }
    

    print(tripdata);
    print('*****');
    print(exp);
  }

  double _calculateTotalExpenses(List<Map<String, dynamic>> expenses) {
    double totalExpenses = 0.0;
    for (var expense in expenses) {
      totalExpenses +=
          double.parse(expense[DatabaseHelper.ColumnExpence] as String);
    }
    return totalExpenses;
  }
}
