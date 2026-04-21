import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen>{
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context){
    const goldColor = Color(0xFFC9A96E);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height:40),

              Text(
                'Smart Closet',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D), 
                  letterSpacing: -0.5,  
                ),

              ),

              const Text(
                'YOUR AI WARDROBE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize:12, color: goldColor, letterSpacing:2),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sign In To Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),

                    ),
                    const Text('E-mail',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height:8),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'email@example.com',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 8),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Your Password',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: (){
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {}, 
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color:goldColor),
                        ),
                      ),
                        
                    ),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize:16),
                        ),
                    ),

                      const SizedBox(height: 16),
                      
                      Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0E8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your data is secure with us. Review our privacy policy.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

     