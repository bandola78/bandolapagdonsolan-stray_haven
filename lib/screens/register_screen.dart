import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Password validation helper
  String? _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Phone validation helper
  String? _validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (!phone.startsWith('9')) {
      return 'Phone must start with 9';
    }
    if (phone.length != 10) {
      return 'Phone must be exactly 10 digits';
    }
    return null;
  }

  Future<void> registerUser() async {
    // Validation
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _contactController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate phone number
    final phoneError = _validatePhone(_contactController.text.trim());
    if (phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(phoneError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate password
    final passwordError = _validatePassword(_passwordController.text.trim());
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if username already exists
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _usernameController.text.trim().toLowerCase())
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username already taken. Please choose another.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': _nameController.text.trim(),
        'username': _usernameController.text.trim().toLowerCase(),
        'age': _ageController.text.trim(),
        'contactNumber': '+63${_contactController.text.trim()}',
        'email': _emailController.text.trim(),
        'role': 'User',
        'createdAt': DateTime.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Created Successfully!')),
        );

        // Navigate to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered. Please login instead.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak. Use at least 8 characters.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address format.';
      } else {
        errorMessage = 'Registration failed: ${e.message}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC857)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Create Account',
              style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFC857)),
            ),
            Text(
              'Join the Stray Haven community',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            _buildLabel('Full Name'),
            _buildTextField(_nameController, 'John Doe', Icons.person),
            const SizedBox(height: 15),
            _buildLabel('Username'),
            _buildTextField(_usernameController, 'johndoe123', Icons.alternate_email),
            const SizedBox(height: 15),
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildLabel('Age'),
                      _buildTextField(_ageController, '21', Icons.cake,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ])
                    ])),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildLabel('Phone Number'),
                      _buildPhoneField()
                    ]
                  )
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildLabel('Email Address'),
            _buildTextField(_emailController, 'hello@example.com', Icons.email,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15),
            _buildLabel('Password'),
            _buildPasswordField(),
            const SizedBox(height: 8),
            // Password requirements hint
            Text(
              'Password must be 8+ characters with uppercase, lowercase, number & special character',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC857),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Sign Up',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            // Already have account link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Log In',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFFFC857),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.black87)));
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters}) {
    return TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16)));
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _contactController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                '+63',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        hintText: '9XX XXX XXXX',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[400],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        hintText: '********',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}