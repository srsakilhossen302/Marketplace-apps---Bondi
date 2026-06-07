import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../OtpVerification/view/otp_verification_screen.dart';
import '../Controller/create_account_controller.dart';

class CreateAccountScreen extends GetView<CreateAccountController> {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                        
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
                        
                        // Create Your Account Text
                        const Text(
                          'Create Your Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        Text(
                          'Join the premium community of Bondi today.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Create Account Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2558A8).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full Name Label
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Full Name TextField
                              TextField(
                                controller: controller.fullNameController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'John Doe',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF00E5FF),
                                      size: 22,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: const Color(0xFF1F4FB0).withOpacity(0.6),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF00E5FF),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Username Label
                              Text(
                                'Username',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Username TextField
                              TextField(
                                controller: controller.usernameController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: 'johndoe',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.alternate_email,
                                      color: Color(0xFF00E5FF),
                                      size: 22,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: const Color(0xFF1F4FB0).withOpacity(0.6),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF00E5FF),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Phone Number Label
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Phone Number TextField
                              TextField(
                                controller: controller.phoneNumberController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: '+1 (555) 000-0000',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.phone_outlined,
                                      color: Color(0xFF00E5FF),
                                      size: 22,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: const Color(0xFF1F4FB0).withOpacity(0.6),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF00E5FF),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Email Label
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Email TextField
                              TextField(
                                controller: controller.emailController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'john@example.com',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF00E5FF),
                                      size: 22,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: const Color(0xFF1F4FB0).withOpacity(0.6),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF00E5FF),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Password Label
                              Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              // Password TextField (Reactive)
                              Obx(
                                () => TextField(
                                  controller: controller.passwordController,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                  obscureText: controller.isPasswordObscured.value,
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 15,
                                      letterSpacing: 2.0,
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                                      child: Icon(
                                        Icons.lock_outline_rounded,
                                        color: Color(0xFF00E5FF),
                                        size: 22,
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: IconButton(
                                        icon: Icon(
                                          controller.isPasswordObscured.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF00E5FF),
                                          size: 22,
                                        ),
                                        onPressed: controller.togglePasswordVisibility,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.08),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF00E5FF),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Continue Button
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
                                          : controller.createAccount,
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
      ),
    );
  }
}
