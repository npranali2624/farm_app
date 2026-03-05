import 'package:farmer_app/presentation/pages/widgets/header_card.dart';
import 'package:flutter/material.dart';// adjust path if needed

class FilterResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Map<String, String> appliedFilters;

  const FilterResultPage({
    super.key,
    required this.users,
    required this.appliedFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: headerCard(
              title: "Filter Results",
              icon: Icons.arrow_back,
              onIconPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Expanded(
            child: Column(
              children: [

                /// APPLIED FILTERS SECTION
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Applied Filters",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (appliedFilters.isEmpty)
                        const Text("No filters applied")
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                          appliedFilters.entries.map((entry) {
                            return Chip(
                              backgroundColor:
                              const Color(0xFF1B5E20),
                              label: Text(
                                "${entry.key}: ${entry.value}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 12),

                      Text(
                        "Total Users: ${users.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// RESULT LIST
                Expanded(
                  child: users.isEmpty
                      ? const Center(
                    child: Text(
                      "No users found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      /// 🔹 FULL NAME BUILDING
                      String fullName = [
                        user["fname"],
                        user["mname"],
                        user["lname"]
                      ]
                          .where((name) =>
                      name != null &&
                          name
                              .toString()
                              .trim()
                              .isNotEmpty)
                          .join(" ");

                      fullName = fullName.isEmpty
                          ? "Unknown"
                          : fullName;

                      String role =
                      (user["role"] ?? "N/A")
                          .toString();

                      bool otpVerified =
                          user["otp_verified"] ?? false;
                      bool physicalVerified =
                          user["physical_verified"] ??
                              false;

                      return Container(
                        margin:
                        const EdgeInsets.only(bottom: 14),
                        padding:
                        const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),
                              blurRadius: 6,
                              offset:
                              const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            /// NAME + ROLE
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    fullName,
                                    style:
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                        0xFFE8F5E9),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        20),
                                  ),
                                  child: Text(
                                    role,
                                    style:
                                    const TextStyle(
                                      color: Color(
                                          0xFF1B5E20),
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight
                                          .w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// VERIFICATION STATUS
                            Row(
                              children: [
                                _statusChip(
                                  label: "OTP",
                                  isVerified:
                                  otpVerified,
                                ),
                                const SizedBox(
                                    width: 10),
                                _statusChip(
                                  label: "Physical",
                                  isVerified:
                                  physicalVerified,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip({
    required String label,
    required bool isVerified,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.shade100
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: ${isVerified ? "Approved" : "Pending"}",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isVerified
              ? Colors.green.shade800
              : Colors.red.shade800,
        ),
      ),
    );
  }
}