import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/netflix_logo.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Netflix Logo
              const NetflixLogo(size: 120),
              
              const SizedBox(height: 60),
              
              // Welcome Text
              Text(
                localizations.welcome,
                style: const TextStyle(
                  color: AppColors.netflixWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Google Sign In Button
              _buildSignInButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                text: localizations.signInWithGoogle,
                icon: Icons.login,
                color: AppColors.netflixRed,
              ),
              
              const SizedBox(height: 16),
              
              // Guest Button
              _buildSignInButton(
                onPressed: _isLoading ? null : _signInAsGuest,
                text: localizations.continueAsGuest,
                icon: Icons.person,
                color: AppColors.netflixGray,
              ),
              
              const Spacer(),
              
              // Loading Indicator
              if (_isLoading)
                const CircularProgressIndicator(
                  color: AppColors.netflixRed,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton({
    required VoidCallback? onPressed,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.netflixWhite),
        label: Text(
          text,
          style: const TextStyle(
            color: AppColors.netflixWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showErrorSnackBar('Failed to sign in with Google');
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() => _isLoading = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInAsGuest();
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showErrorSnackBar('Failed to continue as guest');
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.netflixRed,
        ),
      );
    }
  }
}