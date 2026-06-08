import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../Controller/success_controller.dart';

class SuccessScreen extends GetView<SuccessController> {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    Get.put(SuccessController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // App Logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    'assets/icons/Component 5.svg',
                    width: 140,
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2558A8).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Illustration
                        SvgPicture.asset(
                          'assets/icons/Group 25.svg',
                          height: 180,
                        ),

                        const SizedBox(height: 30),

                        // Success Message
                        const Text(
                          "You're all set!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Your account is ready. Welcome to the Bond community.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF003399), Color(0xFF0044CC)],
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () => controller.navigateToNext(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Redirection Progress
                        Obx(
                          () => Column(
                            children: [
                              Text(
                                "Redirecting in ${controller.redirectingIn.value} seconds...",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: SizedBox(
                                  width: 120,
                                  height: 4,
                                  child: LinearProgressIndicator(
                                    value: controller.progressValue.value,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF00E5FF),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
