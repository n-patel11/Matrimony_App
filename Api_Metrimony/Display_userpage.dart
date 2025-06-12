import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo2/Api_Metrimony/Login_screen.dart';
import 'package:demo2/Api_Metrimony/Add_delete_update.dart';
import 'package:demo2/Api_Metrimony/Api_server.dart';
import 'package:demo2/Api_Metrimony/Api_userdetaile.dart';

class DisplayUserPage extends StatefulWidget {
  const DisplayUserPage({super.key});

  @override
  State<DisplayUserPage> createState() => _DisplayUserPageState();
}

class _DisplayUserPageState extends State<DisplayUserPage> {
  ApiService api = ApiService();
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  String? username;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchUsers();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> _fetchUsers() async {
    try {
      List<dynamic> users = await api.getUsers(context);
      setState(() {
        allUsers = List<Map<String, dynamic>>.from(users);
        filteredUsers = allUsers;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _searchUsers(String query) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        String name = user['Column_name']?.toString().toLowerCase() ?? '';
        String city = user['Column_city']?.toString().toLowerCase() ?? '';
        String gender = user['Column_gender']?.toString().toLowerCase() ?? '';

        return name.contains(query.toLowerCase()) ||
            city.contains(query.toLowerCase()) ||
            gender.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sortUsers(String criteria) {
    setState(() {
      if (criteria == "Alphabetical (A-Z)") {
        filteredUsers.sort((a, b) =>
            a['Column_name'].toString().compareTo(b['Column_name'].toString()));
      } else if (criteria == "Youngest to Oldest") {
        filteredUsers.sort((a, b) =>
            int.parse(a['Column_age'].toString()).compareTo(int.parse(b['Column_age'].toString())));
      } else if (criteria == "Oldest to Youngest") {
        filteredUsers.sort((a, b) =>
            int.parse(b['Column_age'].toString()).compareTo(int.parse(a['Column_age'].toString())));
      } else if (criteria == "Gender (Female First)") {
        filteredUsers.sort((a, b) =>
            a['Column_gender'].toString().compareTo(b['Column_gender'].toString()));
      } else if (criteria == "Gender (Male First)") {
        filteredUsers.sort((a, b) =>
            b['Column_gender'].toString().compareTo(a['Column_gender'].toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List", style: TextStyle(color: Colors.black)),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortUsers,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "Alphabetical (A-Z)", child: Text("Sort A-Z")),
              const PopupMenuItem(value: "Youngest to Oldest", child: Text("Sort: Youngest → Oldest")),
              const PopupMenuItem(value: "Oldest to Youngest", child: Text("Sort: Oldest → Youngest")),
              const PopupMenuItem(value: "Gender (Male First)", child: Text("Sort: Male First")),
              const PopupMenuItem(value: "Gender (Female First)", child: Text("Sort: Female First")),
            ],
            icon: const Icon(Icons.sort, color: Colors.black),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username ?? 'Guest'),
              accountEmail: const Text(" "),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.pink.shade200),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFA88CE5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: _searchUsers,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                ),
              ),
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(
                child: Text(
                  'No Users Found',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> user = filteredUsers[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['Column_gender'] == 'Male'
                            ? AssetImage('assets/img_4.png')
                            : AssetImage('assets/img_5.png'),
                      ),
                      title: Text(
                        user['Column_name'].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                          '${user['Column_city'] ?? 'No city'}\n${user['Column_gender'] ?? 'No Gender'}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ApiUserdetaile(userMap: user),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => AddEditUserPage(userMap: user),
                              ))
                                  .then((_) => _fetchUsers());
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                          ),
                          IconButton(
                            onPressed: () async {
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: const Text("Are you sure you want to delete this user?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete == true) {
                                await api.deleteUser(
                                  Column_userid: user['Column_userid'],
                                  context: context,
                                );
                                _fetchUsers();
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                          ),
                          IconButton(
                            icon: Icon(
                              user['Column_favorite'] == 1
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: user['Column_favorite'] == 1 ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              int newFavorite = user['Column_favorite'] == 0 ? 1 : 0;
                              await api.favoriteUser(
                                Column_userid: user['Column_userid'].toString(),
                                isFavorite: newFavorite == 1,
                                context: context,
                              );
                               setState(() {
                                user['Column_favorite'] = newFavorite;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


























// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:demo2/Api_Metrimony/Login_screen.dart';
// import 'package:demo2/Api_Metrimony/Add_delete_update.dart';
// import 'package:demo2/Api_Metrimony/Api_server.dart';
// import 'package:demo2/Api_Metrimony/Api_userdetaile.dart';
//
// class DisplayUserPage extends StatefulWidget {
//   const DisplayUserPage({super.key});
//
//   @override
//   State<DisplayUserPage> createState() => _DisplayUserPageState();
// }
//
// class _DisplayUserPageState extends State<DisplayUserPage> {
//   ApiService api = ApiService();
//   List<Map<String, dynamic>> allUsers = [];
//   List<Map<String, dynamic>> filteredUsers = [];
//   String? username;
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUsername();
//     _fetchUsers();
//     setState(() {
//
//     });
//   }
//
//   Future<void> _loadUsername() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       username = prefs.getString('username') ?? 'Guest';
//     });
//   }
//
//   Future<void> _fetchUsers() async {
//     try {
//       List<dynamic> users = await api.getUsers(context);
//       setState(() {
//         allUsers = List<Map<String, dynamic>>.from(users);
//         filteredUsers = allUsers;
//       });
//     } catch (e) {
//       print("Error fetching users: $e");
//     }
//   }
//
//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }
//
//   void _searchUsers(String query) {
//     setState(() {
//       filteredUsers = allUsers.where((user) {
//         String name = user['Column_name']?.toString().toLowerCase() ?? '';
//         String city = user['Column_city']?.toString().toLowerCase() ?? '';
//         String gender = user['Column_gender']?.toString().toLowerCase() ?? '';
//
//         return name.contains(query.toLowerCase()) ||
//             city.contains(query.toLowerCase()) ||
//             gender.contains(query.toLowerCase());
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("user List",style: TextStyle(color: Colors.black),),
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text(username ?? 'Guest'),
//               accountEmail: const Text(" "),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 50, color: Colors.pink.shade200),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text('Logout'),
//               onTap: _logout,
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFB3E5FC), Color(0xFFA88CE5)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: searchController,
//                 onChanged: _searchUsers,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                       color: Colors.deepPurpleAccent,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: filteredUsers.isEmpty
//                   ? const Center(
//                 child: Text(
//                   'No Users Found',
//                   style: TextStyle(fontSize: 20, color: Colors.grey),
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: filteredUsers.length,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> user = filteredUsers[index];
//
//                   return Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: user['Column_gender'] == 'Male'
//                             ? AssetImage('assets/img_4.png')
//                             : AssetImage('assets/img_5.png'),
//                       ),
//                       title: Text(
//                         user['Column_name'].toString(),
//                         style: const TextStyle(fontSize: 20),
//                       ),
//                       subtitle: Text(
//                           '${user['Column_city'] ?? 'No city'}\n${user['Column_gender'] ?? 'No Gender'}'),
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => ApiUserdetaile(userMap: user),
//                           ),
//                         );
//                       },
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .push(MaterialPageRoute(
//                                 builder: (context) => AddEditUserPage(userMap: user),
//                               ))
//                                   .then((_) => _fetchUsers());
//                             },
//                             icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               bool confirmDelete = await showDialog(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: const Text("Confirm Delete"),
//                                   content: const Text("Are you sure you want to delete this user?"),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context, false),
//                                       child: const Text("Cancel"),
//                                     ),
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context, true),
//                                       child: const Text("Delete", style: TextStyle(color: Colors.red)),
//                                     ),
//                                   ],
//                                 ),
//                               );
//
//                               if (confirmDelete == true) {
//                                 await api.deleteUser(
//                                   Column_userid: user['Column_userid'],
//                                   context: context,
//                                 );
//                                 _fetchUsers();
//                               }
//                             },
//                             icon: const Icon(Icons.delete, color: Colors.red, size: 25),
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               user['Column_favorite'] == 1
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: user['Column_favorite'] == 1 ? Colors.red : Colors.grey,
//                             ),
//                             onPressed: () async {
//                               int newFavorite = user['Column_favorite'] == 0 ? 1 : 0;
//                               await api.favoriteUser(
//                                 Column_userid: user['Column_userid'].toString(),
//                                 isFavorite: newFavorite == 1,
//                                 context: context,
//                               );
//                               setState(() {
//                                 user['Column_favorite'] = newFavorite;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }