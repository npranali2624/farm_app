import 'package:farmer_app/presentation/pages/widgets/header_card.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClearAllFiltersPage extends StatefulWidget {
  const ClearAllFiltersPage({super.key});

  @override
  State<ClearAllFiltersPage> createState() => _ClearAllFiltersPageState();
}

class _ClearAllFiltersPageState extends State<ClearAllFiltersPage> {
  final Color primaryColor = const Color(0xFF1B5E20);
  final Color accentColor = const Color(0xFFFF6F00);
  final Color backgroundColor = const Color(0xFFFAFAFA);

  int selectedIndex = 0;

  late Future<List<Map<String, dynamic>>> futureUsers;

  String fullName(Map<String, dynamic> u) {
    return [
      u["fname"],
      u["mname"],
      u["lname"],
    ].where((e) => e != null && e.toString().isNotEmpty).join(" ");
  }

  @override
  void initState() {
    super.initState();
    futureUsers = UserApiService.getAllUsers();
  }

  void loadUsers() {
    setState(() {
      if (selectedIndex == 0) {
        futureUsers = UserApiService.getAllUsers();
      } else if (selectedIndex == 1) {
        futureUsers = UserApiService.getUsersByRole("farmer");
      } else {
        futureUsers = UserApiService.getUsersByRole("supplier");
      }
    });
  }

  Widget buildCard(String title, String role) {
    final bool isFarmer = role.toLowerCase() == "farmer";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (isFarmer ? accentColor : primaryColor).withOpacity(
            0.15,
          ),
          child: Icon(
            isFarmer ? Icons.agriculture : Icons.badge,
            color: isFarmer ? accentColor : primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        subtitle: Text(
          role,
          style: TextStyle(color: isFarmer ? accentColor : primaryColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget buildTabButton(String title, int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedIndex = index;
          loadUsers();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            ///  HEADER CARD
            headerCard(
              title: "Filter Results",
              icon: Icons.arrow_back,
              onIconPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

            /// TABS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    buildTabButton("All", 0),
                    buildTabButton("Farmer", 1),
                    buildTabButton("Supplier", 2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LIST
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1B5E20),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final users = snapshot.data ?? [];

                  if (users.isEmpty) {
                    return const Center(child: Text("No users found"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final name = fullName(user);

                      return buildCard(
                        name.isNotEmpty ? name : "No Name",
                        user["role"] ?? "",
                      );
                    },
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