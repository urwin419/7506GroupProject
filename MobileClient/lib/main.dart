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

void main() => runApp(const MyApp());

const serverUrl = '10.0.2.2:5000';
const List<String> meals = <String>["Breakfast", "Lunch", "Dinner"];
const List<String> exes = <String>["Jogging", "Crunches", "Push-ups"];
var token = '';

Future<List<ExeRecord>> fetchExe() async {
  var url = Uri.http(serverUrl, '/get_exe', {'token': token});
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ExeRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<MealRecord>> fetchMeal() async {
  var url = Uri.http(serverUrl, '/get_meal', {'token': token});
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => MealRecord.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<WeightRecord>> fetchWeight() async {
  var url = Uri.http(serverUrl, '/get_wei', {'token': token});
  final response = await http.get(url);
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
    return MaterialApp(
      title: _title,
      initialRoute: '/home',
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
        backgroundColor: Colors.blueAccent,
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
        padding: const EdgeInsets.all(16.0),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: const TextStyle(
                color: Colors.blueAccent,
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
                color: Colors.blueAccent,
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
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: _submit,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
    );
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
        backgroundColor: Colors.blueAccent,
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
        padding: const EdgeInsets.all(16.0),
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
                color: Colors.blueAccent,
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
                color: Colors.blueAccent,
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
                color: Colors.blueAccent,
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
              backgroundColor: Colors.blueAccent,
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
                  weidialog(context);
                  break;
                case 'record meal':
                  mealdialog(context, selectedMeal, meals);
                  break;
                case 'record exercise':
                  exedialog(context, selectedexe, exes);
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
