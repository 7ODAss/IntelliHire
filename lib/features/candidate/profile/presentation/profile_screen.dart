import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/candidate/bottom%20_navigation/controller/bottom_nav_candidate_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/domain/entities/candidate_profile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'controller/candidate_profile_cubit.dart';
import 'screens/personal_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CandidateProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  static const _dummyProfile = CandidateProfile(
    id: 'u1',
    name: 'Mahmoud Magdy',
    email: 'Mahmoud23@gmail.com',
    track: 'Frontend Engineering Track',
    avatarInitials: 'MM',
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
      builder: (context, state) {
        final isLoading = state.status != RequestState.success;
        final profile = (isLoading ? null : state.profile) ?? _dummyProfile;

        return Skeletonizer(
          enabled: isLoading && state.status != RequestState.error,
          child: Scaffold(
            backgroundColor: AppColor.backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF0F172A),
                ),
                onPressed: () =>
                    context.read<BottomNavCandidateCubit>().goBackToPrevious,
              ),
              centerTitle: true,
              title: const Text(
                'Account Profile',
                style: TextStyle(
                  fontFamily: AppFont.poppinsBold,
                  fontSize: 18,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Avatar + name + email ─────────────────────────────────
                  _ProfileHeader(profile: profile),
                  const SizedBox(height: 24),

                  // ── Account section ───────────────────────────────────────
                  _SectionCard(
                    title: 'Account',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Personal Info',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<CandidateProfileCubit>(),
                              child: PersonalInfoScreen(profile: profile),
                            ),
                          ),
                        ),
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        label: 'Security',
                        onTap: () => _showChangePasswordSheet(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Logout ────────────────────────────────────────────────
                  _SectionCard(
                    title: '',
                    showTitle: false,
                    items: [
                      _MenuItem(
                        icon: Icons.logout_rounded,
                        label: 'Logout',
                        textColor: const Color(0xFFEF4444),
                        iconColor: const Color(0xFFEF4444),
                        showArrow: false,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout?',
          style: TextStyle(fontFamily: AppFont.interBold),
        ),
        content: const Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(fontFamily: AppFont.interRegular),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFont.interSemiBold,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: AppFont.interBold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CandidateProfileCubit>(),
        child: const _ChangePasswordSheet(),
      ),
    );
  }
}

// ── Profile Header ───────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final CandidateProfile profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          // Circular avatar with border
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.primary, width: 2.5),
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFFEFF6FF),
              child: Text(
                profile.avatarInitials,
                style: const TextStyle(
                  fontFamily: AppFont.interBold,
                  fontSize: 28,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            profile.name,
            style: const TextStyle(
              fontFamily: AppFont.poppinsBold,
              fontSize: 20,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: const TextStyle(
              fontFamily: AppFont.interRegular,
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  final bool showTitle;

  const _SectionCard({
    required this.title,
    required this.items,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppFont.interSemiBold,
                fontSize: 13,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isLast = i == items.length - 1;
                return Column(
                  children: [
                    item,
                    if (!isLast)
                      const Divider(
                        height: 1,
                        indent: 56,
                        color: Color(0xFFF1F5F9),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Menu Item ─────────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? const Color(0xFF0F172A);
    final icolor = iconColor ?? const Color(0xFF64748B);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: icolor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: icolor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppFont.interMedium,
                  fontSize: 15,
                  color: color,
                ),
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFCBD5E1),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Change Password Bottom Sheet ─────────────────────────────────────────────
class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _hideC = true, _hideN = true, _hideCo = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final current = _currentCtrl.text.trim();
    final newPass = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showSnack(context, 'Please fill in all fields.', isError: true);
      return;
    }
    if (newPass != confirm) {
      _showSnack(context, 'Passwords do not match.', isError: true);
      return;
    }
    if (newPass.length < 6) {
      _showSnack(context, 'Min 6 characters.', isError: true);
      return;
    }
    context.read<CandidateProfileCubit>().changePassword(current, newPass);
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontFamily: AppFont.interRegular),
        ),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CandidateProfileCubit, CandidateProfileState>(
      listenWhen: (prev, curr) =>
          prev.changePasswordStatus != curr.changePasswordStatus,
      listener: (context, state) {
        if (state.changePasswordStatus == RequestState.success) {
          _currentCtrl.clear();
          _newCtrl.clear();
          _confirmCtrl.clear();
          Navigator.pop(context);
          _showSnack(context, 'Password changed successfully!');
        } else if (state.changePasswordStatus == RequestState.error) {
          _showSnack(context, state.errorMessage, isError: true);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Password',
              style: TextStyle(
                fontFamily: AppFont.poppinsBold,
                fontSize: 18,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 20),
            _PassField(
              controller: _currentCtrl,
              label: 'Current Password',
              hide: _hideC,
              onToggle: () => setState(() => _hideC = !_hideC),
            ),
            const SizedBox(height: 12),
            _PassField(
              controller: _newCtrl,
              label: 'New Password',
              hide: _hideN,
              onToggle: () => setState(() => _hideN = !_hideN),
            ),
            const SizedBox(height: 12),
            _PassField(
              controller: _confirmCtrl,
              label: 'Confirm New Password',
              hide: _hideCo,
              onToggle: () => setState(() => _hideCo = !_hideCo),
            ),
            const SizedBox(height: 24),
            BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
              buildWhen: (prev, curr) =>
                  prev.changePasswordStatus != curr.changePasswordStatus,
              builder: (context, state) {
                final loading =
                    state.changePasswordStatus == RequestState.loading;
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading ? null : () => _submit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update Password',
                            style: TextStyle(
                              fontFamily: AppFont.interBold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Password Field ────────────────────────────────────────────────────────────
class _PassField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool hide;
  final VoidCallback onToggle;

  const _PassField({
    required this.controller,
    required this.label,
    required this.hide,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hide,
      style: const TextStyle(
        fontFamily: AppFont.interRegular,
        fontSize: 14,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: AppFont.interRegular,
          fontSize: 13,
          color: Color(0xFF94A3B8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hide ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: const Color(0xFF94A3B8),
            size: 20,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
        ),
      ),
    );
  }
}
