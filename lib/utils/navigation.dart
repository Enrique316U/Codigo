import "package:flutter/material.dart";
import "package:green_cloud/screens/onboarding/01_splash_screen.dart";
import "package:green_cloud/screens/onboarding/02_logo_screen.dart";
import "package:green_cloud/screens/onboarding/04_fuction_principal.dart";
import "package:green_cloud/screens/login/login_screen.dart";
import "package:green_cloud/screens/login/register_screen.dart";
import "package:green_cloud/screens/login/forgot_password_screen.dart";
import "package:green_cloud/screens/login/otp_verfication_screen.dart";
import "package:green_cloud/screens/login/reset_password_screen.dart";
import "package:green_cloud/screens/login/password_changed_screen.dart";
import "package:green_cloud/widgets/BottomNavBar.dart";

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case LogoScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LogoScreen());
      case fuction_principal.routeName:
        return MaterialPageRoute(builder: (_) => const fuction_principal());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case OtpVerificationScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());
      case ResetPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case PasswordChangedScreen.routeName:
        return MaterialPageRoute(builder: (_) => const PasswordChangedScreen());
      case BottomNavBar.routeName:
        return MaterialPageRoute(builder: (_) => const BottomNavBar());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text("Página no encontrada")),
      );
    });
  }
}
