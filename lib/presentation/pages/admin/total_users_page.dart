import 'package:flutter/material.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:farmer_app/presentation/pages/admin/admin_dashboard.dart';

class TotalUsersPage extends StatefulWidget
{
  const TotalUsersPage({super.key});
  @override
  State<TotalUsersPage> createState() => _TotalUsersPageState();
}

class _TotalUsersPageState extends State<TotalUsersPage>
{
  late Future<List<Map<String, dynamic>>> futureUsers;
  @override
  void initState()
  {
    super.initState();
    futureUsers = UserApiService.getAllUsers();
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
                    "Total Users",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureUsers,
              builder: (context, snapshot)
              {
                if (snapshot.connectionState == ConnectionState.waiting)
                {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError)
                {
                  return Center(
                      child: Text("Error: ${snapshot.error.toString()}"));
                }
                final users = snapshot.data ?? [];
                final int farmersCount =
                    users.where((u) => u['role'] == 'farmer').length;
                final int suppliersCount =
                    users.where((u) => u['role'] == 'supplier').length;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// TOTAL FARMERS BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () {},
                          child: Text(
                            "Total Farmers: $farmersCount",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// TOTAL SUPPLIERS BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () {},
                          child: Text(
                            "Total Suppliers: $suppliersCount",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}