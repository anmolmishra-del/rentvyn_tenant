import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _showText = false;
  bool _hideBrandName = false;
  bool _scaleLogo = false;
  bool _isExitAnimationStarted = false;
  bool _startTextSweep = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linearToEaseOut,
      ),
    );

    _animationController.forward();

    _animationController.addListener(() {
      if (_animationController.isCompleted && !_showText) {
        setState(() {
          _showText = true;
        });
        _checkAndStartExitAnimation();
      }
    });
  }

  void _checkAndStartExitAnimation() async {
    if (_showText && !_scaleLogo && !_isExitAnimationStarted) {
      setState(() {
        _isExitAnimationStarted = true;
      });

      // 1. Wait for text fade-in to complete
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      // 2. Trigger the smooth shimmer sweep
      setState(() {
        _startTextSweep = true;
      });
    }
  }

  void _onSweepComplete() async {
    if (!mounted) return;

    // 3. Hide brand name after sweep, then zoom out
    setState(() {
      _hideBrandName = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() {
      _scaleLogo = true;
    });

    // 4. Trigger navigation at 500ms (just before the scale finishes)
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    if (hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24), // Modern dark background for contrast
      body: SizedBox.expand(
        child: Center(
          child: Align(
            alignment: const Alignment(0, -0.15),
            child: SizedBox(
              width: 300,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Logo with initial scale-in and final zoom-out
                 AnimatedBuilder(
  animation: _animationController,
  builder: (context, child) {
    return Transform.scale(
      scale: _animation.value,
      child: child,
    );
  },
  child: AnimatedScale(
    duration: const Duration(milliseconds: 500),
    scale: _scaleLogo ? 8 : 1,
    child: Container(
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
      ),
    ),
  ),
),
                  // Brand Name: Rentvyn
                  Padding(
                    padding: const EdgeInsets.only(top: 180),
                    child: AnimatedOpacity(
                      opacity: _showText && !_hideBrandName ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: AnimatedRentvynText(
                        startAnimation: _startTextSweep,
                        onAnimationComplete: _onSweepComplete,
                        baseColor: Colors.white,
                        shineColor: AppColors.secondary,
                        fixedColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom widget that animates a colored line passing through "Rent"
/// and leaves the "vyn" completely static, isolated, and unaffected by gradients.
class AnimatedRentvynText extends StatefulWidget {
  final bool startAnimation;
  final VoidCallback onAnimationComplete;

  final Color baseColor;
  final Color shineColor;
  final Color fixedColor;
  final double sweepWidth;
  final double sweepAngle;
  final Duration animationDuration;

  const AnimatedRentvynText({
    super.key,
    required this.startAnimation,
    required this.onAnimationComplete,
    this.baseColor = Colors.white,
    this.shineColor = AppColors.secondary,
    this.fixedColor = AppColors.primary,
    this.sweepWidth = 0.1,
    this.sweepAngle = -0.4,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedRentvynText> createState() => _AnimatedRentvynTextState();
}

class _AnimatedRentvynTextState extends State<AnimatedRentvynText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    if (widget.startAnimation) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedRentvynText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startAnimation && !oldWidget.startAnimation) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Animated "Rent"
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final val = _controller.value;
            final pos = (val * 1.5) - 0.25;

            List<Color> colors = [];
            List<double> stops = [];

            for (int i = 0; i <= 100; i++) {
              double x = i / 100.0;
              stops.add(x);

              double dist = (x - pos).abs();

              if (dist < widget.sweepWidth) {
                double fadeRatio = widget.sweepWidth + 0.005;
                double t = 1.0 - (dist / fadeRatio).clamp(0.0, 1.0);
                t = Curves.easeOut.transform(t);
                colors.add(
                  Color.lerp(widget.baseColor, widget.shineColor, t)!,
                );
              } else {
                colors.add(widget.baseColor);
              }
            }

            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: colors,
                  stops: stops,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  transform: GradientRotation(widget.sweepAngle),
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                "Rent",
                style: textStyle.copyWith(color: widget.baseColor),
              ),
            );
          },
        ),
        // Isolated "vyn" (Solid Brand Color)
        Text("vyn", style: textStyle.copyWith(color: widget.fixedColor)),
      ],
    );
  }
}
