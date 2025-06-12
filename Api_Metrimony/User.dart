class User {
  String Column_userid;
  String Column_name;
  String Column_favorite;
  String Column_dob;
  String Column_age;
  String Column_email;
  String Column_phone;
  String Column_gender;
  String Column_city;
  String Column_height;
  String Column_wight;
  String Column_cast;
  String Column_hobbies;
  String Column_password;
  String Column_conformpass;

  User({
    required this.Column_userid,
    required this.Column_name,
    required this.Column_favorite,
    required this.Column_dob,
    required this.Column_age,
    required this.Column_email,
    required this.Column_phone,
    required this.Column_gender,
    required this.Column_city,
    required this.Column_height,
    required this.Column_wight,
    required this.Column_cast,
    required this.Column_hobbies,
    required this.Column_password,
    required this.Column_conformpass,
  });

  // Updated fromjson method to include all fields
  static User fromjson(Map<dynamic, dynamic> user) {
    return User(
      Column_userid: user["Column_userid"]?.toString() ?? "",
      Column_name: user["Column_name"]?.toString() ?? "",
      Column_favorite: user["Column_favorite"]?.toString() ?? "",
      Column_dob: user["Column_dob"]?.toString() ?? "",
      Column_age: user["Column_age"]?.toString() ?? "",
      Column_email: user["Column_email"]?.toString() ?? "",
      Column_phone: user["Column_phone"]?.toString() ?? "",
      Column_gender: user["Column_gender"]?.toString() ?? "",
      Column_city: user["Column_city"]?.toString() ?? "",
      Column_height: user["Column_height"]?.toString() ?? "",
      Column_wight: user["Column_wight"]?.toString() ?? "",
      Column_cast: user["Column_cast"]?.toString() ?? "",
      Column_hobbies: user["Column_hobbies"]?.toString() ?? "",
      Column_password: user["Column_password"]?.toString() ?? "",
      Column_conformpass: user["Column_conformpass"]?.toString() ?? "",
    );
  }

  // Updated tojson method to include all fields
  Map<String, dynamic> tojson() {
    return {
      "Column_userid": Column_userid,
      "Column_name": Column_name,
      "Column_favorite": Column_favorite,
      "Column_dob": Column_dob,
      "Column_age": Column_age,
      "Column_email": Column_email,
      "Column_phone": Column_phone,
      "Column_gender": Column_gender,
      "Column_city": Column_city,
      "Column_height": Column_height,
      "Column_wight": Column_wight,
      "Column_cast": Column_cast,
      "Column_hobbies": Column_hobbies,
      "Column_password": Column_password,
      "Column_conformpass": Column_conformpass,
    };
  }
}
