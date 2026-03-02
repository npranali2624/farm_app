import 'package:flutter/material.dart';
import 'package:farmer_app/services/user_api_service.dart';

class NotificationsPage extends StatefulWidget
{
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
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

  String getName(Map user)
  {
    return "${user['fname']} ${user['lname']}";
  }

  List<Map<String, dynamic>> filterUsersByRole(
      List<Map<String, dynamic>> users, String role)
  {
    return users.where((u) => u['role'] == role).toList();
  }

  @override
  void dispose()
  {
    _tabController.dispose();
    super.dispose();
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
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                ),

                /// TITLE
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

          /// TABS FOR FARMER AND SUPPLIER
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
                if (snapshot.connectionState == ConnectionState.waiting)
                {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError)
                {
                  return Center(
                      child: Text("Error: ${snapshot.error.toString()}"));
                }
                final allUsers = snapshot.data ?? [];

                // Separate lists
                final farmers = filterUsersByRole(allUsers, "farmer");
                final suppliers = filterUsersByRole(allUsers, "supplier");
                return TabBarView(
                  controller: _tabController,
                  children: [
                    buildUserList(farmers, "farmer"),
                    buildUserList(suppliers, "supplier"),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// WIDGET TO BUILD USER LIST
  Widget buildUserList(List<Map<String, dynamic>> users, String role)
  {
    if (users.isEmpty)
    {
      return const Center(child: Text("No Notifications"));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index)
      {
        final user = users[index];
        final name = getName(user);

        String title;
        String subtitle;

        if (user['status'] == "pending")
        {
          title = "${user['role']} Verification Pending";
          subtitle = "$name needs approval";
        } else {
          title = "${user['role']} Approved";
          subtitle = "$name verified";
        }

        return ListTile(
          leading: const Icon(Icons.notifications, color: Colors.orange),
          title: Text(title),
          subtitle: Text(subtitle),
        );
      },
    );
  }
}