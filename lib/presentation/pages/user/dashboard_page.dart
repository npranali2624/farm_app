import 'package:farmer_app/presentation/pages/landing_page.dart';
import 'package:farmer_app/presentation/pages/user/view_details_page.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color primaryGreen = Color(0xFF1B5E20);
  Map<String, dynamic> user = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  bool isVerified = false;

  Widget headerCard({
  required String title,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(
      top: 50,   // space for status bar
      bottom: 18,
      left: 8,
      right: 8,
    ),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF1B5E20),
          Color(0xFF2E7D32),
          Color(0xFF66BB6A),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(22),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [

        /// MENU BUTTON (LEFT)
        Align(
          alignment: Alignment.centerLeft,
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),

        /// CENTER TITLE (PERFECTLY CENTERED)
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),

      ],
    ),
  );
}

  Future<void> fetchUser() async {
    try {
      final userData = await UserApiService.getUserById(widget.userId);
      setState(() {
        user = userData;
        isVerified =
            user["physical_verified"] == true; // or any flag from backend
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching user: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    // backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${user['fname']} ${user['lname']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: primaryGreen),
              title: const Text("View Details"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewDetailsPage(userData: user)),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LandingPage()));
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                headerCard(title: "Dashboard"), // rectangular header

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${user['fname']} ${user['lname']}👋",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(
                                  isVerified
                                      ? Icons.verified
                                      : Icons.pending_actions,
                                  color: isVerified
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 40,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  isVerified
                                      ? "Account Verified"
                                      : "Verification Pending",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isVerified
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isVerified)
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Add New Product",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        else
                          const Center(
                            child: Text(
                              "Your account is under review. Once verified, you can add products.",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
