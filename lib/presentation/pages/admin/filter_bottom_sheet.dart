import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedIndex = 0;
  int? selectedOption;

  final List<String> leftMenu = [
    "Verification",
    "Status",
    "User",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5E9),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [

          /// TOP HEADER
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 20),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Filters",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 22),
                )
              ],
            ),
          ),

          /// MAIN BODY
          Expanded(
            child: Row(
              children: [

                /// LEFT SIDEBAR
                Container(
                  width: 135,
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
                        bool isSelected =
                            selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              selectedOption = null;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.transparent,
                              border: isSelected
                                  ? const Border(
                                left: BorderSide(
                                  color: Color(0xFF1B5E20),
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
                                    ? const Color(0xFF1B5E20)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                /// RIGHT PANEL
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.only(
                        topLeft: Radius.circular(22),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              leftMenu[selectedIndex],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOption = null;
                                });
                              },
                              child: const Text(
                                "Clear",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 30),

                        Column(
                          children: List.generate(
                              _options().length, (index) {
                            bool isSelected =
                                selectedOption == index;

                            return Padding(
                              padding:
                              const EdgeInsets.only(bottom: 18),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOption = index;
                                  });
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF1B5E20)
                                        : Colors.grey.shade100,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF1B5E20)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    _options()[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          /// BOTTOM BUTTON AREA
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 22, vertical: 20),
            color: const Color(0xFFF3F6FA),
            child: Row(
              children: [

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                      selectedOption = null;
                    });
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

                Container(
                  height: 52,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1B5E20),
                        Color(0xFF43A047),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Show Result",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<String> _options() {
    if (selectedIndex == 0) {
      return ["OTP Verification", "Physical"];
    } else if (selectedIndex == 1) {
      return ["Pending", "Approved"];
    } else {
      return ["Farmer", "supplier", "All"];
    }
  }
}