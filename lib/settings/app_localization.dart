import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

class AppLocalization {
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'favorites': 'Favorites',
      'search': 'Search',
      'history': 'History',
      'add_word': 'Add New Word',
      'settings': 'Settings',
      'news': 'App News & Updates',
      'dark_mode': 'Dark Mode',
      'font_size': 'Font Size',
      'language': 'Language',
      'vietnamese': 'Vietnamese',
      'english': 'English',
      'save': 'Save Word',
      'enter_word': 'Enter Vietnamese Word',
      'no_history': 'No history found.',
      'no_favorites': 'No favorite words yet!',
      'about_app': 'About This App',
      'welcome': 'Welcome back, what knowledge will we obtain today?',
    },
    'vi': {
      'home': 'Trang Chủ',
      'favorites': 'Yêu Thích',
      'search': 'Tìm Kiếm',
      'history': 'Lịch Sử',
      'add_word': 'Thêm Từ Mới',
      'settings': 'Cài Đặt',
      'news': 'Tin tức & Cập nhật',
      'dark_mode': 'Chế Độ Tối',
      'font_size': 'Cỡ Chữ',
      'language': 'Ngôn Ngữ',
      'vietnamese': 'Tiếng Việt',
      'english': 'Tiếng Anh',
      'save': 'Lưu Từ',
      'enter_word': 'Nhập từ Tiếng Việt',
      'no_history': 'Không có lịch sử tìm kiếm.',
      'no_favorites': 'Chưa có từ yêu thích!',
      'about_app': 'Giới Thiệu Ứng Dụng',
      'welcome': 'Chào mừng trở lại, hôm nay chúng ta sẽ học gì?',
    },
  };

  static String getTranslation(BuildContext context, String key) {
    final languageCode = Provider.of<LanguageProvider>(context).locale.languageCode;
    return _localizedValues[languageCode]?[key] ?? key;
  }
}
