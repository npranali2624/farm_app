import 'package:farmer_app/services/auth_api_service.dart';
import 'package:flutter/material.dart';

class OtpVerificationPage extends StatefulWidget {
  final String mobile;

  const OtpVerificationPage({super.key, required this.mobile});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const Color primaryGreen = Color(0xFF1B5E20);

  final otpController = TextEditingController();

  bool loading = false;

  InputDecoration box(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryGreen),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen, width: 2),
      ),
    );
  }

  Widget headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.verified_user, color: Colors.white, size: 32),

          SizedBox(height: 10),

          Text(
            "OTP Verification",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future verifyOtp() async {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter OTP")));
      return;
    }

    setState(() => loading = true);

    try {
      final res = await AuthApiService.verifyOtp(
        mobile: widget.mobile,
        otp: otpController.text.trim(),
      );

      if (res["success"] == true) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP verified successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // ignore: use_build_context_synchronously
        Navigator.pop(context, true); // return success
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res["message"])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          headerCard(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        const Text(
                          "Enter OTP sent to",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          widget.mobile,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: box("Enter OTP", Icons.lock),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),

                            onPressed: () {
                              if (!loading) {
                                verifyOtp();
                              }
                            },

                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Verify OTP",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
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
    );
  }
}
