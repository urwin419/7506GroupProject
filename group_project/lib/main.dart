import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => MyStatefulWidget(),
        '/register': (context) => RegisterPage(),
      },
      //home: MyStatefulWidget(),
    );
  }
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

      var response = await http.post(
          Uri.parse('http://16.162.25.221:8080/post_login'),
          body: {'username': _username, 'password': _password});

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message
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
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading ? CircularProgressIndicator() : _buildLoginForm(),
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
            onSaved: (value) => _password = value!.trim(),
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
                  child: Text('OK'),
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
        Uri.parse('http://16.162.25.221:8080/post_register'),
        body: {'username': _username, 'password': _password},
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message
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
          child:
              _isLoading ? CircularProgressIndicator() : _buildRegisterForm(),
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
              primary: Colors.blueAccent,
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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
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
                          title: const Text('Login'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      icon: Icon(Icons.account_box),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: weightController,
                                    decoration: const InputDecoration(
                                      labelText: 'Weight',
                                      icon: Icon(Icons.email),
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
                                // Send them to your email maybe?
                                var date = dateController.text;
                                var weight = weightController.text;
                                if (kDebugMode) {
                                  print(date);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('Send'),
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
                          title: const Text('Login'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      icon: Icon(Icons.account_box),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Time',
                                      icon: Icon(Icons.email),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: mealController,
                                    decoration: const InputDecoration(
                                      labelText: 'Meal',
                                      icon: Icon(Icons.email),
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
                                // Send them to your email maybe?
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
