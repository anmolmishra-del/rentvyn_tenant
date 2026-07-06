import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:rentvyn_tenant/features/auth/cubit/login_cubit.dart';
import 'package:rentvyn_tenant/features/language/cubit/language_cubit.dart';
import 'package:rentvyn_tenant/features/language/state/language_state.dart';
import 'package:rentvyn_tenant/features/roommate/cubit/roommate_cubit.dart';
import 'package:rentvyn_tenant/features/roommate/view/roommate_page.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
import 'package:rentvyn_tenant/features/notices/cubit/notice_cubit.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(),
        ),

        BlocProvider<TicketsCubit>(
          create: (_) => TicketsCubit(),
        ),
        BlocProvider<NoticeCubit>(
          create: (_) => NoticeCubit()..loadNotices(),
        ),
        BlocProvider(
          create: (_) =>
              LanguageCubit()..loadLanguage(),
        ),
        BlocProvider(
  create: (_) => RoommateCubit(),
)
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (BuildContext context, state) {  
            print(
      "MaterialApp Locale => ${state.locale.languageCode}",
    );
        return MaterialApp(
           locale: state.locale,

          title: AppConstants.appName,
               localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        
          supportedLocales:  [
            Locale('en'),
            Locale('te'),
            Locale('hi'),
          ],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          debugShowCheckedModeBanner: false,
        );
  }),
    );
  }
}