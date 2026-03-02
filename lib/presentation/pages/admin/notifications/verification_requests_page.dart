import 'package:flutter/material.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:farmer_app/presentation/pages/admin/admin_dashboard.dart';

class VerificationRequestsPage extends StatefulWidget
{
  const VerificationRequestsPage({super.key});
  @override
  State<VerificationRequestsPage> createState() =>
      _VerificationRequestsPageState();
}

class _VerificationRequestsPageState extends State<VerificationRequestsPage>
    with SingleTickerProviderStateMixin
{
  late Future<List<Map<String, dynamic>>> futureUsers;
  late TabController _tabController;
  @override
  void initState()
  {
    super.initState();
    futureUsers = UserApiService.getAllUsers();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose()
  {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> filterPendingByRole(
      List<Map<String, dynamic>> users, String role)
  {
    return users
        .where((u) => u['role'] == role && u['status'] == 'pending')
        .toList();
  }
  String getName(Map user)
  {
    return "${user['fname']} ${user['lname']}";
  }
  @override
  Widget build(BuildContext context)
  {
    final Color primaryColor = const Color(0xFF1B5E20);
    final Color secondaryColor = const Color(0xFF66BB6A);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminDashboardPage()),
                      );
                    },
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  ),
                ),

                /// TITLE
                const Center(
                  child: Text(
                    "Verification Requests",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          /// TABS FOR FARMERS / SUPPLIERS
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(text: "Farmers"),
              Tab(text: "Suppliers"),
            ],
          ),

          /// TAB CONTENT
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error.toString()}"));
                }

                final users = snapshot.data ?? [];

                return TabBarView(
                  controller: _tabController,
                  children: [
                    /// FARMERS PENDING
                    buildPendingList(
                        filterPendingByRole(users, "farmer"), "farmer"),

                    /// SUPPLIERS PENDING
                    buildPendingList(
                        filterPendingByRole(users, "supplier"), "supplier"),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPendingList(List<Map<String, dynamic>> users, String role) {
    if (users.isEmpty) {
      return const Center(child: Text("No pending requests"));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final name = getName(user);

        return ListTile(
          leading: const Icon(Icons.pending_actions, color: Colors.orange),
          title: Text("$role Verification Pending"),
          subtitle: Text("$name needs approval"),
        );
      },
    );
  }
}