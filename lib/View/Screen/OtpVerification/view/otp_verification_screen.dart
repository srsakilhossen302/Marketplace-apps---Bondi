import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../Controller/otp_verification_controller.dart';

class OtpVerificationScreen extends GetView<OtpVerificationController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1F4FB0).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFF1F4FB0).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFF1F4FB0).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img_1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        
                        // App Logo
                        SvgPicture.asset(
                          AppIcons.appLogo,
                          width: 160,
                          placeholderBuilder: (BuildContext context) => const Text(
                            'bondi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Check Your Inbox Text
                        const Text(
                          'Check Your Inbox',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        Text(
                          "We've sent a 6-digit verification code to your email. Please enter it below to activate your account.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // OTP Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2558A8).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // OTP Input
                              Pinput(
                                controller: controller.otpController,
                                focusNode: controller.focusNode,
                                length: 6,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                showCursor: true,
                                onCompleted: (pin) => controller.verifyOtp(pin),
                              ),
                              
                              const SizedBox(height: 25),
                              
                              // Resend Code Text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't receive a code? ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.resendCode();
                                    },
                                    child: const Text(
                                      'Resend',
                                      style: TextStyle(
                                        color: Color(0xFF00E5FF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Verify Button
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF003399),
                                          Color(0xFF0044CC),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () => controller.verifyOtp(controller.otpController.text),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                        ),
                                      ),
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : const Text(
                                              'Verify',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
