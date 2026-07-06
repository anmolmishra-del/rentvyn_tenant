import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';
import 'package:rentvyn_tenant/features/language/cubit/language_cubit.dart';
import 'package:rentvyn_tenant/features/language/state/language_state.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Language',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Choose your preferred language',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'You can change this anytime from settings.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _languageTile(
                  context,
                  title: 'English',
                  subtitle: 'English (US)',
                  code: 'en',
                  selected: state.locale.languageCode == 'en',
                ),
                const SizedBox(height: 12),
                _languageTile(
                  context,
                  title: 'తెలుగు',
                  subtitle: 'Telugu',
                  code: 'te',
                  selected: state.locale.languageCode == 'te',
                ),
                const SizedBox(height: 12),
                _languageTile(
                  context,
                  title: 'हिन्दी',
                  subtitle: 'Hindi',
                  code: 'hi',
                  selected: state.locale.languageCode == 'hi',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _languageTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String code,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () async {
        await context.read<LanguageCubit>().changeLanguage(code);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E5EA),
            width: selected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: selected ? AppColors.primary.withOpacity(0.18) : const Color(0xFFF1F1F6),
              child: Text(
                title.characters.first,
                style: TextStyle(
                  color: selected ? AppColors.primary : Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black38,
              ),
          ],
        ),
      ),
    );
  }
}
