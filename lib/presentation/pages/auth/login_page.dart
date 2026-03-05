import 'package:farmer_app/presentation/pages/user/dashboard_page.dart';
import 'package:farmer_app/presentation/pages/admin/admin_dashboard.dart';
import 'package:farmer_app/presentation/pages/auth/registration_page.dart';
import 'package:farmer_app/presentation/pages/widgets/header_card.dart';
import 'package:farmer_app/services/auth_api_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  final String? mobile;
  final String? password;

  const LoginPage({super.key, this.mobile, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false;

  static const Color primaryGreen = Color(0xFF1B5E20);

  @override
  void initState() {
    super.initState();

    if (widget.mobile != null) {
      mobileController.text = widget.mobile!;
    }

    if (widget.password != null) {
      passwordController.text = widget.password!;
    }
  }

  /// LOGIN FUNCTION
  Future<Map<String, dynamic>?> performLogin() async {

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return null;
    }

    final loginData = {
      "mobile": mobileController.text.trim(),
      "password": passwordController.text,
    };

    try {

      final response = await AuthApiService.loginUser(loginData);

      if (response["success"] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Login failed")),
        );
        return null;
      }

      return response["data"];

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );

      return null;
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: primaryGreen),
      )

          : Column(
        children: [

          headerCard(title: "Login"),

          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      buildMobileField(),

                      buildPasswordField(),

                      const SizedBox(height: 35),

                      buildLoginButton(),

                      const SizedBox(height: 20),

                      buildRegisterText(),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// LOGIN BUTTON
  Widget buildLoginButton() {

    return SizedBox(
      width: 280,
      height: 50,

      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),

          onPressed: () async {

            setState(() {
              isLoading = true;
            });

            final userData = await performLogin();

            setState(() {
              isLoading = false;
            });

            if (userData == null) return;

            String role = userData["role"];
            String userId = userData["_id"];

            debugPrint("Logged User Role: $role");

            /// ROLE BASED NAVIGATION
            if (role == "admin") {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminDashboardPage(),
                ),
              );

            } else {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(userId: userId),
                ),
              );
            }
          },

          child: const Text(
            "Login",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// REGISTER TEXT
  Widget buildRegisterText() {

    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",

        style: const TextStyle(
          color: primaryGreen,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),

        children: [

          TextSpan(
            text: "Register",
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),

            recognizer: TapGestureRecognizer()
              ..onTap = () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrationPage(),
                  ),
                );

              },
          ),
        ],
      ),
    );
  }

  /// MOBILE FIELD
  Widget buildMobileField() {

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),

      child: TextFormField(
        controller: mobileController,

        keyboardType: TextInputType.phone,
        cursorColor: primaryGreen,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],

        decoration: InputDecoration(

          contentPadding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 18),

          prefixIcon:
          const Icon(Icons.phone_android, color: primaryGreen),

          labelText: "Mobile Number",

          labelStyle:
          const TextStyle(color: primaryGreen, fontSize: 17),

          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: primaryGreen, width: 2),

            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),

            borderRadius: BorderRadius.circular(12),
          ),
        ),

        validator: (value) {

          if (value == null || value.isEmpty) {
            return "Mobile number is required";
          }

          if (value.length != 10) {
            return "Enter valid 10-digit mobile number";
          }

          return null;
        },
      ),
    );
  }

  /// PASSWORD FIELD
  Widget buildPasswordField() {

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),

      child: TextFormField(
        controller: passwordController,

        obscureText: _obscurePassword,

        cursorColor: primaryGreen,

        decoration: InputDecoration(

          contentPadding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 18),

          prefixIcon:
          const Icon(Icons.lock_outline, color: primaryGreen),

          labelText: "Password",

          labelStyle:
          const TextStyle(color: primaryGreen, fontSize: 17),

          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: primaryGreen, width: 2),

            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),

            borderRadius: BorderRadius.circular(12),
          ),

          suffixIcon: IconButton(

            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,

              color: primaryGreen,
            ),

            onPressed: () {

              setState(() {
                _obscurePassword = !_obscurePassword;
              });

            },
          ),
        ),

        validator: (value) {

          if (value == null || value.isEmpty) {
            return "Password is required";
          }

          return null;
        },
      ),
    );
  }
}