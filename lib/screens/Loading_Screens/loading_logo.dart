import 'package:flutter/material.dart';

class LoadingLogo extends StatefulWidget {
  const LoadingLogo({Key? key}) : super(key: key);

  @override
  LoadingLogoState createState() => LoadingLogoState();
}

class LoadingLogoState extends State<LoadingLogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: const [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Image(
                  height: 400.0,
                  image: AssetImage(
                    'assets/images/app_logo.png',
                  ),
                ),
              ),
              SizedBox(height: 5),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              )
            ],
          ),
        ),
      ),
    );
  }
}
