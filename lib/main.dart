import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'Language/translator.dart';
import 'View/Screen/Login/view/login_screen.dart';
import 'View/Screen/Main/view/main_screen.dart';
import 'helper/shared_prefe/shared_prefe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await SharedPrefsHelper.getToken();
  final Widget initialScreen = (token != null && token.isNotEmpty)
      ? const MainScreen()
      : const LoginScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget? initialScreen;
  const MyApp({super.key, this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 1010),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Bondi',
          debugShowCheckedModeBanner: false,
          translations: Translator(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          home: initialScreen ?? const LoginScreen(),
        );
      },
    );
  }
}
