import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),

              Text(
                'Dress with',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2D2D)
                
                ),
              ),
              Text(
                'intention',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFFC9A96E),
                ),
              ),

              const  SizedBox(height: 40),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const[
                  _ClothingCard(emoji: '', color: Color(0xFFF0D5CC)),
                  _ClothingCard(emoji: '', color: Color(0xFFC9D6C5)),
                  _ClothingCard(emoji: '', color: Color(0xFFBCC8D4)),
                  _ClothingCard(emoji: '', color: Color(0xFFBCC8D4)),
                  _ClothingCard(emoji: '', color: Color(0xFFF0D5CC)),
                  _ClothingCard(emoji: '', color: Color(0xFFC9D6C5)),

                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2D2D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical:18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),

                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account',
                  style: TextStyle(fontSize:16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                      
                    },
                    child: const Text(
                      ' Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,

                      ),
                    ),
                  )
                ],
              ),
            ],

          ),
        ),
      ),
    );
    
  }

}

class _ClothingCard extends StatelessWidget {
  final String emoji;
  final Color color;

  const _ClothingCard({required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

