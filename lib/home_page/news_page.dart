import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDarkMode ? Colors.purpleAccent : Colors.blue; // Purple in dark mode, Blue in light mode
    final fontSize = Provider.of<FontProvider>(context).fontSize; // Get font size

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text("App News & Updates", style: TextStyle(fontSize: fontSize + 2)),
          backgroundColor: themeColor,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNewsTile(themeColor, fontSize, "Version 1.1.0 Released", "New search feature and UI improvements."),
            _buildNewsTile(themeColor, fontSize, "Dark Mode Added", "Users can now switch between light and dark themes."),
            _buildNewsTile(themeColor, fontSize, "Bug Fixes & Performance Enhancements", "Resolved login issues and improved speed."),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsTile(Color themeColor, double fontSize, String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.new_releases, color: themeColor), // Icon matches theme
      title: Text(
        title,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: themeColor), // Title matches theme
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: fontSize - 2), // Slightly smaller font for subtitle
      ),
    );
  }
}
