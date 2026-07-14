import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/auth/cubit/login_cubit.dart';
import 'package:rentvyn_tenant/features/auth/state/login_state.dart';

class LoginScreen extends StatefulWidget {
  final void Function() onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final phone = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _controller;
  late final Animation<double> fadeAnim;

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    phone.dispose();
    otpController.dispose();
    super.dispose();
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter mobile number";
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      return "Mobile number must be 10 digits";
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digitsOnly)) {
      return "Invalid mobile number";
    }
    return null;
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter 6-digit OTP code";
    }
    if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
      return "OTP must be exactly 6 digits";
    }
    return null;
  }

  void _handleLogin(LoginState state) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final digitsOnly = phone.text.replaceAll(RegExp(r'\D'), '');
    if (!state.otpSent) {
      // Send OTP
      context.read<LoginCubit>().sendOtp(digitsOnly);
    } else {
      // Verify OTP
      context.read<LoginCubit>().verifyOtp(otpController.text, digitsOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state.isVerified) {
            widget.onLoginSuccess();
          }

          // Clear controllers on state resets
          if (!state.otpSent && !state.isVerified && !state.isLoading) {
            phone.clear();
            otpController.clear();
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            Widget? suffixIcon;
            if (state.otpSent) {
              suffixIcon = state.timer > 0
                  ? Container(
                      alignment: Alignment.center,
                      width: 50,
                      child: Text(
                        "${state.timer}s",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        final digitsOnly = phone.text.replaceAll(RegExp(r'\D'), '');
                        context.read<LoginCubit>().resendOtp(digitsOnly);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("OTP resent successfully")),
                        );
                      },
                      child: const Text(
                        "Resend",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
            }

            return FadeTransition(
              opacity: fadeAnim,
              child: Stack(
                children: [
                  // 1. Background Container spanning full screen height
                  Container(
                    height: screenHeight,
                    width: double.infinity,
                    color: const Color(0xFFF8FAFC),
                    child: Stack(
                      children: [
                        // Royal Purple Header spanning top 45%
                        Container(
                          height: screenHeight * 0.45,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -40,
                                right: -40,
                                child: Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 40,
                                left: -60,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.06),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Scrollable form elements filling full Stack space
                  Positioned.fill(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            // Rentvyn Logo Container aligned left
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 65,
                                  width: 65,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/mainlogo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Header Texts
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome Back",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.otpSent
                                        ? "Enter verification code sent to your number"
                                        : "Please sign in to your account",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 35),

                            // Floating Card
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                padding: const EdgeInsets.all(28.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Mobile Number Label
                                      const Text(
                                        "Mobile Number",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Mobile Number Input
                                      TextFormField(
                                        controller: phone,
                                        readOnly: state.otpSent,
                                        validator: validatePhone,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF1F2937),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: _buildFieldDecoration(
                                          hint: "Enter mobile number",
                                          prefixIcon: Icons.phone_android_rounded,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // OTP Field (visible only when otpSent)
                                      if (state.otpSent) ...[
                                        const Text(
                                          "Enter OTP",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF374151),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: otpController,
                                          validator: validateOtp,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF1F2937),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          onChanged: (val) {
                                            if (val.length == 6) {
                                              FocusScope.of(context).unfocus();
                                              final digitsOnly = phone.text.replaceAll(RegExp(r'\D'), '');
                                              context.read<LoginCubit>().verifyOtp(val, digitsOnly);
                                            }
                                          },
                                          decoration: _buildFieldDecoration(
                                            hint: "Enter 6-digit OTP",
                                            prefixIcon: Icons.lock_outline_rounded,
                                            suffixIcon: suffixIcon,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],

                                      // Checkbox Row
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              activeColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFFD1D5DB),
                                                width: 1.5,
                                                  ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _rememberMe = val ?? false;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Remember me",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),

                                      // Login/Submit Button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.25),
                                                blurRadius: 15,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: state.isLoading
                                                ? null
                                                : () => _handleLogin(state),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: state.isLoading
                                                ? const SizedBox(
                                                    height: 22,
                                                    width: 22,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2.5,
                                                    ),
                                                  )
                                                : Text(
                                                    state.otpSent
                                                        ? "Verify & Login"
                                                        : "Send OTP",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),

                                      // Powered by Srivyn row
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Divider(
                                              color: Color(0xFFE5E7EB),
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Text(
                                              "Powered by Srivyn",
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: Divider(
                                              color: Color(0xFFE5E7EB),
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _buildFieldDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 14.5,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(prefixIcon, color: const Color(0xFF9CA3AF), size: 22),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12.5,
      ),
    );
  }
}