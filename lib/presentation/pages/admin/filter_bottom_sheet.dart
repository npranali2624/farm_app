import 'package:farmer_app/presentation/pages/admin/filtration/clear_all_filters_page.dart';
import 'package:farmer_app/presentation/pages/admin/filtration/filter_result_page.dart';
import 'package:farmer_app/services/admin_api_service.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, String> initialFilters;

  const FilterBottomSheet({super.key, required this.initialFilters});
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedIndex = 0;
  bool isLoading = false;

  final List<String> leftMenu = ["Verification", "Status", "User"];

  late Map<String, String> selectedFilters;

  final Color primaryColor = const Color(0xFF1B5E20);
  final Color lightGreen = const Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();
    selectedFilters = Map.from(widget.initialFilters);
  }

  Future<List<Map<String, dynamic>>> applyFilters() async {
    String verification = selectedFilters["Verification"] ?? "OTP";
    String status = selectedFilters["Status"] ?? "Approved";
    String role = selectedFilters["User"] ?? "All";

    List<Map<String, dynamic>> finalUsers = [];

    try {
      setState(() => isLoading = true);

      if (verification == "Physical") {
        if (status == "Pending") {
          List<String> userIds =
          await AdminApiService.getPendingPhysicalVerificationUsers(
            role.toLowerCase(),
          );

          for (String id in userIds) {
            final user = await UserApiService.getUserById(id);
            finalUsers.add(user);
          }
        } else {
          List<Map<String, dynamic>> users;

          if (role == "All") {
            users = await UserApiService.getAllUsers();
          } else {
            users = await UserApiService.getUsersByRole(role);
          }

          finalUsers = users
              .where((user) => user["physical_verified"] == true)
              .toList();
        }
      } else {
        List<Map<String, dynamic>> users;

        if (role == "All") {
          users = await UserApiService.getAllUsers();
        } else {
          users = await UserApiService.getUsersByRole(role);
        }

        finalUsers = users.where((user) {
          bool otpVerified = user["otp_verified"] ?? false;

          if (status == "Pending") {
            return otpVerified == false;
          } else {
            return otpVerified == true;
          }
        }).toList();
      }

      return finalUsers;
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5E9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Filters",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 22),
                ),
              ],
            ),
          ),

          /// SELECTED FILTER CHIPS
          if (selectedFilters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedFilters.entries.map((entry) {
                  return Chip(
                    backgroundColor: primaryColor,
                    label: Text(
                      "${entry.key}: ${entry.value}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    onDeleted: () {
                      setState(() {
                        selectedFilters.remove(entry.key);
                      });
                    },
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 15),

          Expanded(
            child: Row(
              children: [
                /// LEFT SIDEBAR (UNCHANGED)
                Container(
                  width: 140,
                  color: const Color(0xFFF1F8F4),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Quick Filters",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      ...List.generate(leftMenu.length, (index) {
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? lightGreen
                                  : Colors.transparent,
                              border: isSelected
                                  ? Border(
                                left: BorderSide(
                                  color: primaryColor,
                                  width: 4,
                                ),
                              )
                                  : null,
                            ),
                            child: Text(
                              leftMenu[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? primaryColor
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                /// RIGHT PANEL (UNCHANGED)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              leftMenu[selectedIndex],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilters.remove(
                                    leftMenu[selectedIndex],
                                  );
                                });
                              },
                              child: const Text(
                                "Clear",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Column(
                          children: _options().map((option) {
                            bool isSelected =
                                selectedFilters[leftMenu[selectedIndex]] ==
                                    option;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFilters[leftMenu[selectedIndex]] =
                                        option;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM BUTTONS (GRADIENT + LOADING ADDED)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            color: const Color(0xFFF3F6FA),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilters.clear();
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const ClearAllFiltersPage()));
                  },
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: isLoading
                      ? null
                      : () async {
                    List<Map<String, dynamic>> results =
                    await applyFilters();
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (_) => FilterResultPage(
                          users: results,
                          appliedFilters: selectedFilters,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Show Result",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _options() {
    if (selectedIndex == 0) {
      return ["OTP", "Physical"];
    } else if (selectedIndex == 1) {
      return ["Pending", "Approved"];
    } else {
      return ["Farmer", "Agent", "All"];
    }
  }
}