import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Utils/StaticString/static_string.dart';
import '../../CreateAccount/view/create_account_screen.dart';
import '../../ForgotPassword/view/forgot_password_screen.dart';
import '../Controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller if not already injected
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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

                  // Welcome Back Text
                  Text(
                    StaticString.welcomeBack,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 10.0,
                    ),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Label
                        Text(
                          StaticString.email,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: StaticString.johndoe00gmailcom,
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 15,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.phone_outlined,
                                color: AppColors.accentColor,
                                size: 22,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 10.0,
                            ),
                            filled: true,
                            fillColor: AppColors.inputFillColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: AppColors.accentColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password Row (Label + Forgot Password)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              StaticString.password,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const ForgotPasswordScreen()),
                              child: Text(
                                StaticString.forgotPassword,
                                style: TextStyle(
                                  color: AppColors.accentColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Password TextField (Reactive)
                        Obx(
                          () => TextField(
                            controller: controller.passwordController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            obscureText: controller.isPasswordObscured.value,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 15,
                                letterSpacing: 2.0,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 10.0,
                                ),
                                child: Icon(
                                  Icons.lock_outline_rounded,
                                  color: AppColors.accentColor,
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
                                    color: AppColors.accentColor,
                                    size: 22,
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                                horizontal: 10.0,
                              ),
                              filled: true,
                              fillColor: AppColors.inputFillColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: AppColors.accentColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Login Button
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.buttonColor,
                                    AppColors.buttonColor,
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
                                    : controller.login,
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        StaticString.login,
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

                  const SizedBox(height: 50),

                  // Bottom Create Account Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StaticString.dontHaveAccount,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const CreateAccountScreen());
                        },
                        child: Text(
                          StaticString.createAccount,
                          style: TextStyle(
                            color: AppColors.accentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
