class Meal {
  String name;
  DateTime date;
  bool isDelete;
  double calory;
  String image;

  Meal({
    required this.name,
    required this.date,
    required this.isDelete,
    required this.calory,
    required this.image,
  });

  factory Meal.fromMap(Map meal) {
    return Meal(
      name: meal["name"],
      date: meal["date"],
      isDelete: meal["isDelete"],
      calory: meal["calory"],
      image: meal["image"],
    );
  }

  Map toMap() {
    return {
      "image": image,
      "name": name,
      "date": date,
      "isDelete": isDelete,
      "calory": calory
    };
  }
}
