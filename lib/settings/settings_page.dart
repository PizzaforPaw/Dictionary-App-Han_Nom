import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';
import 'package:modernlogintute/settings/language_provider.dart';
import 'package:modernlogintute/settings/app_localization.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDarkMode ? Colors.purpleAccent : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.getTranslation(context, "settings")),
        backgroundColor: themeColor,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            AppLocalization.getTranslation(context, "dark_mode"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor),
          ),
          SwitchListTile(
            title: Text(AppLocalization.getTranslation(context, "dark_mode"), style: TextStyle(fontSize: fontProvider.fontSize)),
            value: themeProvider.isDarkMode,
            activeColor: themeColor,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),

          const SizedBox(height: 20),

          Text(
            AppLocalization.getTranslation(context, "font_size"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor),
          ),
          Slider(
            value: fontProvider.fontSize,
            min: 12.0,
            max: 24.0,
            divisions: 6,
            label: "${fontProvider.fontSize.toStringAsFixed(1)}",
            onChanged: (value) {
              fontProvider.setFontSize(value);
            },
          ),

          const SizedBox(height: 20),

          Text(
            AppLocalization.getTranslation(context, "language"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor),
          ),
          DropdownButton<String>(
            value: languageProvider.locale.languageCode,
            items: [
              DropdownMenuItem(value: "en", child: Text(AppLocalization.getTranslation(context, "english"), style: TextStyle(fontSize: fontProvider.fontSize))),
              DropdownMenuItem(value: "vi", child: Text(AppLocalization.getTranslation(context, "vietnamese"), style: TextStyle(fontSize: fontProvider.fontSize))),
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                languageProvider.setLanguage(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
