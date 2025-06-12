import 'package:flutter/material.dart';
import 'package:demo2/Api_Metrimony/Add_delete_update.dart';
import 'package:demo2/Api_Metrimony/Api_server.dart';

class ApiFavorite extends StatefulWidget {
  const ApiFavorite({super.key});

  @override
  State<ApiFavorite> createState() => _ApiFavoriteState();
}

class _ApiFavoriteState extends State<ApiFavorite> {
  List<Map<String, dynamic>> favoriteUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  ApiService? dbRef;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = ApiService();
    getFavoriteUsers();
  }

  Future<void> getFavoriteUsers() async {
    try {
      List<dynamic> users = await dbRef!.getUsers(context);
      setState(() {
        favoriteUsers = users
            .where((user) =>
        user is Map<String, dynamic> &&
            user['Column_favorite'] == 1 &&
            user['Column_userid'] != null &&
            user['Column_name'] != null)
            .cast<Map<String, dynamic>>()
            .toList();
        filteredUsers = favoriteUsers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching users: ${e.toString()}")),
      );
    }
  }

  void _searchUsers(String query) {
    setState(() {
      filteredUsers = favoriteUsers.where((user) {
        String name = user['Column_name']?.toString().toLowerCase() ?? '';
        String city = user['Column_city']?.toString().toLowerCase() ?? '';
        String gender = user['Column_gender']?.toString().toLowerCase() ?? '';

        return name.contains(query.toLowerCase()) ||
            city.contains(query.toLowerCase()) ||
            gender.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Users")),
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
            // Search Bar
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
              child: filteredUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (_, index) {
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                const Icon(Icons.person, color: Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  filteredUsers[index]['Column_name'] ?? "No Name",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  filteredUsers[index]['Column_gender'] == "Male"
                                      ? Icons.male
                                      : Icons.female,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  filteredUsers[index]['Column_gender'] ?? "Not Defined",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(thickness: 1, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Edit Button
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () async {
                                    bool? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditUserPage(
                                          userMap: filteredUsers[index],
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      getFavoriteUsers();
                                    }
                                  },
                                ),

                                // Delete Button
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Confirm Delete"),
                                        content: const Text(
                                            "Are you sure you want to delete this user?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Delete",
                                                style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmDelete == true) {
                                      bool isDeleted = await dbRef!.deleteUser(
                                        Column_userid:
                                        filteredUsers[index]['Column_userid'],
                                        context: context,
                                      );

                                      if (isDeleted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content:
                                              Text("User deleted successfully")),
                                        );
                                        getFavoriteUsers();
                                      }
                                    }
                                  },
                                ),

                                // Favorite Toggle Button
                                IconButton(
                                  icon: Icon(
                                    (filteredUsers[index]['Column_favorite'] == 1)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                    (filteredUsers[index]['Column_favorite'] == 1)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    int newFavorite =
                                    (filteredUsers[index]['Column_favorite'] == 1)
                                        ? 0
                                        : 1;

                                    if (dbRef != null) {
                                      bool updated = await dbRef!.favoriteUser(
                                        Column_userid:
                                        filteredUsers[index]['Column_userid'],
                                        isFavorite: newFavorite == 1,
                                        context: context,
                                      );

                                      if (updated) {
                                        setState(() {
                                          if (newFavorite == 1) {
                                            filteredUsers[index]['Column_favorite'] =
                                                newFavorite;
                                          } else {
                                            filteredUsers.removeAt(index);
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  "No Favorite Users Found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
