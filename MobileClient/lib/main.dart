// ignore_for_file: unused_import, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_project/exerecord.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'mealrecord.dart';
import 'weightrecord.dart';
import 'package:http/http.dart' as http;
import 'package:group_project/dialogs.dart';
import 'recview.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

void main() => runApp(const MyApp());

const serverUrl = '20.163.246.224:8080';
const List<String> meals = <String>["Breakfast", "Lunch", "Dinner"];
const List<String> exes = <String>["Jogging", "Crunches", "Push-ups"];
var token = '';

Future<List<ExeRecord>> fetchExe() async {
  var url = Uri.http(serverUrl, '/get_exe', {'token': token});
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)["data"];
    return jsonResponse.map((data) => ExeRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<MealRecord>> fetchMeal() async {
  var url = Uri.http(serverUrl, '/get_meal', {'token': token});
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)["data"];
    return jsonResponse.map((data) => MealRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<WeightRecord>> fetchWeight() async {
  var url = Uri.http(serverUrl, '/get_wei', {'token': token});
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)["data"];
    return jsonResponse.map((data) => WeightRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<String> fetchAnalysis() async {
  var url = Uri.http(serverUrl, '/get_chat', {'token': token});
  Map<String, String>? userHeader = {'Connection': 'Keep-Alive'};
  final response = await http.get(url, headers: userHeader);
  if (response.statusCode == 200) {
    String report =
        json.decode(response.body)["data"]["choices"][0]["text"].substring(1);
    return report;
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const MyStatefulWidget(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

showAutoHideAlertDialog(BuildContext context, List<String> texts) {
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    content: SizedBox(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 10),
          Text(texts[0],
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(texts[1],
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 8,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
      return WillPopScope(
        onWillPop: () async => false,
        child: alert,
      );
    },
  );
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _password;
  bool _isLoading = false;

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });

      var response = await http.post(Uri.http(serverUrl, '/post_login'),
          body: {'username': _username, 'password': _password});

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['status'] == 1) {
          token = data['token'];
          if (kDebugMode) {
            print(response.body);
          }
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showAutoHideAlertDialog(context,
              ["Authentication failed", "Incorrect username or password"]);
        }
      } else {
        showAutoHideAlertDialog(
            context, ["Authentication failed", "Server unavailable now"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(64.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
        key: _formKey,
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Username is required' : null,
                  onSaved: (value) => _username = value!.trim(),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Password is required' : null,
                  onChanged: (value) => _password = value.trim(),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          )
        ]));
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _password, _confirmPassword;
  bool _isLoading = false;

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });

      // Password validation
      if (_password != _confirmPassword) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Passwords do not match.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      } else if (_password.length < 8) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Password is too weak. Passwords must be at least 8 characters long.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      var response = await http.post(
        Uri.http(serverUrl, '/post_register'),
        body: {'username': _username, 'password': _password},
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['status'] == 1) {
          token = data['token'];
          if (kDebugMode) {
            print(response.body);
          }
          Navigator.pushReplacementNamed(context, '/home');
        } else if (data['status'] == 2) {
          showAutoHideAlertDialog(
              context, ["Registration failed", "Username already used"]);
        } else {
          showAutoHideAlertDialog(
              context, ["Registration failed", "Invalid username or password"]);
        }
      } else {
        showAutoHideAlertDialog(
            context, ["Authentication failed", "Server unavailable now"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(64.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _buildRegisterForm(),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Username is required' : null,
            onChanged: (value) => _username = value.trim(),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a password.';
              } else if (value.length < 8) {
                return 'Password is too weak. Passwords must be at least 8 characters long.';
              } else if (value == _username) {
                return 'Password cannot be the same as username.';
              } else if (value != _confirmPassword) {
                return 'Passwords do not match.';
              }
              return null;
            },
            onChanged: (value) => _password = value.trim(),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password.';
              } else if (value != _password) {
                return 'Passwords do not match.';
              }
              return null;
            },
            onChanged: (value) => _confirmPassword = value.trim(),
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: _submit,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'REGISTER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String selectedMeal = meals.first;
  String selectedexe = exes.first;
  int _selectedIndex = 0;
  String _operation = 'record weight';
  bool _isLoading = false;

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
  final List<String> entries3 = <String>['profile', 'logout'];

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
      padding: const EdgeInsets.all(16),
      itemCount: entries1.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("assets/images/login.png"),
                fit: BoxFit.cover,
              ),
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            width: double.infinity,
            height: 120.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Feather.plus_circle,
                    color: Colors.black,
                    size: 40.0,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    ' ${entries1[index]}',
                    textScaleFactor: 2,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            updateText(entries1[index]);
            switch (_operation) {
              case 'record weight':
                weidialog(context);
                break;
              case 'record meal':
                mealdialog(context, selectedMeal, meals);
                break;
              case 'record exercise':
                exedialog(context, selectedexe, exes);
                break;
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 16,
      ),
    );
  }

  Widget _past() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries2.length,
            itemBuilder: (BuildContext context, int index) {
              IconData icon;
              switch (entries2[index]) {
                case 'weight records':
                  icon = Icons.scale;
                  break;
                case 'meal records':
                  icon = Icons.fastfood;
                  break;
                case 'exercise records':
                  icon = Icons.fitness_center;
                  break;
                default:
                  icon = Icons.category;
                  break;
              }
              return GestureDetector(
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
                        MaterialPageRoute(
                            builder: (context) => const MealRec()),
                      );
                      break;
                    case 'exercise records':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExeRec()),
                      );
                      break;
                  }
                },
                child: Container(
                  width: 200.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/login.png"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.black,
                        size: 40.0,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        ' ${entries2[index]}',
                        textScaleFactor: 2,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(48.0),
          child: SizedBox(
            width: 76.0,
            height: 76.0,
            child: ClipOval(
              child: Material(
                color: Colors.black,
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: () {},
                  child: _aiAnalysis(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _aiAnalysis() {
    return IconButton(
      icon: const Icon(Icons.analytics, color: Colors.white, size: 48.0),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        final result = await fetchAnalysis();
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (_) => SingleChildScrollView(
            child: AlertDialog(
              title: const Text('AI Report'),
              content: Text(result),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profile() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries3.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: 200.0,
          height: 120.0,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/login.png"),
              fit: BoxFit.cover,
            ),
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              if (index == 1) {
                Navigator.pushReplacementNamed(context, '/');
                token = "";
              }
            },
            child: Center(
              child: Text(
                ' ${entries3[index]}',
                textScaleFactor: 2,
                style: TextStyle(
                  color: index == 1 ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: children[_selectedIndex],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
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
