import 'package:flutter/material.dart';
import 'package:taskly/pages/bmi/bmi_page.dart';
import 'package:taskly/pages/meal/meal_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int currentPageIndex = 0;
  late double _deviceHeight, _deviceWidth;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        toolbarHeight: _deviceHeight * 0.10,
        title: const Text(
          "MyDiet",
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.amberAccent,
              ),
              child: Container(
                // decoration: BoxDecoration(color: Colors.red),
                child: const Center(
                    child: Column(
                  children: [
                    ClipOval(
                      child: Image(
                        image: AssetImage("assets/images/splash1.png"),
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text("Nom complet du user connecté")
                  ],
                )),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Update Profile"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate_rounded),
              title: const Text("My Bmi"),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  _currentIndex.value = 1;
                });
                Navigator.pop(context);
                // Navigator.pushNamed(context, "/bmi");
                // Navigator.pushReplacementNamed(context, '/bmi');
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank_rounded),
              title: const Text('Foods'),
              onTap: () {
                // Update the state of the app.
                // Navigator.pushNamed(context, '/route');
                setState(() {
                  _currentIndex.value = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety_rounded),
              title: const Text('Health and status'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              // Dashboard section
              leading: const Icon(Icons.show_chart_rounded),
              title: const Text('My progression'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('About'),
              onTap: () {
                // Navigate to login screen
                // Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              onTap: () {
                // Navigate to login screen
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex.value,
        children: [MealPage(), BmiPage()],
      ),
      // bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 10.0,
      currentIndex: _currentIndex.value,
      onTap: (int index) {
        setState(() {
          _currentIndex.value = index;
        });
      },
      // Style
      // backgroundColor: const Color.fromRGBO(35, 41, 56, 1),
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      // selectedIconTheme: const IconThemeData(color: Colors.white70),
      // unselectedIconTheme: const IconThemeData(color: Colors.white38),
      // selectedItemColor: Colors.white,
      selectedItemColor: Color.fromRGBO(35, 41, 56, 1),
      unselectedItemColor: Color.fromRGBO(75, 87, 117, 0.698),
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 2.0),
      // unselectedLabelStyle: const TextStyle(color: Colors.white38),
      // Items
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Meals'),
        BottomNavigationBarItem(
            icon: Icon(Icons.multiline_chart), label: 'BMI'),
      ],
    );
  }
}
