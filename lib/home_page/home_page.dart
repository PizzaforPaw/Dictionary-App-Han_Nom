import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modernlogintute/home_page/add_word_page.dart';
import 'search_page.dart';
import 'package:modernlogintute/settings/settings_page.dart';
import 'news_page.dart';
import 'history_page.dart';
import 'package:modernlogintute/settings/theme_provider.dart';
import 'package:modernlogintute/settings/font_provider.dart';
import 'package:modernlogintute/settings/language_provider.dart';
import 'package:modernlogintute/settings/app_localization.dart';
import 'favorites_page.dart'; // Import Favorites Page

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign out function
  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDarkMode ? Colors.purpleAccent : Colors.blue;
    final textColor = isDarkMode ? Colors.white : const Color.fromARGB(255, 50, 50, 50);
    final fontSize = Provider.of<FontProvider>(context).fontSize;
    final languageProvider = Provider.of<LanguageProvider>(context); // Get language provider

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.getTranslation(context, "home"), style: TextStyle(fontSize: fontSize + 2)), // Dynamic title
          backgroundColor: themeColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showAboutDialogBox(context);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  AppLocalization.getTranslation(context, "Welcome !"), // Dynamic text
                  style: TextStyle(fontSize: fontSize),
                ),
                accountEmail: Text(
                  user.email!,
                  style: TextStyle(fontSize: fontSize - 2),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: themeColor),
                ),
                decoration: BoxDecoration(color: themeColor),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(AppLocalization.getTranslation(context, "home"), style: TextStyle(fontSize: fontSize)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.yellow),
                      title: Text(AppLocalization.getTranslation(context, "favorites"), style: TextStyle(fontSize: fontSize)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FavoritesPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(AppLocalization.getTranslation(context, "news"), style: TextStyle(fontSize: fontSize)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(AppLocalization.getTranslation(context, "history"), style: TextStyle(fontSize: fontSize)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: Text(AppLocalization.getTranslation(context, "add_word"), style: TextStyle(fontSize: fontSize)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddWordPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(AppLocalization.getTranslation(context, "settings"), style: TextStyle(fontSize: fontSize)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalization.getTranslation(context, "logout"), style: TextStyle(fontSize: fontSize)),
                onTap: () => signUserOut(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalization.getTranslation(context, "welcome"),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  Icons.menu_book,
                  size: 200,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAboutDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalization.getTranslation(context, "about_app")),
          content: Text(
            "${AppLocalization.getTranslation(context, "home")}: Hán - Nôm Dictionary\n"
            "Version: Early Access\n"
            "Developer: Trung super vip\n\n"
            "${AppLocalization.getTranslation(context, "about_app")}: This app is a dictionary app for people that want to learn Hán-Nôm",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalization.getTranslation(context, "close")),
            ),
          ],
        );
      },
    );
  }
}
