import "package:flutter/material.dart";
import "04_fuction_principal.dart";

class LogoScreen extends StatefulWidget {
  static const String routeName = "/logo";
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    //DURACION 3 SEGUNDO
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const fuction_principal()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[0],
        body: Center(
          child: Image.asset('assets/images/logo.png'),
        ));
  }
}
