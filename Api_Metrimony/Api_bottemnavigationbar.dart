import 'package:demo2/Api_Metrimony/Add_delete_update.dart';
import 'package:demo2/Api_Metrimony/Api_chart.dart';
import 'package:demo2/Api_Metrimony/Api_favorite.dart';
import 'package:demo2/Api_Metrimony/Display_userpage.dart';
import 'package:demo2/Database/Databse_about.dart';
import 'package:demo2/Database/Feedback_screen.dart';

import 'package:flutter/material.dart';

class ApiBottemnavigationbar extends StatefulWidget {
  ApiBottemnavigationbar({super.key});

  @override
  State<ApiBottemnavigationbar> createState() => _ApiBottemnavigationbarState();
}

class _ApiBottemnavigationbarState extends State<ApiBottemnavigationbar> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      DisplayUserPage(),
      ApiFavorite(),
      ApiChart(),
      DatabseAbout()
    ];

    return Scaffold(
      body: list[idx],

      // Bottom Navigation Bar with Custom UI
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(), // Creates the FAB notch
            notchMargin: 10.0, // Margin for FAB notch
            child: Container(
              height: 70, // Height of the BottomAppBar
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: idx == 0 ? Colors.purple : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        idx = 0;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: idx == 1 ? Colors.purple : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        idx = 1;
                      });
                    },
                  ),
                  SizedBox(width: 50), // Space for FAB
                  IconButton(
                    icon: Icon(
                      Icons.feedback,
                      color: idx == 2 ? Colors.purple : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        idx = 2;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info,
                      color: idx == 3 ? Colors.purple : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        idx = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Floating Action Button Positioned Correctly
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 11),
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Navigate to RagistationMetri screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditUserPage()),
            ).then(
              (value) {
                print('VALUE FROM PUSH ::: $value');
                setState(() {
                });
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiBottemnavigationbar(), // Your Bottom Navigation screen
    ),
  );
}
