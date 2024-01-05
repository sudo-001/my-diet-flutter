import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskly/models/meal.dart';
import 'package:date_field/date_field.dart';

class MealPage extends StatefulWidget {
  MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPage();
}

class _MealPage extends State<MealPage> {
  late double _deviceHeight, _deviceWidth;
  Box? _box;
  File? image;
  String _mealName = "";
  DateTime _date = new DateTime.now();

  double? _mealCalory;
  static const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

  String dropdownValue = list.first;
  _MealPage();

  @override
  void initState() {
    super.initState();
  }

  bool _homeState = true;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      print("image ${image.path}");
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: null,
      body: _MealsView(),
      // Floatting action button here
      floatingActionButton: _addMealButton(),
    );
  }

  Widget _MealsView() {
    return FutureBuilder(
      future: Hive.openBox("meals"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _MealsListView();
        } else {
          return const CircularProgressIndicator(
            color: Colors.amberAccent,
          );
        }
      },
    );
  }

  Widget _MealsListView() {
    // On recupère tout les éléments contenus dans notre box
    List meals = _box!.values.toList();
    meals = meals.reversed.toList();

    return ListView.builder(
        itemCount: meals.length,
        itemBuilder: (BuildContext _context, int _index) {
          var _meal = Meal.fromMap(meals[_index]);

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.file(
                  File(_meal.image),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                onTap: () => {
                  // Ouvrir le modal qui affiche les détails
                  print(_meal.name)
                },
                title: Text(
                  _meal.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_meal.date.toString().substring(0, 19)),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                        border: Border.all(width: 2.0),
                      ),
                      child: Text(
                        "${_meal.calory} Kcal",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          );
        });
  }

  Widget _addMealButton() {
    return FloatingActionButton(
      onPressed: _addMealFormPopup,
      backgroundColor: Colors.amberAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.add),
    );
  }

  void _addMealFormPopup() {
    // showDialog(BuildContext _context) {
    //   return AlertDialog(
    //     title: const Text("Add new meal"),
    //     content: ,
    //   );
    // };
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          // height: ,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                image != null
                    ? ClipOval(
                        child: Image.file(
                          image!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Image.asset("assets/images/appareil-photo.png"),
                SizedBox(height: 10),
                Column(
                  children: [
                    buildButton(
                        title: 'Pick Image',
                        icon: Icons.image_outlined,
                        onClicked: () => pickImage(ImageSource.gallery)),
                    SizedBox(height: 20),
                    buildButton(
                        title: 'Take a photo',
                        icon: Icons.camera_alt_outlined,
                        onClicked: () => pickImage(ImageSource.camera)),
                  ],
                ),
                SizedBox(height: 20),
                DateTimeField(
                  onDateSelected: (DateTime value) {
                    // print(value);
                    setState(() {
                      _date = value;
                    });
                  },
                  initialDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 1),
                  selectedDate: _date,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of the food",
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onChanged: (_value) {
                    setState(() {
                      _mealName = _value;
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
                    labelText: "Number of calories",
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onChanged: (_value) {
                    setState(() {
                      _mealCalory = double.tryParse(_value);
                    });
                  },
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          if (_mealName != '' && _mealCalory != null ||
                              _mealCalory != 0 && image != null) {
                            var meal = Meal(
                                image: image!.path,
                                name: _mealName,
                                date: _date,
                                calory: _mealCalory!,
                                isDelete: false);
                            _box!.add(meal.toMap());

                            setState(() {
                              _mealName = "";
                              _mealCalory = 0;
                              image = null;
                            });

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          image = null;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  buildButton(
          {required String title,
          required IconData icon,
          required VoidCallback onClicked}) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          textStyle: TextStyle(fontSize: 20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
        onPressed: onClicked,
      );
}
