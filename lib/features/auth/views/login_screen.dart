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

  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  late final AnimationController _controller;

  late final Animation<double> fadeAnim;

  String getOtp() => otpControllers.map((e) => e.text).join();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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

    for (var c in otpControllers) {
      c.dispose();
    }

    super.dispose();
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter mobile number";
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return "Invalid number";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }

            if (state.isVerified) {
              widget.onLoginSuccess();
            }

            // When cubit is reset (logout), clear the phone field and OTP fields
            if (!state.otpSent && !state.isVerified && !state.isLoading) {
              phone.clear();
              for (final c in otpControllers) {
                c.clear();
              }
            }
          },

          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return FadeTransition(
                opacity: fadeAnim,

                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),

                    child: Container(
                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(28),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),

                            blurRadius: 15,

                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Form(
                        key: _formKey,

                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            // / LOGO
                            Container(
                              height: 100,
                              width: 100,

                              padding: const EdgeInsets.all(14),

                              decoration: BoxDecoration(
                                color: const Color(0xfff4f6fb),

                                borderRadius: BorderRadius.circular(24),
                              ),

                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.fill,
                              ),
                            ),

                            const SizedBox(height: 24),

                            /// TITLE
                            Text(
                              state.otpSent
                                  ? "OTP Verification"
                                  : "Welcome Back",

                              style: const TextStyle(
                                color: Colors.black87,

                                fontSize: 28,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              state.otpSent
                                  ? "Enter OTP sent to +91 ${phone.text}"
                                  : "Login to continue",

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                color: Colors.grey.shade600,

                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 35),

                            /// PHONE FIELD
                            if (!state.otpSent)
                              TextFormField(
                                controller: phone,

                                validator: validatePhone,

                                keyboardType: TextInputType.phone,

                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,

                                  LengthLimitingTextInputFormatter(10),
                                ],

                                decoration: _inputDecoration(
                                  "Enter mobile number",

                                  Icons.phone_android,
                                ),
                              ),

                            /// OTP BOXES
                            if (state.otpSent) ...[
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final boxWidth =
                                      (constraints.maxWidth - 50) / 6;

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: List.generate(6, (index) {
                                      return SizedBox(
                                        width: boxWidth,

                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          autofocus: index == 0,
                                          controller: otpControllers[index],

                                          keyboardType: TextInputType.number,

                                          textAlign: TextAlign.center,

                                          maxLength: 1,

                                          style: const TextStyle(
                                            fontSize: 20,

                                            fontWeight: FontWeight.bold,

                                            color: Colors.black87,
                                          ),

                                          decoration: InputDecoration(
                                            counterText: "",

                                            filled: true,

                                            fillColor: const Color(0xfff4f6fb),

                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 18,
                                                ),

                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),

                                              borderSide: BorderSide.none,
                                            ),

                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),

                                              borderSide: BorderSide.none,
                                            ),

                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),

                                              borderSide: const BorderSide(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),

                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (v) {
                                            if (v.isNotEmpty && index < 5) {
                                              FocusScope.of(
                                                context,
                                              ).nextFocus();
                                            }

                                            if (v.isEmpty && index > 0) {
                                              FocusScope.of(
                                                context,
                                              ).previousFocus();
                                            }

                                            if (getOtp().length == 6) {
                                              FocusScope.of(context).unfocus();

                                              context
                                                  .read<LoginCubit>()
                                                  .verifyOtp(
                                                    getOtp(),
                                                    phone.text,
                                                  );
                                            }
                                          },
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),

                              const SizedBox(height: 18),

                              Column(
                                children: [
                                  Text(
                                    state.timer > 0
                                        ? "Resend OTP in ${state.timer}s"
                                        : "Didn't receive OTP?",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),

                                  if (state.timer == 0)
                                    TextButton(
                                      onPressed: () {
                                        for (final controller
                                            in otpControllers) {
                                          controller.clear();
                                        }

                                        context.read<LoginCubit>().sendOtp(
                                          phone.text,
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "OTP resent successfully",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Resend OTP",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 35),

                            /// BUTTON
                            SizedBox(
                              width: double.infinity,

                              height: 56,

                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,

                                  elevation: 0,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),

                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        if (!state.otpSent &&
                                            !_formKey.currentState!
                                                .validate()) {
                                          return;
                                        }

                                        if (state.otpSent) {
                                          if (phone.text.isEmpty) {
                                            // final userData = context
                                            //     .read<RegisterCubit>()
                                            //     .registrationData;

                                            // phone.text = userData?.phone ?? "";
                                          }

                                          if (getOtp().length != 6) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Please enter 6 digit OTP",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          context.read<LoginCubit>().verifyOtp(
                                            getOtp(),
                                            phone.text,
                                          );
                                        } else {
                                          context.read<LoginCubit>().sendOtp(
                                            phone.text,
                                          );
                                        }
                                      },

                                child: state.isLoading
                                    ? const SizedBox(
                                        height: 22,

                                        width: 22,

                                        child: CircularProgressIndicator(
                                          color: Colors.white,

                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        state.otpSent
                                            ? "Verify OTP"
                                            : "Continue",

                                        style: const TextStyle(
                                          color: Colors.white,

                                          fontSize: 16,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 24),

                          state.otpSent
                              ? const SizedBox.shrink()
                              :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Text(
                                  "Don't have an account? ",

                                  style: TextStyle(color: Colors.grey.shade700),
                                ),

                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.pushNamed(
                                //       context,
                                //       AppRoutes.register,
                                //     );
                                //   },

                                //   child: const Text(
                                //     "Create Account",

                                //     style: TextStyle(
                                //       color: AppColors.primary,

                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

    InputDecoration _inputDecoration(
    String hint, 
    IconData icon, {
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 15.5,
      ),
      prefixIcon: Icon(
        icon, 
        color: Colors.grey.shade500,
        size: 22,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC), // Light elegant background
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 20,
      ),
      
      // Default border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      
      // Enabled state
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      
      // Focused state (Premium feel)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      
      // Error state
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
      
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 13,
      ),
      
      errorText: errorText,
    );
  }}