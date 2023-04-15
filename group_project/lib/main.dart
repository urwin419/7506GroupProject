import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

const List<String> meals = <String>["Breakfast", "Lunch", "Dinner"];

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
  final List<int> colorCodes1 = <int>[600, 500, 100];
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
              color: Colors.blue,
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
                        var dateController = TextEditingController();
                        var weightController = TextEditingController();
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
                              onPressed: () {
                                var date = dateController.text;
                                var weight = weightController.text;
                                Navigator.pop(context);
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
                        var dateController = TextEditingController();
                        var timeController = TextEditingController();
                        var mealController = TextEditingController();
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
                              onPressed: () {
                                var date = dateController.text;
                                var time = timeController.text;
                                var meal = mealController.text;
                                Navigator.pop(context);
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
  final List<int> colorCodes2 = <int>[600, 500, 100];

  Widget _past() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries2.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.amber[colorCodes2[index]],
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
  final List<int> colorCodes3 = <int>[600, 500];

  Widget _profile() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries3.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.amber[colorCodes3[index]],
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
