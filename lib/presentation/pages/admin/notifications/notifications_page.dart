import 'package:farmer_app/presentation/pages/admin/farmer/farmer_detail_page.dart';
import 'package:farmer_app/presentation/pages/admin/supplier/supplier_details_page.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/services/user_api_service.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<Map<String, dynamic>> farmers = [];
  List<Map<String, dynamic>> suppliers = [];

  final Color primaryColor = const Color(0xFF1B5E20);
  final Color secondaryColor = const Color(0xFF66BB6A);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final allUsers = await UserApiService.getAllUsers();

      // Only keep users with pending verification
      final pendingUsers = allUsers.where((user) =>
      user['otp_verified'] == false || user['physical_verified'] == false
      ).toList();

      setState(() {
        farmers = pendingUsers
            .where((u) => u['role']?.toString().toLowerCase() == 'farmer')
            .toList();
        suppliers = pendingUsers
            .where((u) => u['role']?.toString().toLowerCase() == 'supplier')
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching users: $e")),
      );
    }
  }

  Widget buildUserList(List<Map<String, dynamic>> users, String role) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (users.isEmpty) {
      return Center(
        child: Text(
          "No $role pending verification",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final name =
        "${user['fname'] ?? ''} ${user['mname'] ?? ''} ${user['lname'] ?? ''}".trim();

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? "Unknown" : name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Show OTP Verification Pending
                if (user['otp_verified'] == false)
                  Row(
                    children: const [
                      Icon(Icons.sms, size: 18, color: Colors.deepOrange),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "OTP Verification Pending",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (user['otp_verified'] == false)
                  const SizedBox(height: 4),

                // Show Physical Verification Pending
                if (user['physical_verified'] == false)
                  Row(
                    children: const [
                      Icon(Icons.verified_user, size: 18, color: Colors.deepOrange),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Physical Verification Pending",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Gradient AppBar with back button and centered title (size same as before)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const Center(
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tabs below AppBar
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(text: "Farmers"),
              Tab(text: "Suppliers"),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildUserList(farmers, "farmer"),
                buildUserList(suppliers, "supplier"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}