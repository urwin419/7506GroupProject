import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'mealrecord.dart';
import 'weightrecord.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

const List<String> meals = <String>["Breakfast", "Lunch", "Dinner"];
var id = '1';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String selectedValue = meals.first;
  int _selectedIndex = 0;
  final List<String> entries1 = <String>[
    'record weight',
    'record meal',
    'record exercise'
  ];
  String _operation = 'record weight';
  void updateText(String text) {
    setState(() {
      _operation = text;
    });
  }

  Widget _record() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries1.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              color: Colors.red[300],
              width: 200.0,
              height: 100.0,
              child: Text(
                ' ${entries1[index]}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              updateText(entries1[index]);
              switch (_operation) {
                case 'record weight':
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        var dateController = TextEditingController(
                            text: DateFormat('yyyy-MM-dd')
                                .format(DateTime.now()));
                        var weightController =
                            TextEditingController(text: '60.00');
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Record Weight'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      icon: Icon(Icons.today),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        setState(() {
                                          dateController.text = formattedDate;
                                        });
                                      } else {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now());
                                        setState(() {
                                          dateController.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    inputFormatters: [
                                      NumberTextInputFormatter(
                                        integerDigits: 4,
                                        decimalDigits: 2,
                                        maxValue: '1000.00',
                                        decimalSeparator: '.',
                                        groupDigits: 3,
                                        groupSeparator: ',',
                                        allowNegative: false,
                                        overrideDecimalPoint: true,
                                        insertDecimalPoint: false,
                                        insertDecimalDigits: true,
                                      ),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: weightController,
                                    textAlign: TextAlign.center,
                                    autovalidateMode: AutovalidateMode.always,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.monitor_weight),
                                      labelText: 'Weight',
                                      hintText: '0.0',
                                      suffixText: 'Kg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                var date = dateController.text;
                                var weight = weightController.text;
                                var record = WeightRecord(id, date, weight);
                                final String body = jsonEncode(record);
                                final url =
                                    Uri.parse('http://10.0.2.2:5000/rec_wei');
                                final response =
                                    await http.post(url, body: body);
                                if (response.statusCode == 201) {
                                  // ignore: use_build_context_synchronously
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: const Text('UPLOAD SUCCEED'),
                                      actions: <TextButton>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: Text(
                                          response.statusCode.toString() +
                                              body),
                                      actions: <TextButton>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        );
                      });
                  break;
                case 'record meal':
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        var dateController = TextEditingController(
                            text: DateFormat('yyyy-MM-dd')
                                .format(DateTime.now()));
                        var timeController =
                            TextEditingController(text: "00:00");
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Record Meal Time'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      icon: Icon(Icons.today),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        setState(() {
                                          dateController.text = formattedDate;
                                        });
                                      } else {
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now());
                                        setState(() {
                                          dateController.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Time',
                                      icon: Icon(Icons.schedule),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );

                                      if (pickedTime != null) {
                                        DateTime parsedTime = DateFormat.jm()
                                            // ignore: use_build_context_synchronously
                                            .parse(pickedTime
                                                .format(context)
                                                .toString());
                                        String formattedTime =
                                            DateFormat('HH:mm')
                                                .format(parsedTime);
                                        setState(() {
                                          timeController.text = formattedTime;
                                        });
                                      } else {
                                        DateTime parsedTime = DateFormat.jm()
                                            // ignore: use_build_context_synchronously
                                            .parse(TimeOfDay.now()
                                                .format(context)
                                                .toString());
                                        String formattedTime =
                                            DateFormat('HH:mm')
                                                .format(parsedTime);
                                        setState(() {
                                          timeController.text = formattedTime;
                                        });
                                      }
                                    },
                                  ),
                                  DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2),
                                      ),
                                      filled: true,
                                    ),
                                    value: selectedValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                    items: meals.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                var date = dateController.text;
                                var time = timeController.text;
                                var record =
                                    MealRecord(id, date, time, selectedValue);
                                final String body = jsonEncode(record);
                                final url =
                                    Uri.parse('http://10.0.2.2:8080/rec_meal');
                                final response =
                                    await http.post(url, body: body);
                                if (response.statusCode == 201) {
                                  // ignore: use_build_context_synchronously
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: const Text('UPLOAD SUCCEED'),
                                      actions: <TextButton>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: Text(
                                          response.statusCode.toString() +
                                              body),
                                      actions: <TextButton>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                // ignore: use_build_context_synchronously
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        );
                      });
                  break;
                case 'record exercise':
                  break;
              }
            });
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  final List<String> entries2 = <String>[
    'weight records',
    'meal records',
    'exercise records'
  ];
  Widget _past() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries2.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          width: 200.0,
          height: 100.0,
          color: Colors.amber[300],
          child: Center(child: Text(' ${entries2[index]}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> entries3 = <String>['profile', 'settings'];

  Widget _profile() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries3.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          width: 200.0,
          height: 100.0,
          color: Colors.blue[300],
          child: Center(child: Text(' ${entries3[index]}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      _record(),
      _past(),
      _profile(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecFit System'),
        backgroundColor: Colors.black,
      ),
      body: children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: 'Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Past',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onTabTapped,
      ),
    );
  }
}
