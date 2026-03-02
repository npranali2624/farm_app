import 'package:farmer_app/presentation/pages/auth/login_page.dart';
import 'package:farmer_app/services/auth_api_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();

  String? role;
  String? gender;

  DateTime? dob;

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  TextEditingController fname = TextEditingController();
  TextEditingController mname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  static const Color primaryGreen = Color(0xFF1B5E20);

  //for date of birth
  Future pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        dob = date;
      });
    }
  }

  //Success msg
  void showSuccessPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              "User Registered Successfully",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Separate function to handle registration logic
  Future<String?> performRegistration() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return null;
    }

    if (dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date of birth")),
      );
      return null;
    }

    // Prepare registration data
    Map<String, dynamic> registrationData = {
      "role": role?.toLowerCase() ?? "farmer",
      "fname": fname.text.trim(),
      "mname": mname.text.trim(),
      "lname": lname.text.trim(),
      "gender": gender?.toLowerCase(),
      "dob": dob!.toIso8601String().split("T")[0], // yyyy-mm-dd
      "mobile": mobile.text.trim(),
      "password": password.text,
      "address": address.text.trim(),
      "pincode": pincode.text.trim(),
      "licenseId": "LIC-123456",
    };

    if (role?.toLowerCase() == "supplier") {
      registrationData["licenseId"] = "PENDING";
    }

    // Submit registration
    Map<String, dynamic> response;
    try {
      response = await AuthApiService.registerUser(registrationData);
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Registration failed: $e")));
      return null;
    }

    // Check server response
    if (response["success"] != true) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Registration failed")),
      );
      return null;
    }

    // Extract user ID
    final userData = response["data"];
    final userId = userData["_id"];
    debugPrint("Registered User ID: $userId");

    // Show success popup
    showSuccessPopup();

    return userId;
  }

  //field designs
  InputDecoration box(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primaryGreen),
      prefixIcon: Icon(icon, color: primaryGreen),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen, width: 2),
      ),
    );
  }

  //Title
  Widget headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Text(
            "Registration",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : Form(
              key: formKey,
              child: Column(
                children: [
                  headerCard(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          DropdownButtonFormField(
                            decoration: box("Select Role", Icons.person),
                            initialValue: role,
                            items: ["Farmer", "Supplier"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              role = v.toString();
                            },
                            validator: (v) => v == null ? "Select Role" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: fname,
                            decoration: box("First Name", Icons.person),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: mname,
                            decoration: box(
                              "Middle Name",
                              Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: lname,
                            decoration: box("Last Name", Icons.person),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField(
                            decoration: box("Gender", Icons.wc),
                            initialValue: gender,
                            items: ["Male", "Female", "Other"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              gender = v.toString();
                            },
                          ),
                          const SizedBox(height: 12),

                          //DOB
                          GestureDetector(
                            onTap: pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: primaryGreen,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    dob == null
                                        ? "Select DOB"
                                        : DateFormat("dd-MM-yyyy").format(dob!),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: mobile,
                            decoration: box("Mobile Number", Icons.phone),
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.length != 10) {
                                return "Enter 10 digit mobile";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: password,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              hoverColor: Colors.green,
                              labelText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: primaryGreen,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryGreen,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                v!.length < 6 ? "Min 6 characters" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: confirmPassword,
                            obscureText: !showConfirmPassword,
                            decoration: InputDecoration(
                              hoverColor: Colors.green,
                              labelText: "Confirm Password",
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: primaryGreen,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showConfirmPassword = !showConfirmPassword;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryGreen,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v != password.text) {
                                return "Password not matching";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: address,
                            maxLines: 3,
                            decoration: box("Address", Icons.home),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: pincode,
                            keyboardType: TextInputType.number,
                            decoration: box("Pincode", Icons.pin),
                            validator: (v) =>
                                v!.length != 6 ? "Enter 6 digit pincode" : null,
                          ),
                          const SizedBox(height: 30),

                          //register button
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
                              onPressed: () async {
                                setState(() {
                                  isLoading = false;
                                });
                                String? userId = await performRegistration();

                                if (userId == null) return;

                                Navigator.pushReplacement(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginPage(
                                      mobile: mobile.text.trim(),
                                      password: password.text,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //Account text
                          RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                color: primaryGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: const TextStyle(
                                    decoration: TextDecoration
                                        .underline, // Underline the word
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginPage(
                                            mobile: mobile.text.trim(),
                                            password: password.text,
                                          ),
                                        ),
                                      );
                                    },
                                ),
                              ],
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
