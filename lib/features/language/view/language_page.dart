import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/features/language/cubit/language_cubit.dart';
import 'package:rentvyn_tenant/features/language/state/language_state.dart';


class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language',
        ),
      ),
      body: BlocBuilder<
          LanguageCubit,
          
          LanguageState>(
        builder: (
          context,
          state,
        ) {
          return Column(
            children: [
              _tile(
                context,
                title: 'English',
                code: 'en',
                selected:
                    state.locale.languageCode ==
                        'en',
              ),

              _tile(
                context,
                title: 'తెలుగు',
                code: 'te',
                selected:
                    state.locale.languageCode ==
                        'te',
              ),

              _tile(
                context,
                title: 'हिन्दी',
                code: 'hi',
                selected:
                    state.locale.languageCode ==
                        'hi',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required String code,
    required bool selected,
  }) {
    return ListTile(
      title: Text(title),
      trailing: selected
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : null,
     onTap: () async {
  await context
      .read<LanguageCubit>()
      .changeLanguage(code);

  print(
    "Selected => $code",
  );

  Navigator.pop(context);
}
    );
  }
}