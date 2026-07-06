import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentvyn_tenant/core/theme/theme_provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      
      body: ListView(
        children: [
          // SwitchListTile(
          //   secondary: const Icon(Icons.dark_mode),
          //   title: const Text("Dark Mode"),
          //   subtitle: const Text("Enable dark appearance"),
          //   value: provider.isDarkMode,
          //   onChanged: provider.toggleTheme,
          // ),

        ],
      ),
    );
  }
}