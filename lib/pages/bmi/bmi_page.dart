import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  _BmiPageState();
  late double _deviceHeight, _deviceWidth;
  int currentIndex = 0;
  double? _height, _weight;
  double? result;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.amberAccent,
        //   toolbarHeight: _deviceHeight * 0.10,
        //   title: const Text(
        //     "MyDiet",
        //     style: TextStyle(
        //         fontSize: 25,
        //         color: Colors.white,
        //         fontWeight: FontWeight.w500,
        //         letterSpacing: 3.0),
        //   ),
        // ),
        // drawer: Drawer(
        //   child: ListView(
        //     // Important: Remove any padding from the ListView.
        //     padding: EdgeInsets.zero,
        //     children: [
        //       const DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Colors.amberAccent,
        //         ),
        //         child: Text('Drawer Header'),
        //       ),
        //       ListTile(
        //         title: const Text("Update Profile"),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //       ListTile(
        //         title: const Text("My Bmi"),
        //         onTap: () {
        //           // Update the state of the app.
        //           Navigator.pushReplacementNamed(context, '/bmi');
        //         },
        //       ),
        //       ListTile(
        //         title: const Text('Add food'),
        //         onTap: () {
        //           // Update the state of the app.
        //           Navigator.pushReplacementNamed(context, '/route');
        //         },
        //       ),
        //       ListTile(
        //         title: const Text('Add health status'),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //       ListTile(
        //         title: const Text('Dashboard'),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //       ListTile(
        //         title: const Text('Logout'),
        //         onTap: () {
        //           // Navigate to login screen
        //           Navigator.pushReplacementNamed(context, '/signin');
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    radioButton("Man", Colors.amberAccent, 0),
                    radioButton("Woman", Colors.pink, 1)
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Your height in 'Cm'",
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onChanged: (_value) {
                    setState(() {
                      _height = double.tryParse(_value);
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Your weight in 'Kg'",
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onChanged: (_value) {
                    setState(() {
                      _weight = double.tryParse(_value);
                    });
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 55.0,
                  child: TextButton(
                    onPressed: () {
                      calculateBmi(_height, _weight);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amberAccent)),
                    child: Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Text(
                    "Your BMI is :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  child: Text(
                    "${result != null ? result : ""}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
        )),
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Custom widget
  Widget radioButton(String value, Color color, int index) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      height: 80.0,
      child: TextButton(
          onPressed: () {
            changeIndex(index);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  currentIndex == index ? color : Colors.grey[200]),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)))),
          child: Text(
            value,
            style: TextStyle(
              color: currentIndex == index ? Colors.white : color,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          )),
    ));
  }

  void calculateBmi(double? height, double? weight) {
    double finalResult = weight! / (height! * height! / 1000);
    String bmi = finalResult.toStringAsFixed(2);
    setState(() {
      result = double.tryParse(bmi);
    });
  }
}
