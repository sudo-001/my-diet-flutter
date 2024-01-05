import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:taskly/models/user.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Box? _box;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    await Hive.openBox("user");
    _box = Hive.box("user");
  }

  @override
  Widget build(BuildContext context) {
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
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height,
                  //   decoration: BoxDecoration(
                  //     color: _isLoading == true
                  //         ? const Color.fromRGBO(255, 255, 255, 1)
                  //         : const Color.fromRGBO(255, 255, 255, 0),
                  //   ),
                  //   child: _isLoading == true
                  //       ? const Center(
                  //           child: CircularProgressIndicator(),
                  //         )
                  //       : Container(),
                  // ),
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
                        // padding: EdgeInsets.symmetric(vertical: 4.0),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: _isLoading == true
                                ? MaterialStateProperty.all(Colors.grey)
                                : MaterialStateProperty.all(
                                    Colors.amberAccent,
                                  ),
                          ),
                          onPressed: _isLoading == true
                              ? null
                              : () async {
                                  // On active le loading et on le montre
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  if (_emailController.text != "" &&
                                      _passwordController.text != "") {
                                    await Hive.openBox("user");
                                    List users = _box!.values.toList();
                                    // On vérifi si les crédentials sont corrects
                                    if (_emailController.text ==
                                            users[0]["email"] &&
                                        _passwordController.text ==
                                            users[0]["password"]) {
                                      // print("userssss $users");
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pushReplacementNamed(
                                          context, '/route');
                                    }
                                    await Hive.close();
                                  }
                                  // On redirige vers la home page

                                  // On commence les vérifications
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: _isLoading == true
                                    ? const CircularProgressIndicator()
                                    : null,
                              ),
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "New here ?",
                            style: TextStyle(
                              // color: Colors.white,
                              color: Color.fromRGBO(16, 23, 39, 1),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Create an account',
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
