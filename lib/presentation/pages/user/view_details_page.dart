import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewDetailsPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  const ViewDetailsPage({super.key, required this.userData});

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color bgLight = Color(0xFFF4FBF6);

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      return DateFormat("dd MMM yyyy")
          .format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  String fullName() {
    return "${userData['fname'] ?? ''} "
        "${userData['mname'] ?? ''} "
        "${userData['lname'] ?? ''}".trim();
  }

  /// CONSISTENT HEADER
  Widget header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 20,
        left: 12,
        right: 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF66BB6A),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [

          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const Text(
            "Profile Details",
            style: TextStyle(
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

  /// PROFILE CARD
  Widget profileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryGreen, lightGreen],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [

          const CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Icon(Icons.person,
                size: 42, color: primaryGreen),
          ),

          const SizedBox(height: 12),

          Text(
            fullName(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            (userData["role"] ?? "Farmer").toString().toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  /// SINGLE DETAIL TILE
  Widget detailTile(
      IconData icon,
      String label,
      String value,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(.08),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: primaryGreen),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty ? "-" : value,
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgLight,
      body: Column(
        children: [

          header(context),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [

                  profileCard(),

                  const SizedBox(height: 20),

                  detailTile(
                    Icons.person_outline,
                    "First Name",
                    userData["fname"] ?? "",
                  ),

                  detailTile(
                    Icons.person_outline,
                    "Middle Name",
                    userData["mname"] ?? "",
                  ),

                  detailTile(
                    Icons.person_outline,
                    "Last Name",
                    userData["lname"] ?? "",
                  ),

                  detailTile(
                    Icons.badge_outlined,
                    "Role",
                    userData["role"] ?? "",
                  ),

                  detailTile(
                    Icons.wc,
                    "Gender",
                    userData["gender"] ?? "",
                  ),

                  detailTile(
                    Icons.calendar_month,
                    "Date of Birth",
                    formatDate(userData["dob"]),
                  ),

                  detailTile(
                    Icons.phone,
                    "Mobile",
                    userData["mobile"] ?? "",
                  ),

                  detailTile(
                    Icons.location_on_outlined,
                    "Address",
                    userData["address"] ?? "",
                  ),

                  detailTile(
                    Icons.markunread_mailbox,
                    "Pincode",
                    userData["pincode"] ?? "",
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}