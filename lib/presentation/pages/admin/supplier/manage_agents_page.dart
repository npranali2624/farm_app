import 'package:farmer_app/presentation/pages/admin/supplier/supplier_details_page.dart';
import 'package:farmer_app/presentation/pages/widgets/header_card.dart';
import 'package:farmer_app/services/user_api_service.dart';
import 'package:flutter/material.dart';

class ManageAgentsPage extends StatefulWidget {
  const ManageAgentsPage({super.key});

  @override
  State<ManageAgentsPage> createState() => _ManageAgentsPageState();
}

class _ManageAgentsPageState extends State<ManageAgentsPage> {

  late Future<List<Map<String, dynamic>>> suppliersFuture;

  @override
  void initState() {
    super.initState();
    suppliersFuture = UserApiService.getUsersByRole("supplier");
  }

  String getFullName(Map<String, dynamic> user) {
    final fname = user["fname"] ?? "";
    final mname = user["mname"] ?? "";
    final lname = user["lname"] ?? "";

    return [fname, mname, lname]
        .where((e) => e.toString().trim().isNotEmpty)
        .join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Column(
        children: [

          headerCard(
            title: "Suppliers",
            icon: Icons.arrow_back,
            onIconPressed: () => Navigator.pop(context),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: suppliersFuture,
              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                final suppliers = snapshot.data ?? [];

                if (suppliers.isEmpty) {
                  return const Center(
                    child: Text("No supplier found"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) {

                    final supplier = suppliers[index];

                    final fullName = getFullName(supplier);
                    final mobile = supplier["mobile"] ?? "";

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(

                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SupplierDetailsPage(userId : supplier["_id"]),
                            ),
                          );
                        },

                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.green.shade700,
                          child: Text(
                            fullName.isNotEmpty
                                ? fullName[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        title: Text(
                          fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            mobile,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}