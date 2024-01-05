import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/user.dart';
import 'package:hive/hive.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late double _deviceHeight, _deviceWidth;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  // Box _box = Hive.box('user');
  Box? _box;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    // await Hive.initFlutter();
    await Hive.openBox("user");
    _box = Hive.box("user");
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Container(
                // color: const Color.fromRGBO(16, 23, 39, 1),
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: _isLoading == true
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(255, 255, 255, 0),
                    ),
                    child: _isLoading == true
                        ? Container(
                            height: _deviceHeight,
                            width: _deviceWidth,
                            decoration: BoxDecoration(color: Colors.black45),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ),
                  Column(
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   // color: Colors.red,
                      //   // width: MediaQuery.of(context).size.width,
                      //   child: Image.asset(
                      //     'assets/images/splash1.png',
                      //     width: 200,
                      //     height: 200,
                      //   ),
                      // ),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          // color: Colors.white,
                          color: Color.fromRGBO(16, 23, 39, 1),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(
                          // color: Colors.white,
                          color: Color.fromRGBO(16, 23, 39, 1),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your Email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(
                          // color: Colors.white,
                          color: Color.fromRGBO(16, 23, 39, 1),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your password";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15.0),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.amberAccent,
                            ),
                          ),
                          onPressed: () async {
                            print(
                                "${_emailController.text}, ${_passwordController.text}");
                            // On vérifi si tout est okay
                            if (_emailController.text != '' &&
                                _passwordController.text != '') {
                              await Hive.openBox("user");
                              var user = Users(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text);
                              print(user.toMap());

                              _box!.put("user", user.toMap());
                              await Hive.close();

                              Navigator.pushReplacementNamed(
                                  context, '/signin');
                            }

                            setState(() {
                              _isLoading = true;
                            });
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              // color: Colors.white,
                              color: Color.fromRGBO(16, 23, 39, 1),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signin');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
