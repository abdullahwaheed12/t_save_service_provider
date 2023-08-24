import 'package:t_save_sp/modules/contact_us/view.dart';
import 'package:get/get.dart';

import 'modules/forget_password.dart/view.dart';
import 'modules/home/view.dart';
import 'modules/login/view.dart';
import 'modules/profile/view.dart';
import 'modules/sign_up/view.dart';
import 'modules/splash/view.dart';

routes() => [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/login", page: () => const LoginPage()),
      GetPage(name: "/signUp", page: () => const SignUpPage()),
      GetPage(name: "/home", page: () => const HomePage()),
      GetPage(name: "/profile", page: () => const ProfilePage()),
      GetPage(name: "/contactUs", page: () => const ContactUs()),
      GetPage(name: "/forgetPassword", page: () => const ForgotPassword()),
    ];

class PageRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String orderDetail = '/orderDetail';
  static const String allProducts = '/allProducts';
  static const String allOrders = '/allOrders';
  static const String profile = '/profile';
  static const String contactUs = '/contactUs';
  static const String forgetPassword = '/forgetPassword';
  static const String privacyPolicy = '/privacyPolicy';
}
