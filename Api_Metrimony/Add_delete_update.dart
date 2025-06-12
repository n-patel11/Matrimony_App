import 'package:demo2/Api_Metrimony/Api_bottemnavigationbar.dart';
import 'package:demo2/Api_Metrimony/Api_server.dart';
import 'package:flutter/material.dart';

class AddEditUserPage extends StatefulWidget {
  final Map? userMap;

  AddEditUserPage({super.key, this.userMap});

  @override
  State<AddEditUserPage> createState() => _AddEditUserPageState();
}

class _AddEditUserPageState extends State<AddEditUserPage> {
  final GlobalKey<FormState> _validationKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _favoriteController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _castController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  List<String> cities = ['Ahmedabad', 'Surat', 'Rajkot', 'Vadodara'];
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  List<String> hobbiesList = [
    'Reading',
    'Traveling',
    'Cooking',
    'Sports',
    'Music'
  ];

  List<String> selectedHobbies = [];
  String? selectedCity;
  String? selectedGender;
  bool _isObscured = true;
  String dobError = "";

  @override
  @override
  void initState() {
    super.initState();
    if (widget.userMap != null) {
      _nameController.text = widget.userMap!['Column_name'] ?? '';
      _favoriteController.text = widget.userMap!['Column_favorite'].toString();
      _dobController.text = widget.userMap!['Column_dob'] ?? '';
      _ageController.text = widget.userMap!['Column_age'] ?? '';
      _emailController.text = widget.userMap!['Column_email'] ?? '';
      _phoneController.text = widget.userMap!['Column_phone'] ?? '';
      _heightController.text = widget.userMap!['Column_height'] ?? '';
      _weightController.text = widget.userMap!['Column_weight'] ?? '';
      _castController.text = widget.userMap!['Column_cast'] ?? '';
      _passwordController.text = widget.userMap!['Column_password'] ?? '';
      _confirmPasswordController.text =
          widget.userMap!['Column_conformpass'] ?? '';

      selectedCity = cities.contains(widget.userMap!['Column_city'])
          ? widget.userMap!['Column_city']
          : null;
      selectedGender = genderOptions.contains(widget.userMap!['Column_gender'])
          ? widget.userMap!['Column_gender']
          : null;
      selectedHobbies = widget.userMap!['Column_hobbies']?.split(',') ?? [];
    }
  }

  void selectDateOfBirth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      int calculatedAge = calculateAge(pickedDate);
      setState(() {
        if (calculatedAge < 18) {
          dobError = "You must be at least 18 years old to register.";
          _dobController.clear();
          _ageController.clear();
        } else {
          dobError = "";
          _dobController.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          _ageController.text = "$calculatedAge years";
        }
      });
    }
  }

  int calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  Widget buildDateField(
      String label, TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => selectDateOfBirth(context),
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Select your Date of Birth' : null,
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text, // ✅ Correct default value
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _isObscured : false,
        keyboardType: keyboardType,
        // ✅ Assign keyboard type correctly
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    if (value.length > 15) {
      return "Name must be at most 50 characters";
    }
    if (!RegExp(r"^[a-zA-Z\s'-]{3,50}$").hasMatch(value)) {
      return "Invalid characters. Only letters, spaces, hyphens (-), and apostrophes (') are allowed.";
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    if (!RegExp(r"^[0-9]{10,15}$").hasMatch(value)) {
      return "Enter a valid 10-15 digit mobile number";
    }
    return null;
  }

  String? emailValidator(String? value) {
    final emailRegExp =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (value == null || value.trim().isEmpty) {
      return 'Enter a valid email address.';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? heightvalidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your height'; // Validation error message
    }
    return null; // No error
  }

  String? weightvalidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your weight'; // Validation error message
    }
    return null; // No error
  }

  String? castvalidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your cast'; // Validation error message
    }
    return null; // No error
  }

  String? passwordvalidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter password'; // Validation error message
    }
    return null; // No error
  }

  String? confirmpasswordvalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? dobValidator(String? value) {
    final dobRegExp =
        RegExp(r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$");
    if (value == null || value.trim().isEmpty) {
      return 'Enter your Date of Birth.';
    } else if (!dobRegExp.hasMatch(value)) {
      return 'Enter a valid Date of Birth (DD/MM/YYYY).';
    }

    List<String> parts = value.split('/');
    DateTime dob =
        DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    int age = calculateAge(dob);
    if (age < 18) {
      return 'You must be at least 18 years old to register.';
    } else if (age > 80) {
      return 'Age must not exceed 80 years.';
    }
    return null;
  }

  Widget buildDropdown(String label, List<String> items, String? selectedItem,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: items.contains(selectedItem) ? selectedItem : null,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildMultiSelectHobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hobbies",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10,
          children: hobbiesList.map((hobby) {
            bool isSelected = selectedHobbies.contains(hobby);
            return FilterChip(
              label: Text(hobby),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedHobbies.add(hobby);
                  } else {
                    selectedHobbies.remove(hobby);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void submitForm() async {
    if (_validationKey.currentState!.validate()) {
      Map<String, dynamic> userMap = {
        'Column_name': _nameController.text,
        'Column_favorite': _favoriteController.text,
        'Column_dob': _dobController.text,
        'Column_age': _ageController.text,
        'Column_email': _emailController.text,
        'Column_phone': _phoneController.text,
        'Column_gender': selectedGender,
        'Column_city': selectedCity,
        'Column_height': _heightController.text,
        'Column_weight': _weightController.text,
        'Column_cast': _castController.text,
        'Column_hobbies': selectedHobbies.join(','),
        'Column_password': _passwordController.text,
        'Column_conformpass': _confirmPasswordController.text,
      };

      if (widget.userMap != null) {
        await ApiService().updateUser(
          map: userMap,
          context: context,
          Column_userid: widget.userMap!['Column_userid'],
        );
      } else {
        await ApiService().addUser(map: userMap, context: context);
      }

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit User')),
      body: Form(
        key: _validationKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              buildTextField(
                'Name',
                _nameController,
                validator: nameValidator,
                keyboardType: TextInputType.name,
              ),
              buildDropdown('Gender', genderOptions, selectedGender,
                  (val) => setState(() => selectedGender = val)),
              buildTextField(
                'Phone',
                _phoneController,
                validator: phoneValidator,
                keyboardType: TextInputType.phone,
              ),
              buildTextField('Email', _emailController,
                  validator: emailValidator),
              buildDateField('Date of Birth', _dobController, context),
              buildTextField(
                'Age',
                _ageController,
              ),
              buildDropdown('City', cities, selectedCity,
                  (val) => setState(() => selectedCity = val)),
              buildTextField('Height', _heightController,
                  validator: heightvalidator,
                  keyboardType: TextInputType.phone),
              buildTextField('Weight', _weightController,
                  validator: weightvalidator,
                  keyboardType: TextInputType.phone),
              buildTextField('Cast', _castController,
                  validator: castvalidator, keyboardType: TextInputType.name),
              buildMultiSelectHobbies(),
              buildTextField('Password', _passwordController,
                  isPassword: true, validator: passwordvalidator),
              buildTextField('Confirm Password', _confirmPasswordController,
                  isPassword: true, validator: confirmpasswordvalidator),
              ElevatedButton(onPressed: submitForm, child: Text('SUBMIT')),
            ],
          ),
        ),
      ),
    );
  }
}
