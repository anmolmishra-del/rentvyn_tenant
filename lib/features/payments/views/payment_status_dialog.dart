import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/auth/cubit/auth_service.dart';

enum PaymentStatus { verifying, success, failed }

class PaymentStatusDialog extends StatefulWidget {
  final String billId;
  final String billNumber;
  final double amount;
  final String paymentId;
  final String orderId;
  final String signature;
  final VoidCallback onSuccess;
  final VoidCallback? onFailure;

  const PaymentStatusDialog({
    Key? key,
    required this.billId,
    required this.billNumber,
    required this.amount,
    required this.paymentId,
    required this.orderId,
    required this.signature,
    required this.onSuccess,
    this.onFailure,
  }) : super(key: key);

  @override
  State<PaymentStatusDialog> createState() => _PaymentStatusDialogState();
}

class _PaymentStatusDialogState extends State<PaymentStatusDialog>
    with TickerProviderStateMixin {
  PaymentStatus _status = PaymentStatus.verifying;

  // Animation Controllers
  late AnimationController _loadingController;
  late AnimationController _successController;
  late AnimationController _confettiController;
  late AnimationController _contentFadeController;

  // Confetti particles
  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Loading rotation controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Success checkmark animation (draws circle, then tick)
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Confetti animation controller
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addListener(() {
        _updateParticles();
      });

    // Content fade controller for details text and buttons
    _contentFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start payment verification
    _verifyPayment();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _successController.dispose();
    _confettiController.dispose();
    _contentFadeController.dispose();
    super.dispose();
  }

  void _generateParticles() {
    final random = math.Random();
    _particles.clear();
    for (int i = 0; i < 40; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 2.0 + random.nextDouble() * 6.0;
      _particles.add(
        ConfettiParticle(
          x: 0.0,
          y: 0.0,
          vx: math.cos(angle) * speed,
          vy: math.sin(angle) * speed - (1.0 + random.nextDouble() * 2.0),
          color: HSLColor.fromAHSL(
            1.0,
            random.nextDouble() * 360,
            0.8,
            0.6,
          ).toColor(),
          size: 4.0 + random.nextDouble() * 6.0,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
        ),
      );
    }
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      for (var particle in _particles) {
        particle.x += particle.vx;
        particle.y += particle.vy;
        // Gravity
        particle.vy += 0.12;
        // Drag
        particle.vx *= 0.98;
        particle.vy *= 0.98;
        // Rotation
        particle.rotation += particle.rotationSpeed;
      }
    });
  }

  Future<void> _verifyPayment() async {
    try {
      final success = await AuthService.verifyPayment(
        billId: int.parse(widget.billId),
        orderId: widget.orderId,
      );

      if (!mounted) return;

      if (success) {
        setState(() {
          _status = PaymentStatus.success;
        });
        _loadingController.stop();
        
        // Trigger animations sequentially for high-end feel
        _successController.forward().then((_) {
          _generateParticles();
          _confettiController.forward();
          _contentFadeController.forward();
        });

        widget.onSuccess();
      } else {
        setState(() {
          _status = PaymentStatus.failed;
        });
        _loadingController.stop();
        _contentFadeController.forward();
        if (widget.onFailure != null) {
          widget.onFailure!();
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = PaymentStatus.failed;
      });
      _loadingController.stop();
      _contentFadeController.forward();
      if (widget.onFailure != null) {
        widget.onFailure!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 20,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            // width: double.infinity,
            width: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Confetti Particles Layer
                if (_status == PaymentStatus.success && _particles.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: ConfettiPainter(
                          particles: _particles,
                          progress: _confettiController.value,
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: _buildDialogContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent() {
    switch (_status) {
      case PaymentStatus.verifying:
        return _buildVerifyingContent();
      case PaymentStatus.success:
        return _buildSuccessContent();
      case PaymentStatus.failed:
        return _buildFailedContent();
    }
  }

  Widget _buildVerifyingContent() {
    return Column(
      key: const ValueKey('verifying'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _loadingController.value * 2 * math.pi,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 6,
                  ),
                ),
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 6,
                  value: 0.25 + (math.sin(_loadingController.value * math.pi) * 0.1),
                  strokeCap: StrokeCap.round,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        const Text(
          'Verifying Payment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Securing your transaction with the server.\nPlease do not close the app.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        // Premium Custom Animated Checkmark
        SizedBox(
          width: 100,
          height: 100,
          child: AnimatedBuilder(
            animation: _successController,
            builder: (context, child) {
              return CustomPaint(
                painter: SuccessTickPainter(progress: _successController.value),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        FadeTransition(
          opacity: _contentFadeController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _contentFadeController,
              curve: Curves.easeOutCubic,
            )),
            child: Column(
              children: [
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Receipt Generated Successfully',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Ticket / Receipt detail card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      _buildReceiptRow('Bill Number', widget.billNumber),
                      const Divider(height: 20, thickness: 1),
                      _buildReceiptRow('Payment ID', widget.paymentId.substring(0, math.min(15, widget.paymentId.length)) + '...'),
                      const Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Paid Amount',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            '₹${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Gradient / Action button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFailedContent() {
    return Column(
      key: const ValueKey('failed'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.shade100, width: 3),
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 44,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Verification Failed',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Payment verification failed on the server.\nPlease contact support with your payment ID.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildReceiptRow('Payment ID', widget.paymentId),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Custom Painter to draw the success circle and checkmark dynamically
class SuccessTickPainter extends CustomPainter {
  final double progress;

  SuccessTickPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final circlePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.green.shade50
      ..style = PaintingStyle.fill;

    // Draw background soft green circle
    canvas.drawCircle(center, radius, fillPaint);

    // Draw the green border outline based on first half of progress
    double circleProgress = progress < 0.5 ? progress * 2 : 1.0;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      circleProgress * 2 * math.pi,
      false,
      circlePaint,
    );

    // Draw checkmark based on second half of progress
    if (progress > 0.5) {
      double tickProgress = (progress - 0.5) * 2;
      final path = Path();
      
      // Start point of checkmark
      final start = Offset(size.width * 0.3, size.height * 0.5);
      final bend = Offset(size.width * 0.45, size.height * 0.65);
      final end = Offset(size.width * 0.7, size.height * 0.35);

      path.moveTo(start.dx, start.dy);

      if (tickProgress < 0.5) {
        // Drawing first segment (downwards to bend)
        double segmentProgress = tickProgress * 2;
        path.lineTo(
          start.dx + (bend.dx - start.dx) * segmentProgress,
          start.dy + (bend.dy - start.dy) * segmentProgress,
        );
      } else {
        // Drawing second segment (upwards to end)
        double segmentProgress = (tickProgress - 0.5) * 2;
        path.lineTo(bend.dx, bend.dy);
        path.lineTo(
          bend.dx + (end.dx - bend.dx) * segmentProgress,
          bend.dy + (end.dy - bend.dy) * segmentProgress,
        );
      }

      final tickPaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(path, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SuccessTickPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Confetti Particle model
class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double rotation = 0;
  double rotationSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotationSpeed,
  });
}

// Confetti burst painter
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.3); // Burst from the checkmark center

    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      // Translate to particle coordinates relative to center
      canvas.translate(center.dx + particle.x, center.dy + particle.y);
      canvas.rotate(particle.rotation);

      // Draw random particle shapes: rectangles or circles
      if (particle.size % 2 == 0) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 1.5),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return true;
  }
}
