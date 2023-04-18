// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_project/exerecord.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'mealrecord.dart';
import 'weightrecord.dart';
import 'package:http/http.dart' as http;
import 'package:group_project/dialogs.dart';
import 'recview.dart';

void main() => runApp(const MyApp());

const List<String> meals = <String>["Breakfast", "Lunch", "Dinner"];
const List<String> exes = <String>["Jogging", "Crunches", "Push-ups"];
var id = '1';

Future<List<ExeRecord>> fetchExe() async {
  var url = Uri.parse('http://10.0.2.2:5000//get_exe');
  final response = await http.post(url, body: {"id": id});
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ExeRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<MealRecord>> fetchMeal() async {
  var url = Uri.parse('http://10.0.2.2:5000//get_meal');
  final response = await http.post(url, body: {"id": id});
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => MealRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<WeightRecord>> fetchWeight() async {
  var url = Uri.parse('http://10.0.2.2:5000//get_wei');
  final response = await http.post(url, body: {"id": id});
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => WeightRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

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
  String selectedMeal = meals.first;
  String selectedexe = exes.first;
  int _selectedIndex = 0;
  String _operation = 'record weight';

  final List<String> entries1 = <String>[
    'record weight',
    'record meal',
    'record exercise'
  ];
  final List<String> entries2 = <String>[
    'weight records',
    'meal records',
    'exercise records'
  ];
  final List<String> entries3 = <String>['profile', 'settings'];

  void updateText(String text) {
    setState(() {
      _operation = text;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
                  weidialog(context, id);
                  break;
                case 'record meal':
                  mealdialog(context, id, selectedMeal, meals);
                  break;
                case 'record exercise':
                  exedialog(context, id, selectedexe, exes);
                  break;
              }
            });
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _past() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries2.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: 200.0,
              height: 100.0,
              color: Colors.amber[300],
              child: Center(child: Text(' ${entries2[index]}')),
            ),
            onTap: () {
              updateText(entries2[index]);
              switch (_operation) {
                case 'weight records':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeiRec()),
                  );
                  break;
                case 'meal records':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MealRec()),
                  );
                  break;
                case 'exercise records':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExeRec()),
                  );
                  break;
              }
            });
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

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
