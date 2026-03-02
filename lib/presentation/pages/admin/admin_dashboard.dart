import 'package:flutter/material.dart';
import 'package:farmer_app/presentation/pages/admin/supplier/manage_agents_page.dart';
import 'package:farmer_app/presentation/pages/admin/farmer/manage_famers_page.dart';
import 'package:farmer_app/presentation/pages/admin/notifications/notifications_page.dart';
import 'package:farmer_app/presentation/pages/landing_page.dart';
import 'package:farmer_app/presentation/pages/admin/filter_bottom_sheet.dart';
import 'total_users_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  final Color primaryColor = const Color(0xFF1B5E20);
  final Color accentColor = const Color(0xFFFF6F00);
  final Color backgroundColor = const Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      /// DRAWER
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Admin",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading:
                const Icon(Icons.notifications, color: Colors.orange),
                title: const Text("Notifications"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.people, color: Colors.green),
                title: const Text("Total Users"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TotalUsersPage(),
                    ),
                  );
                },
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style:
                      TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LandingPage()),
                            (route) => false,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// BODY
      body: Builder(
        builder: (context) => Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 35, horizontal: 15),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () =>
                          Scaffold.of(context).openDrawer(),
                      child: const Icon(Icons.menu,
                          color: Colors.white, size: 28),
                    ),
                  ),

                  const Center(
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// FILTER ICON
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        final result =
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor:
                          Colors.transparent,
                          builder: (context) {
                            return const FilterBottomSheet();
                          },
                        );

                        if (result != null) {
                          print(result);
                        }
                      },
                      child: const Icon(Icons.filter_list,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
            ),

            /// BODY CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.admin_panel_settings,
                        size: 90, color: Color(0xFF1B5E20)),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome Admin",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Color(0xFFFF6F00),
                        ),
                        icon: const Icon(Icons.agriculture,
                            color: Colors.white),
                        label: const Text("Manage Farmers",
                            style:
                            TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                const ManageFarmersPage()),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Color(0xFF1B5E20),
                        ),
                        icon: const Icon(Icons.badge,
                            color: Colors.white),
                        label: const Text("Manage Suppliers",
                            style:
                            TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                const ManageAgentsPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}