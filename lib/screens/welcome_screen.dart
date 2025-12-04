import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart'; 
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const pawColor = Color(0xFFFFC857); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
      
          Positioned(
            
            top: -size.height * 0.15, 
            
            left: -size.width * 0.25, 
            right: -size.width * 0.25,
            
            height: size.height * 0.8, 
            child: Opacity(
              opacity: 1.0, 
              child: Image.asset(
                'assets/pictures/top_paw_print.png', 
                fit: BoxFit.fitWidth, 
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.15, 
            child: Image.asset(
              'assets/pictures/welcome_dog.png',
              height: size.height * 0.35, 
              fit: BoxFit.contain,
            ),
          ),

          // 3. "welcome" TEXT

          Positioned(
            top: size.height * 0.56, 
            child: Text(
              'welcome',
              style: GoogleFonts.fredoka( 
                fontSize: 70,
                fontWeight: FontWeight.w600,
                color: pawColor,
                letterSpacing: 1.5,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: SmoothWaveClipper(), 
              child: Container(
                height: size.height * 0.35, 
                width: double.infinity,
                color: pawColor,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.08), 
                    
                    // SIGN IN BUTTON
                    ElevatedButton(
                      onPressed: () {
                         Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: pawColor,
                        minimumSize: const Size(double.infinity, 55),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900, 
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // LOG IN TEXT
                    GestureDetector(
                      onTap: () {
                      
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SMOOTH WAVE CLIPPER
class SmoothWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 60); 

    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 60);
    
    var secondControlPoint = Offset(size.width * 0.75, 120);
    var secondEndPoint = Offset(size.width, 60);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 
        firstEndPoint.dx, firstEndPoint.dy);
        
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, 
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}