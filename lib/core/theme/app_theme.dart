// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';

// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: AppColors.primary,
//         primary: AppColors.primary,
//         secondary: AppColors.secondary,
//       ),
//       useMaterial3: true,
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: AppColors.primary,
//         primary: AppColors.primary,
//         secondary: AppColors.secondary,
//         brightness: Brightness.dark,
//       ),
//       useMaterial3: true,
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: const Color(0xFFF7F8FA),

      cardColor: Colors.white,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),

      dividerColor: const Color(0xFFEAEAEA),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),

      cardColor: const Color(0xFF1E1E1E),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      dividerColor: Colors.white24,
    );
  }
}