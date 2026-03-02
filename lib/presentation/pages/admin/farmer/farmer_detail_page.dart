import 'package:farmer_app/presentation/pages/admin/farmer/farmer_verification_page.dart';
import 'package:farmer_app/presentation/pages/auth/otp_verification_page.dart';
import 'package:farmer_app/presentation/pages/widgets/header_card.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerDetailPage extends StatelessWidget {
  final String userId;

  const FarmerDetailPage({super.key, required this.userId});

  String fullName(Map<String, dynamic> u) {
    return [
      u["fname"],
      u["mname"],
      u["lname"],
    ].where((e) => e != null && e.toString().isNotEmpty).join(" ");
  }

  String formatDate(String? date) {
    if (date == null) return "";
    final d = DateTime.parse(date);
    return DateFormat("dd MMM yyyy").format(d);
  }

  Widget infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green.shade50,
            child: Icon(icon, color: Colors.green.shade700, size: 20),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget verificationActions(BuildContext context, Map<String, dynamic> user) {
    final otpVerified = user["otp_verified"] == true;
    final physicalVerified = user["physical_verified"] == true;

    if (otpVerified && physicalVerified) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.12), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verification Actions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          if (!otpVerified)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sms, color: Colors.white),
                label: const Text(
                  "Verify OTP",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OtpVerificationPage(mobile: user["mobile"]),
                    ),
                  );

                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("OTP verified"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // refresh page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FarmerDetailPage(userId: userId),
                      ),
                    );
                  }
                },
              ),
            ),

          if (!otpVerified) const SizedBox(height: 10),

          if (!physicalVerified)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.verified_user, color: Colors.white),
                label: const Text(
                  "Mark Physical Verification",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FarmerVerificationPage(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Physical verification marked"),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Column(
        children: [
          headerCard(
            title: "Farmer Details",
            icon: Icons.arrow_back,
            onIconPressed: () => Navigator.pop(context),
          ),

          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: UserApiService.getUserById(userId),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final user = snapshot.data!;
                final name = fullName(user);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      /// PROFILE CARD
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.green.shade700,
                              child: Text(
                                name.isNotEmpty ? name[0] : "?",
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              user["role"].toString().toUpperCase(),
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (user["otp_verified"] == true)
                                  statusChip("OTP Verified"),

                                if (user["otp_verified"] == true &&
                                    user["physical_verified"] == true)
                                  const SizedBox(width: 8),

                                if (user["physical_verified"] == true)
                                  statusChip("Physical Verified"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      verificationActions(context, user),

                      const SizedBox(height: 18),

                      infoTile(Icons.phone, "Mobile", user["mobile"] ?? ""),
                      infoTile(
                        Icons.location_on,
                        "Address",
                        user["address"] ?? "",
                      ),
                      infoTile(
                        Icons.pin_drop,
                        "Pincode",
                        user["pincode"] ?? "",
                      ),
                      infoTile(Icons.person, "Gender", user["gender"] ?? ""),
                      // infoTile(
                      //   Icons.badge,
                      //   "License ID",
                      //   user["licenseId"] ?? "",
                      // ),
                      infoTile(
                        Icons.cake,
                        "Date of Birth",
                        formatDate(user["dob"]),
                      ),
                      infoTile(
                        Icons.info,
                        "Account Status",
                        user["status"] ?? "",
                      ),
                      infoTile(
                        Icons.calendar_today,
                        "Created",
                        formatDate(user["createdAt"]),
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
