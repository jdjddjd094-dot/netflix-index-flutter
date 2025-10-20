import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/netflix_logo.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.user;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Profile Header
                  _buildProfileHeader(user, localizations),
                  
                  const SizedBox(height: 40),
                  
                  // Settings Options
                  _buildSettingsSection(context, authProvider, localizations),
                  
                  const SizedBox(height: 40),
                  
                  // Sign Out Button
                  if (user != null)
                    _buildSignOutButton(context, authProvider, localizations),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user, AppLocalizations localizations) {
    return Column(
      children: [
        // Profile Picture
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.netflixRed,
          backgroundImage: user?.photoURL != null 
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.netflixWhite,
                )
              : null,
        ),
        
        const SizedBox(height: 16),
        
        // User Name
        Text(
          user?.displayName ?? (user?.isGuest == true ? localizations.continueAsGuest : localizations.profile),
          style: const TextStyle(
            color: AppColors.netflixWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // User Email
        if (user?.email != null)
          Text(
            user!.email!,
            style: const TextStyle(
              color: AppColors.netflixGray,
              fontSize: 16,
            ),
          ),
        
        // Guest Badge
        if (user?.isGuest == true)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.netflixGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              localizations.continueAsGuest,
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, AuthProvider authProvider, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.settings,
          style: const TextStyle(
            color: AppColors.netflixWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Language Setting
        _buildSettingsTile(
          icon: Icons.language,
          title: localizations.language,
          subtitle: authProvider.language == 'ar' ? localizations.arabic : localizations.english,
          onTap: () => _showLanguageDialog(context, authProvider, localizations),
        ),
        
        // Notifications Setting
        _buildSettingsTile(
          icon: Icons.notifications,
          title: localizations.notifications,
          subtitle: 'Enabled',
          onTap: () {
            // TODO: Implement notifications settings
          },
        ),
        
        // Privacy Setting
        _buildSettingsTile(
          icon: Icons.privacy_tip,
          title: localizations.privacy,
          subtitle: 'Privacy Policy',
          onTap: () {
            // TODO: Implement privacy policy
          },
        ),
        
        // About Setting
        _buildSettingsTile(
          icon: Icons.info,
          title: localizations.about,
          subtitle: 'Version 1.0.0',
          onTap: () => _showAboutDialog(context, localizations),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.netflixWhite,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.netflixWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.netflixGray,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.netflixGray,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton(BuildContext context, AuthProvider authProvider, AppLocalizations localizations) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _signOut(context, authProvider),
        icon: const Icon(
          Icons.logout,
          color: AppColors.netflixWhite,
        ),
        label: Text(
          localizations.signOut,
          style: const TextStyle(
            color: AppColors.netflixWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.netflixRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AuthProvider authProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.netflixDarkGray,
        title: Text(
          localizations.language,
          style: const TextStyle(color: AppColors.netflixWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Radio<String>(
                value: 'ar',
                groupValue: authProvider.language,
                onChanged: (value) {
                  if (value != null) {
                    authProvider.updateLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
                activeColor: AppColors.netflixRed,
              ),
              title: Text(
                localizations.arabic,
                style: const TextStyle(color: AppColors.netflixWhite),
              ),
              onTap: () {
                authProvider.updateLanguage('ar');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'en',
                groupValue: authProvider.language,
                onChanged: (value) {
                  if (value != null) {
                    authProvider.updateLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
                activeColor: AppColors.netflixRed,
              ),
              title: Text(
                localizations.english,
                style: const TextStyle(color: AppColors.netflixWhite),
              ),
              onTap: () {
                authProvider.updateLanguage('en');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.netflixDarkGray,
        title: Row(
          children: [
            const NetflixLogo(size: 30),
            const SizedBox(width: 12),
            Text(
              localizations.about,
              style: const TextStyle(color: AppColors.netflixWhite),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Netflix Clone',
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: const TextStyle(
                color: AppColors.netflixGray,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A streaming application built with Flutter, featuring Arabic and English language support.',
              style: const TextStyle(
                color: AppColors.netflixWhite,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: const TextStyle(color: AppColors.netflixRed),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.netflixDarkGray,
        title: Text(
          AppLocalizations.of(context)!.signOut,
          style: const TextStyle(color: AppColors.netflixWhite),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: const TextStyle(color: AppColors.netflixWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: const TextStyle(color: AppColors.netflixGray),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.signOut,
              style: const TextStyle(color: AppColors.netflixRed),
            ),
          ),
        ],
      ),
    );
  }
}