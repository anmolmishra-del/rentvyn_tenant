import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:rentvyn_tenant/features/auth/cubit/login_cubit.dart';
import 'package:rentvyn_tenant/features/language/cubit/language_cubit.dart';
import 'package:rentvyn_tenant/features/language/state/language_state.dart';
import 'package:rentvyn_tenant/features/roommate/cubit/roommate_cubit.dart';
import 'package:rentvyn_tenant/features/tickets/cubit/ticket_cubit.dart';
import 'package:rentvyn_tenant/features/notices/cubit/notice_cubit.dart';
import 'package:rentvyn_tenant/features/payments/cubit/pg_contact_cubit.dart';
import 'package:rentvyn_tenant/features/payments/cubit/bills_cubit.dart';
import 'package:rentvyn_tenant/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    await dotenv.load(fileName: "assets/env");
    print("DOTENV LOADED KEYS => ${dotenv.env.keys}");
    print("DOTENV RAZORPAY_KEY_ID => ${dotenv.env['RAZORPAY_KEY_ID']}");
  } catch (e) {
    print("Error loading env file: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<TicketsCubit>(create: (_) => TicketsCubit()),
        BlocProvider<NoticeCubit>(create: (_) => NoticeCubit()..loadNotices()),
        BlocProvider(create: (_) => LanguageCubit()..loadLanguage()),
        BlocProvider(create: (_) => RoommateCubit()),
        BlocProvider<PgContactCubit>(create: (_) => PgContactCubit()..loadPgContact()),
        BlocProvider<BillsCubit>(create: (_) => BillsCubit()..loadBills()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return BlocBuilder<LanguageCubit, LanguageState>(
              builder: (BuildContext context, state) {
                return MaterialApp(
                  locale: state.locale,
                  title: AppConstants.appName,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'),
                    Locale('te'),
                    Locale('hi'),
                  ],
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.themeMode,
                  initialRoute: AppRoutes.splash,
                  onGenerateRoute: AppRoutes.generateRoute,
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}