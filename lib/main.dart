// ============================================================================
// SELURUH KODE APLIKASI DIGABUNG DALAM SATU FILE (main.dart)
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ===== asal: lib/l10n/app_language.dart =====
enum AppLanguage {
  indonesian('id'),
  english('en');

  const AppLanguage(this.code);

  final String code;

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.indonesian,
    );
  }
}

// ===== asal: lib/l10n/app_strings.dart =====


class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get _en => language == AppLanguage.english;

  static const AppStrings indonesian = AppStrings(AppLanguage.indonesian);
  static const AppStrings english = AppStrings(AppLanguage.english);

  static AppStrings of(AppLanguage language) {
    return language == AppLanguage.english ? english : indonesian;
  }

  String t(String id, String en) => _en ? en : id;

  // Sidebar / navigation
  String get navHome => t('Beranda', 'Home');
  String get navSettings => t('Pengaturan', 'Settings');
  String get brandName => 'PERSIB';
  String get brandSubtitle => t('Quiz 2026/27', '2026/27 Quiz');

  // Home
  String get welcomeTitle => t('Selamat datang, Bobotoh!', 'Welcome, Bobotoh!');
  String get welcomeSubtitle => t(
        'Uji pengetahuanmu tentang PERSIB Bandung\ndan raih gelar Bobotoh Sejati!',
        'Test your knowledge about PERSIB Bandung\nand earn the True Bobotoh title!',
      );
  String get startQuiz => t('MULAI KUIS', 'START QUIZ');
  String get statBest => t('TERBAIK', 'BEST');
  String get statQuiz => t('KUIS', 'QUIZZES');
  String get statAverage => t('RATA-RATA', 'AVERAGE');
  String get footerTag => 'PERSIB • MAUNG BANDUNG • BOBOTOH';

  // Quiz
  String get chooseAnswer =>
      t('Pilih jawaban yang paling tepat', 'Choose the most accurate answer');
  String get correctFeedback => t('BENAR! Jawaban +1', 'CORRECT! +1 point');
  String wrongFeedback(String letter) =>
      t('KURANG TEPAT! Jawaban: $letter', 'NOT QUITE! Answer: $letter');
  String get quizAppTitle => 'PERSIB QUIZ';
  String questionProgress(int current, int total) =>
      t('Soal $current dari $total', 'Question $current of $total');

  // Result
  String get quizComplete => t('KUIS SELESAI!', 'QUIZ COMPLETE!');
  String goodJob(String name) => t('Kerja bagus, $name!', 'Good job, $name!');
  String get yourScore => t('SKOR KAMU', 'YOUR SCORE');
  String get retryQuiz => t('ULANGI KUIS', 'RETRY QUIZ');
  String get backHome => t('KEMBALI KE BERANDA', 'BACK TO HOME');
  String get playerLabel => 'Bobotoh';

  String resultTitle(int percentage) {
    if (percentage >= 90) return t('BOBOTOH SEJATI!', 'TRUE BOBOTOH!');
    if (percentage >= 75) return t('LUAR BIASA!', 'EXCELLENT!');
    if (percentage >= 60) return t('BAGUS!', 'GOOD!');
    if (percentage >= 40) return t('LUMAYAN!', 'DECENT!');
    return t('TETAP SEMANGAT!', 'KEEP GOING!');
  }

  String resultDescription(int percentage) {
    if (percentage >= 90) {
      return t(
        'Pengetahuanmu tentang PERSIB sangat luar biasa.',
        'Your knowledge about PERSIB is truly outstanding.',
      );
    }
    if (percentage >= 75) {
      return t(
        'Kamu cukup memahami skuad dan perjalanan PERSIB.',
        'You understand the PERSIB squad and journey quite well.',
      );
    }
    if (percentage >= 60) {
      return t(
        'Hasil yang bagus. Tinggal perdalam lagi pengetahuanmu.',
        'Good result. Just deepen your knowledge a bit more.',
      );
    }
    if (percentage >= 40) {
      return t(
        'Lumayan, tetapi masih ada beberapa hal yang perlu dipelajari.',
        'Decent, but there are still some things to learn.',
      );
    }
    return t(
      'Jangan menyerah. Pelajari lagi skuad PERSIB dan coba kembali.',
      "Don't give up. Study the PERSIB squad again and try once more.",
    );
  }

  // Common
  String get cancel => t('Batal', 'Cancel');
  String get delete => t('HAPUS', 'DELETE');

  List<String> get months => _en
      ? const [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ]
      : const [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];

  // Settings
  String get settingsTitle => t('PENGATURAN', 'SETTINGS');
  String get musicSection => t('LAGU PENGIRING', 'BACKGROUND MUSIC');
  String get volumeLabel => t('Volume Lagu', 'Music Volume');
  String get musicInfo => t(
        'Lagu pengiring diputar otomatis dan berulang selama aplikasi berjalan.',
        'Background music plays automatically and loops while the app is running.',
      );
  String get languageSection => t('BAHASA', 'LANGUAGE');
  String get languageLabel => t('Bahasa Aplikasi', 'App Language');
  String get languageIndonesian => 'Indonesia';
  String get languageEnglish => 'English';
  String get languageInfo => t(
        'Pilih bahasa untuk seluruh tampilan aplikasi dan soal kuis.',
        'Choose the language for the entire app interface and quiz questions.',
      );

  // Question categories
  String category(String id) {
    switch (id) {
      case 'Sejarah':
        return t('Sejarah', 'History');
      case 'Julukan':
        return t('Julukan', 'Nickname');
      case 'Stadion':
        return t('Stadion', 'Stadium');
      case 'Kota':
        return t('Kota', 'City');
      case 'Suporter':
        return t('Suporter', 'Supporters');
      case 'Warna Klub':
        return t('Warna Klub', 'Club Colors');
      case 'Prestasi':
        return t('Prestasi', 'Achievements');
      case 'Pelatih':
        return t('Pelatih', 'Coach');
      case 'Pemain':
        return t('Pemain', 'Player');
      case 'Kompetisi':
        return t('Kompetisi', 'Competition');
      case 'Rivalitas':
        return t('Rivalitas', 'Rivalry');
      case 'Bobotoh':
        return 'Bobotoh';
      case 'Pemain Legendaris':
        return t('Pemain Legendaris', 'Legendary Player');
      case 'Klub':
        return t('Klub', 'Club');
      case 'Skuad':
        return t('Skuad', 'Squad');
      case 'Skuad 2026/27':
        return t('Skuad 2026/27', 'Squad 2026/27');
      case 'Musim 2026/27':
        return t('Musim 2026/27', '2026/27 Season');
      default:
        return id;
    }
  }
}

class AppStringsScope extends InheritedWidget {
  final AppStrings strings;

  const AppStringsScope({
    super.key,
    required this.strings,
    required super.child,
  });

  static AppStrings of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStringsScope>();
    return scope?.strings ?? AppStrings.indonesian;
  }

  @override
  bool updateShouldNotify(AppStringsScope oldWidget) {
    return strings.language != oldWidget.strings.language;
  }
}

// ===== asal: lib/models/app_settings.dart =====

class AppSettings {
  final double musicVolume;
  final AppLanguage language;

  static const double defaultMusicVolume = 1.0;

  const AppSettings({
    this.musicVolume = defaultMusicVolume,
    this.language = AppLanguage.indonesian,
  });

  AppSettings copyWith({
    double? musicVolume,
    AppLanguage? language,
  }) {
    return AppSettings(
      musicVolume: musicVolume ?? this.musicVolume,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicVolume': musicVolume,
      'language': language.code,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      musicVolume: (json['musicVolume'] as num?)?.toDouble() ??
          defaultMusicVolume,
      language: AppLanguage.fromCode(json['language'] as String?),
    );
  }
}

// ===== asal: lib/models/question.dart =====

class Question {
  final String question;
  final List<String> options;
  final int answer;
  final String category;
  final String? questionEn;
  final List<String>? optionsEn;

  const Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.category,
    this.questionEn,
    this.optionsEn,
  });

  String text(AppLanguage language) {
    if (language == AppLanguage.english) {
      return questionEn ?? question;
    }
    return question;
  }

  List<String> optionTexts(AppLanguage language) {
    if (language == AppLanguage.english) {
      return optionsEn ?? options;
    }
    return options;
  }
}

// ===== asal: lib/models/quiz_result.dart =====
class QuizResult {
  final String playerName;
  final int score;
  final int total;
  final DateTime finishedAt;

  const QuizResult({
    required this.playerName,
    required this.score,
    required this.total,
    required this.finishedAt,
  });

  int get percentage => total == 0 ? 0 : (score / total * 100).round();

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'score': score,
      'total': total,
      'finishedAt': finishedAt.toIso8601String(),
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      playerName: json['playerName'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      finishedAt:
          DateTime.tryParse(json['finishedAt'] as String? ?? '') ??
              DateTime.now(),
    );
  }
}

// ===== asal: lib/theme/persib_theme.dart =====

class PersibColors {
  PersibColors._();

  static const Color navyDark = Color(0xFF051233);
  static const Color navy = Color(0xFF0A2350);
  static const Color blue = Color(0xFF0B4EA2);
  static const Color sky = Color(0xFF2E7BE6);
  static const Color lightBlue = Color(0xFFEAF2FF);
  static const Color gold = Color(0xFFFFC400);
  static const Color green = Color(0xFF10B981);
  static const Color red = Color(0xFFEF4444);
  static const Color ink = Color(0xFF16233B);
  static const Color slate = Color(0xFF5B6B84);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2E7BE6),
      Color(0xFF0B4EA2),
      Color(0xFF0A2350),
    ],
  );
}

// ===== asal: lib/data/questions.dart =====

const List<Question> questions = [
  Question(
    category: 'Sejarah',
    question: 'Pada tahun berapa PERSIB Bandung didirikan?',
    questionEn: 'In what year was PERSIB Bandung founded?',
    options: [
      '1919',
      '1933',
      '1945',
      '1960',
    ],
    answer: 1,
  ),

  Question(
    category: 'Klub',
    question: 'Nama "PERSIB" merupakan singkatan dari...',
    questionEn: 'The name "PERSIB" stands for...',
    options: [
      'Perserikatan Sepak Bola Indonesia Bandung',
      'Persatuan Sepak Bola Indonesia Barat',
      'Perkumpulan Sepak Bola Indonesia Bandung',
      'Persatuan Sepak Bola Indonesia Bandung',
    ],
    answer: 3,
  ),

  Question(
    category: 'Kota',
    question: 'PERSIB merupakan klub sepak bola yang berasal dari kota...',
    questionEn: 'PERSIB is a football club that originates from the city of...',
    options: [
      'Bandung',
      'Jakarta',
      'Surabaya',
      'Medan',
    ],
    optionsEn: [
      'Bandung',
      'Jakarta',
      'Surabaya',
      'Medan',
    ],
    answer: 0,
  ),

  Question(
    category: 'Sejarah',
    question: 'PERSIB merupakan klub yang berasal dari provinsi...',
    questionEn: 'PERSIB is a club that originates from the province of...',
    options: [
      'Jawa Tengah',
      'Jawa Timur',
      'Jawa Barat',
      'Banten',
    ],
    optionsEn: [
      'Central Java',
      'East Java',
      'West Java',
      'Banten',
    ],
    answer: 2,
  ),

  Question(
    category: 'Julukan',
    question: 'Apa julukan yang paling dikenal untuk PERSIB Bandung?',
    questionEn: 'What is the most well-known nickname for PERSIB Bandung?',
    options: [
      'Laskar Sape Kerrab',
      'Maung Bandung',
      'Bajul Ijo',
      'Juku Eja',
    ],
    answer: 1,
  ),

  Question(
    category: 'Julukan',
    question: 'Selain Maung Bandung, julukan lain untuk PERSIB adalah...',
    questionEn: 'Besides Maung Bandung, another nickname for PERSIB is...',
    options: [
      'Laskar Merah',
      'Singo Edan',
      'Pangeran Biru',
      'Serigala Jaya',
    ],
    answer: 2,
  ),

  Question(
    category: 'Suporter',
    question: 'Sebutan yang umum digunakan untuk pendukung PERSIB adalah...',
    questionEn: 'What is the common term used for PERSIB supporters?',
    options: [
      'The Jakmania',
      'Bonek',
      'Aremania',
      'Bobotoh',
    ],
    answer: 3,
  ),

  Question(
    category: 'Warna Klub',
    question: 'Warna yang paling identik dengan PERSIB adalah...',
    questionEn: 'The color most closely identified with PERSIB is...',
    options: [
      'Biru',
      'Merah',
      'Hijau',
      'Putih',
    ],
    optionsEn: [
      'Blue',
      'Red',
      'Green',
      'White',
    ],
    answer: 0,
  ),

  Question(
    category: 'Stadion',
    question: 'Stadion kandang yang digunakan PERSIB pada musim 2026/2027 adalah...',
    questionEn: 'The home stadium used by PERSIB in the 2026/2027 season is...',
    options: [
      'Gelora Bung Karno',
      'Si Jalak Harupat',
      'Gelora Bandung Lautan Api',
      'Stadion Manahan',
    ],
    answer: 2,
  ),

  Question(
    category: 'Stadion',
    question: 'Stadion Gelora Bandung Lautan Api berada di wilayah...',
    questionEn: 'Gelora Bandung Lautan Api Stadium is located in the area of...',
    options: [
      'Gedebage',
      'Lembang',
      'Cimahi',
      'Soreang',
    ],
    answer: 0,
  ),

  Question(
    category: 'Stadion',
    question:
        'Selain GBLA, PERSIB juga pernah menggunakan stadion di Kabupaten Bandung yang bernama...',
    questionEn:
        'Besides GBLA, PERSIB has also used a stadium in Bandung Regency called...',
    options: [
      'Kanjuruhan',
      'Si Jalak Harupat',
      'Jatidiri',
      'Manahan',
    ],
    answer: 1,
  ),

  Question(
    category: 'Rivalitas',
    question:
        'Salah satu rival terbesar PERSIB di sepak bola Indonesia adalah...',
    questionEn: 'One of PERSIB biggest rivals in Indonesian football is...',
    options: [
      'PSM Makassar',
      'Madura United',
      'Barito Putera',
      'Persija Jakarta',
    ],
    answer: 3,
  ),

  Question(
    category: 'Prestasi',
    question:
        'PERSIB meraih gelar juara Liga Indonesia pada tahun 2014 setelah mengalahkan...',
    questionEn:
        'PERSIB won the Indonesian League title in 2014 after defeating...',
    options: [
      'Arema FC',
      'Persija Jakarta',
      'Bali United',
      'Persipura Jayapura',
    ],
    answer: 3,
  ),

  Question(
    category: 'Pelatih',
    question: 'Siapa pelatih PERSIB saat meraih gelar Liga 1 2023/2024?',
    questionEn:
        'Who was the PERSIB coach when they won the 2023/2024 Liga 1 title?',
    options: [
      'Robert Alberts',
      'Bojan Hodak',
      'Luis Milla',
      'Mario Gomez',
    ],
    answer: 1,
  ),

  Question(
    category: 'Prestasi',
    question: 'PERSIB berhasil menjadi juara Liga 1 pada musim...',
    questionEn: 'PERSIB became Liga 1 champions in the season...',
    options: [
      '2017/2018',
      '2019/2020',
      '2023/2024',
      '2021/2022',
    ],
    answer: 2,
  ),

  Question(
    category: 'Pemain Legendaris',
    question:
        'Robby Darwis merupakan salah satu pemain yang dikenal sebagai legenda...',
    questionEn:
        'Robby Darwis is one of the players known as a legend of...',
    options: [
      'PERSIB',
      'Persija',
      'Arema',
      'PSM',
    ],
    answer: 0,
  ),

  Question(
    category: 'Pelatih',
    question: 'Siapa kepala pelatih yang menangani PERSIB pada musim 2026/2027?',
    questionEn:
        'Who is the head coach in charge of PERSIB in the 2026/2027 season?',
    options: [
      'Igor Tolic',
      'Bojan Hodak',
      'Robert Alberts',
      'Luis Milla',
    ],
    answer: 0,
  ),

  Question(
    category: 'Skuad 2026/27',
    question: 'Siapa kapten tim PERSIB pada skuad 2026/2027?',
    questionEn: 'Who is the PERSIB team captain in the 2026/2027 squad?',
    options: [
      'Teja Paku Alam',
      'Beckham Putra',
      'Marc Klok',
      'Dedi Kusnandar',
    ],
    answer: 2,
  ),

  Question(
    category: 'Skuad 2026/27',
    question:
        'Pemain PERSIB 2026/2027 yang memakai nomor punggung 10 adalah...',
    questionEn:
        'The PERSIB 2026/2027 player wearing jersey number 10 is...',
    options: [
      'Balsa Sekulic',
      'Mariano Peralta',
      'Luka Menalo',
      'Gakuto Notsuda',
    ],
    answer: 1,
  ),

  Question(
    category: 'Skuad 2026/27',
    question:
        'Pemain PERSIB 2026/2027 yang memakai nomor punggung 99 adalah...',
    questionEn:
        'The PERSIB 2026/2027 player wearing jersey number 99 is...',
    options: [
      'Mariano Peralta',
      'Uilliam Barros',
      'Danijel Loncar',
      'Balsa Sekulic',
    ],
    answer: 3,
  ),

  Question(
    category: 'Musim 2026/27',
    question:
        'Pemain PERSIB 2026/2027 yang dikenal dengan julukan "ETAM" adalah...',
    questionEn:
        'The PERSIB 2026/2027 player known by the nickname "ETAM" is...',
    options: [
      'Marc Klok',
      'Dedi Kusnandar',
      'Beckham Putra Nugraha',
      'Febri Hariyadi',
    ],
    answer: 2,
  ),

  Question(
    category: 'Musim 2026/27',
    question:
        'Siapa penjaga gawang yang memperkuat PERSIB pada musim 2026/2027?',
    questionEn:
        'Who is the goalkeeper playing for PERSIB in the 2026/2027 season?',
    options: [
      'Marc Klok',
      'Adam Alis',
      'Beckham Putra',
      'Teja Paku Alam',
    ],
    answer: 3,
  ),

  Question(
    category: 'Skuad',
    question: 'Gakuto Notsuda merupakan pemain asal...',
    questionEn: 'Gakuto Notsuda is a player from...',
    options: [
      'Jepang',
      'Korea Selatan',
      'Australia',
      'Thailand',
    ],
    optionsEn: [
      'Japan',
      'South Korea',
      'Australia',
      'Thailand',
    ],
    answer: 0,
  ),

  Question(
    category: 'Skuad',
    question: 'Balsa Sekulic merupakan pemain yang berasal dari negara...',
    questionEn: 'Balsa Sekulic is a player who comes from the country...',
    options: [
      'Serbia',
      'Montenegro',
      'Kroasia',
      'Slovenia',
    ],
    optionsEn: [
      'Serbia',
      'Montenegro',
      'Croatia',
      'Slovenia',
    ],
    answer: 1,
  ),

  Question(
    category: 'Skuad',
    question:
        'Pemain asal Prancis yang memperkuat PERSIB 2026/2027 adalah...',
    questionEn:
        'The French player who strengthens PERSIB 2026/2027 is...',
    options: [
      'Gakuto Notsuda',
      'Gabriel Mutombo',
      'Mariano Peralta',
      'Danijel Loncar',
    ],
    answer: 1,
  ),

  Question(
    category: 'Skuad',
    question:
        'Pemain asal Kroasia yang memperkuat PERSIB 2026/2027 adalah...',
    questionEn:
        'The Croatian player who strengthens PERSIB 2026/2027 is...',
    options: [
      'Danijel Loncar',
      'Gabriel Mutombo',
      'Julio Cesar',
      'Luciano Guaycochea',
    ],
    answer: 0,
  ),

  Question(
    category: 'Skuad',
    question:
        'Penyerang asal Argentina yang memperkuat PERSIB 2026/2027 adalah...',
    questionEn:
        'The Argentine striker who strengthens PERSIB 2026/2027 is...',
    options: [
      'Luciano Guaycochea',
      'Patricio Matricardi',
      'Julio Cesar',
      'Mariano Peralta',
    ],
    answer: 3,
  ),

  Question(
    category: 'Skuad',
    question:
        'Bek asal Brasil yang memperkuat PERSIB 2026/2027 adalah...',
    questionEn:
        'The Brazilian defender who strengthens PERSIB 2026/2027 is...',
    options: [
      'Uilliam Barros',
      'Berguinho',
      'Julio Cesar',
      'Luka Menalo',
    ],
    answer: 2,
  ),

  Question(
    category: 'Pemain',
    question: 'Marc Klok merupakan pemain yang berposisi sebagai...',
    questionEn: 'Marc Klok is a player who plays as a...',
    options: [
      'Penjaga gawang',
      'Bek tengah',
      'Penyerang',
      'Gelandang',
    ],
    optionsEn: [
      'Goalkeeper',
      'Center back',
      'Striker',
      'Midfielder',
    ],
    answer: 3,
  ),

  Question(
    category: 'Pemain',
    question:
        'Dedi Kusnandar dikenal sebagai pemain yang berposisi sebagai...',
    questionEn: 'Dedi Kusnandar is known as a player who plays as a...',
    options: [
      'Penjaga gawang',
      'Penyerang',
      'Gelandang',
      'Bek kanan',
    ],
    optionsEn: [
      'Goalkeeper',
      'Striker',
      'Midfielder',
      'Right back',
    ],
    answer: 2,
  ),

  Question(
    category: 'Pemain',
    question:
        'Febri Hariyadi dikenal sebagai pemain yang bermain di posisi...',
    questionEn:
        'Febri Hariyadi is known as a player who plays in the position of...',
    options: [
      'Sayap',
      'Penjaga gawang',
      'Bek tengah',
      'Striker murni',
    ],
    optionsEn: [
      'Winger',
      'Goalkeeper',
      'Center back',
      'Pure striker',
    ],
    answer: 0,
  ),

  Question(
    category: 'Pemain',
    question:
        'Sandy Walsh merupakan pemain yang dapat bermain di posisi...',
    questionEn:
        'Sandy Walsh is a player who can play in the position of...',
    options: [
      'Penyerang',
      'Bek',
      'Penjaga gawang',
      'Gelandang serang',
    ],
    optionsEn: [
      'Striker',
      'Defender',
      'Goalkeeper',
      'Attacking midfielder',
    ],
    answer: 1,
  ),

  Question(
    category: 'Pemain',
    question:
        'Thom Haye merupakan pemain yang memiliki posisi utama sebagai...',
    questionEn: 'Thom Haye is a player whose main position is...',
    options: [
      'Gelandang',
      'Penjaga gawang',
      'Penyerang',
      'Bek kanan',
    ],
    optionsEn: [
      'Midfielder',
      'Goalkeeper',
      'Striker',
      'Right back',
    ],
    answer: 0,
  ),

  Question(
    category: 'Pemain',
    question:
        'Ragnar Oratmangoen dikenal sebagai pemain yang dapat bermain di lini...',
    questionEn:
        'Ragnar Oratmangoen is known as a player who can play in the... line',
    options: [
      'Pertahanan',
      'Serang',
      'Penjaga gawang',
      'Wasit',
    ],
    optionsEn: [
      'Defense',
      'Attack',
      'Goalkeeper',
      'Referee',
    ],
    answer: 1,
  ),

  Question(
    category: 'Skuad 2026/27',
    question:
        'Berapa jumlah pemain asing dalam skuad PERSIB pada musim 2026/2027?',
    questionEn:
        'How many foreign players are in the PERSIB squad for the 2026/2027 season?',
    options: [
      '8',
      '10',
      '12',
      '14',
    ],
    answer: 2,
  ),

  Question(
    category: 'Skuad 2026/27',
    question:
        'Berapa total pemain yang memperkuat PERSIB pada musim 2026/2027?',
    questionEn:
        'How many players in total strengthen PERSIB in the 2026/2027 season?',
    options: [
      '24',
      '28',
      '36',
      '32',
    ],
    answer: 3,
  ),

  Question(
    category: 'Kompetisi',
    question:
        'Kompetisi antarklub Asia yang diikuti PERSIB pada musim 2026/2027 adalah...',
    questionEn:
        'The Asian club competition PERSIB participates in during the 2026/2027 season is...',
    options: [
      'UEFA Champions League',
      'Copa Libertadores',
      'AFC Champions League Two',
      'AFC Asian Cup',
    ],
    answer: 2,
  ),

  Question(
    category: 'Kompetisi',
    question:
        'PERSIB juga berkompetisi di ajang antarklub ASEAN yang dikenal sebagai...',
    questionEn:
        'PERSIB also competes in the ASEAN club competition known as...',
    options: [
      'Piala AFF',
      'Shopee Cup',
      'SEA Games',
      'Piala Asia',
    ],
    answer: 1,
  ),

  Question(
    category: 'Skuad 2026/27',
    question:
        'Salah satu pemain PERSIB 2026/2027 yang memiliki pengalaman bermain di Liga Thailand adalah...',
    questionEn:
        'One of the PERSIB 2026/2027 players with experience playing in the Thai League is...',
    options: [
      'Thom Haye',
      'Ragnar Oratmangoen',
      'Beckham Putra',
      'Sandy Walsh',
    ],
    answer: 3,
  ),

  Question(
    category: 'Skuad 2026/27',
    question:
        'Gelandang asal Argentina di skuad PERSIB 2026/2027 adalah...',
    questionEn:
        'The Argentine midfielder in the PERSIB 2026/2027 squad is...',
    options: [
      'Luciano Guaycochea',
      'Mariano Peralta',
      'Patricio Matricardi',
      'Julio Cesar',
    ],
    answer: 0,
  ),
];

// ===== asal: lib/services/storage_service.dart =====



class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const String _kHistoryKey = 'persib_quiz_history_v1';
  static const String _kSettingsKey = 'persib_quiz_settings_v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<AppSettings> loadSettings() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_kSettingsKey);
    if (raw == null) return const AppSettings();

    try {
      return AppSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await _prefs;
    await prefs.setString(_kSettingsKey, jsonEncode(settings.toJson()));
  }

  Future<List<QuizResult>> loadHistory() async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_kHistoryKey) ?? [];
    final results = <QuizResult>[];

    for (final raw in list) {
      try {
        results.add(
          QuizResult.fromJson(
            jsonDecode(raw) as Map<String, dynamic>,
          ),
        );
      } catch (_) {
        // Lewati data yang rusak.
      }
    }

    results.sort((a, b) => b.finishedAt.compareTo(a.finishedAt));
    return results;
  }

  Future<void> saveResult(QuizResult result) async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_kHistoryKey) ?? [];
    list.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_kHistoryKey, list);
  }

  Future<void> clearHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_kHistoryKey);
  }
}

// ===== asal: lib/services/locale_service.dart =====


class LocaleService extends ChangeNotifier {
  LocaleService._();

  static final LocaleService instance = LocaleService._();

  AppLanguage _language = AppLanguage.indonesian;

  AppLanguage get language => _language;

  AppStrings get strings => AppStrings.of(_language);

  Future<void> init() async {
    final settings = await StorageService.instance.loadSettings();
    _language = settings.language;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) return;

    _language = language;
    notifyListeners();

    final settings = await StorageService.instance.loadSettings();
    await StorageService.instance.saveSettings(
      settings.copyWith(language: language),
    );
  }
}

// ===== asal: lib/services/music_service.dart =====


class MusicService {
  MusicService._();

  static final MusicService instance = MusicService._();

  static const String _assetPath = 'assets/audio/ssstik.io_1789544002259.mp3';

  AudioPlayer? _player;
  double _volume = AppSettings.defaultMusicVolume;
  bool _ready = false;
  bool _waitingForGesture = false;

  double get volume => _volume;

  Future<void> init() async {
    try {
      final settings = await StorageService.instance.loadSettings();
      _volume = settings.musicVolume;

      _player ??= AudioPlayer();
      await _player!.setAsset(_assetPath);
      await _player!.setLoopMode(LoopMode.one);
      await _player!.setVolume(_volume);
      _ready = true;

      await _tryPlay();
    } on Object catch (err, stack) {
      debugPrint('[Music] init gagal: $err\n$stack');
    }
  }

  Future<void> _tryPlay() async {
    if (!_ready || _player == null) return;
    try {
      await _player!.play();
      _waitingForGesture = false;
    } on Object catch (err) {
      if (!kIsWeb) {
        debugPrint('[Music] play gagal: $err');
      } else {
        _waitingForGesture = true;
      }
    }
  }

  /// Browser memblokir audio sebelum ada interaksi pengguna.
  /// Panggil ini saat sentuhan/klik pertama.
  Future<void> enableAfterGesture() async {
    if (!_waitingForGesture) return;
    _waitingForGesture = false;
    await _tryPlay();
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    await _player?.setVolume(value);
  }
}

// ===== asal: lib/widgets/persib_logo_badge.dart =====

class PersibLogoBadge extends StatelessWidget {
  final double size;

  const PersibLogoBadge({
    super.key,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/persib_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

// ===== asal: lib/widgets/gradient_button.dart =====


class GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: PersibColors.brandGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: PersibColors.blue.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== asal: lib/widgets/timer_ring.dart =====


class TimerRing extends StatelessWidget {
  final int remaining;
  final int total;

  const TimerRing({
    super.key,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : remaining / total;
    final danger = remaining <= 10;
    final color = danger ? PersibColors.red : PersibColors.gold;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: fraction,
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$remaining',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'DETIK',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== asal: lib/widgets/quiz_header.dart =====


class QuizHeader extends StatelessWidget {
  final int current;
  final int total;
  final int score;
  final int remaining;
  final int fullSeconds;

  const QuizHeader({
    super.key,
    required this.current,
    required this.total,
    required this.score,
    required this.remaining,
    required this.fullSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);
    final progress = (current / total).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            const PersibLogoBadge(size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.quizAppTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        strings.questionProgress(current, total),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: PersibColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emoji_events_rounded,
                              size: 12,
                              color: PersibColors.gold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$score',
                              style: const TextStyle(
                                color: PersibColors.gold,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            TimerRing(remaining: remaining, total: fullSeconds),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(
              PersibColors.gold,
            ),
          ),
        ),
      ],
    );
  }
}

// ===== asal: lib/widgets/answer_card.dart =====


class AnswerCard extends StatelessWidget {
  final String letter;
  final String answer;
  final bool selected;
  final bool isCorrect;
  final bool revealed;
  final VoidCallback onTap;

  const AnswerCard({
    super.key,
    required this.letter,
    required this.answer,
    required this.selected,
    required this.isCorrect,
    required this.revealed,
    required this.onTap,
  });

  Color get _backgroundColor {
    if (!revealed) {
      return selected ? PersibColors.lightBlue : Colors.white;
    }
    if (isCorrect) return const Color(0xFFE8FBF3);
    if (selected) return const Color(0xFFFDEBEC);
    return Colors.white;
  }

  Color get _borderColor {
    if (!revealed) {
      return selected ? PersibColors.blue : const Color(0xFFDCE5EF);
    }
    if (isCorrect) return PersibColors.green;
    if (selected) return PersibColors.red;
    return const Color(0xFFDCE5EF);
  }

  Color get _badgeColor {
    if (!revealed) {
      return selected ? PersibColors.blue : const Color(0xFFEAF2FA);
    }
    if (isCorrect) return PersibColors.green;
    if (selected) return PersibColors.red;
    return const Color(0xFFEAF2FA);
  }

  Color get _badgeTextColor {
    if (!revealed) {
      return selected ? Colors.white : PersibColors.blue;
    }
    if (isCorrect) return Colors.white;
    if (selected) return Colors.white;
    return PersibColors.blue;
  }

  Widget? get _trailingIcon {
    if (!revealed) {
      return selected
          ? const Icon(Icons.check_circle, color: PersibColors.blue)
          : null;
    }
    if (isCorrect) {
      return const Icon(Icons.check_circle, color: PersibColors.green);
    }
    if (selected) {
      return const Icon(Icons.cancel_rounded, color: PersibColors.red);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final dimmed = revealed && !isCorrect && !selected;
    final highlighted = revealed && (isCorrect || selected);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: revealed ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _borderColor,
              width: highlighted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: revealed ? 0.03 : 0.06,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _badgeTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: dimmed ? 0.45 : 1.0,
                  child: Text(
                    answer,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: (revealed && isCorrect) || selected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: PersibColors.ink,
                    ),
                  ),
                ),
              ),
              if (_trailingIcon != null) ...[
                const SizedBox(width: 8),
                _trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ===== asal: lib/widgets/hero_logo.dart =====



class HeroLogo extends StatefulWidget {
  final double size;

  const HeroLogo({
    super.key,
    this.size = 168,
  });

  @override
  State<HeroLogo> createState() => _HeroLogoState();
}

class _HeroLogoState extends State<HeroLogo>
    with TickerProviderStateMixin {
  static const int _starCount = 5;
  static const List<double> _arcDrop = [0.14, 0.07, 0, 0.07, 0.14];

  late final AnimationController _swayController;
  late final AnimationController _entryController;
  late final AnimationController _twinkleController;

  @override
  void initState() {
    super.initState();
    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..forward();

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _swayController.dispose();
    _entryController.dispose();
    _twinkleController.dispose();
    super.dispose();
  }

  double _starProgress(double t, int index) {
    final start = index * 0.15;
    final end = start + 0.4;
    if (t <= start) return 0;
    if (t >= end) return 1;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final starSize = size * 0.22;
    final topSpace = size * 0.75;
    final peakY = topSpace - size * 0.20;
    final spreadStep = size * 0.26;
    final stackWidth = size * 1.6;
    final centerX = stackWidth / 2;

    return SizedBox(
      width: stackWidth,
      height: topSpace + size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          for (var i = 0; i < _starCount; i++)
            AnimatedBuilder(
              animation: Listenable.merge(
                [_entryController, _twinkleController],
              ),
              builder: (context, child) {
                final t = _entryController.value;
                final p = _starProgress(t, i);

                final tw = _twinkleController.value;
                final phase = (tw + i * 0.2) % 1.0;
                final shimmer =
                    0.92 + 0.08 * math.sin(2 * math.pi * phase);
                final float =
                    math.sin(2 * math.pi * phase) * 3.0 * p;

                final dx = (i - 2) * spreadStep;
                final tx = centerX + dx;
                final ty = peakY + _arcDrop[i] * size;

                final startX = tx + (i - 2) * 42.0;
                final startY = ty - size * 0.7;

                final x = tx +
                    (startX - tx) *
                        (1 - Curves.easeOutQuad.transform(p));
                final y = startY +
                        (ty - startY) * Curves.elasticOut.transform(p) +
                    float;
                final opacity = (p * 5).clamp(0.0, 1.0) *
                    (0.8 + 0.2 * math.sin(2 * math.pi * phase + 1));
                final scale =
                    (0.5 + 0.5 * Curves.elasticOut.transform(p)) *
                        shimmer;

                return Positioned(
                  left: x - starSize / 2,
                  top: y - starSize / 2,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: _GoldStar(size: starSize),
                    ),
                  ),
                );
              },
            ),
          AnimatedBuilder(
            animation: _swayController,
            builder: (context, child) {
              final t = _swayController.value * 2 * math.pi;
              final angle = math.sin(t) * 0.26;
              final bob = math.sin(t * 2 + 1) * 3;
              final sway = math.sin(t).abs();

              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0018)
                ..rotateY(angle);

              return Positioned(
                top: topSpace + bob,
                left: centerX - size / 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform(
                      transform: matrix,
                      alignment: Alignment.center,
                      child: child,
                    ),
                    Transform.translate(
                      offset: Offset(-angle * 26, 6),
                      child: Container(
                        width: size * (0.74 - sway * 0.16),
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(
                            alpha: 0.34 - sway * 0.15,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: PersibLogoBadge(size: size),
          ),
        ],
      ),
    );
  }
}

class _GoldStar extends StatelessWidget {
  final double size;

  const _GoldStar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/bintang.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

// ===== asal: lib/widgets/gradient_background.dart =====

class GradientBackground extends StatefulWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF030C24),
                Color(0xFF0A2A5C),
                Color(0xFF02061A),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _SpeedLinesPainter(_controller.value * 2 * math.pi),
          ),
        ),
        Align(
          alignment: const Alignment(-0.7, -0.5),
          child: Container(
            width: 420,
            height: 420,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  PersibColors.gold.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.8, 0.6),
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  PersibColors.green.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        _FloatingDecorations(controller: _controller),
        widget.child,
      ],
    );
  }
}

class _SpeedLinesPainter extends CustomPainter {
  final double t;

  _SpeedLinesPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-math.pi / 5);

    final extent = size.longestSide * 1.6;
    const gap = 38.0;
    var index = 0;
    for (double x = -extent; x <= extent; x += gap) {
      final wave = (math.sin(x / gap + t * 2) + 1) / 2;
      final alpha = 0.03 + wave * 0.10;
      final paint = Paint()
        ..strokeWidth = 1.0 + wave * 1.3
        ..color = Color.lerp(Colors.white, PersibColors.sky, wave)!
            .withValues(alpha: alpha);
      canvas.drawLine(Offset(x, -extent), Offset(x, extent), paint);
      final accentIndex = index % 12;
      if (accentIndex == 0) {
        final accent = Paint()
          ..strokeWidth = 2
          ..color = PersibColors.gold.withValues(alpha: 0.10 + wave * 0.12);
        canvas.drawLine(Offset(x, -extent), Offset(x, extent), accent);
      } else if (accentIndex == 6) {
        final accent = Paint()
          ..strokeWidth = 2
          ..color = PersibColors.green.withValues(alpha: 0.10 + wave * 0.12);
        canvas.drawLine(Offset(x, -extent), Offset(x, extent), accent);
      }
      index++;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SpeedLinesPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _LogoFloat {
  final double x;
  final double y;
  final double width;
  final double opacity;
  final double speed;
  final double phase;
  final double drift;

  const _LogoFloat({
    required this.x,
    required this.y,
    required this.width,
    required this.opacity,
    required this.speed,
    required this.phase,
    required this.drift,
  });
}

class _FloatingLogoData {
  static final List<_LogoFloat> logos = _createLogos();

  static List<_LogoFloat> _createLogos() {
    final raw = <List<double>>[
      [0.08, 0.10, 96, 0.13, 1.0, 0.0, 16],
      [0.90, 0.08, 110, 0.12, 0.8, 1.3, 18],
      [0.20, 0.88, 80, 0.15, 1.2, 2.1, 14],
      [0.82, 0.85, 92, 0.12, 0.9, 0.7, 16],
      [0.48, 0.16, 64, 0.10, 1.1, 3.0, 10],
      [0.68, 0.50, 120, 0.10, 0.7, 4.2, 20],
      [0.16, 0.46, 70, 0.12, 1.3, 5.5, 12],
      [0.38, 0.60, 58, 0.14, 0.9, 2.6, 10],
      [0.96, 0.32, 66, 0.11, 1.0, 1.8, 12],
      [0.03, 0.66, 78, 0.10, 1.15, 3.6, 14],
      [0.55, 0.92, 72, 0.09, 0.85, 4.8, 12],
      [0.27, 0.06, 52, 0.12, 1.25, 0.4, 10],
    ];
    return raw
        .map(
          (r) => _LogoFloat(
            x: r[0],
            y: r[1],
            width: r[2],
            opacity: r[3],
            speed: r[4],
            phase: r[5],
            drift: r[6],
          ),
        )
        .toList();
  }
}

class _FloatingLogo extends StatelessWidget {
  final _LogoFloat logo;
  final double t;

  const _FloatingLogo({required this.logo, required this.t});

  @override
  Widget build(BuildContext context) {
    final dx = math.sin(t * logo.speed + logo.phase) * logo.drift;
    final dy = math.cos(t * logo.speed * 0.7 + logo.phase) * logo.drift * 0.8;
    final angle = math.sin(t * logo.speed * 0.5 + logo.phase) * 0.12;

    return Align(
      alignment: Alignment(
        (logo.x - 0.5) * 2,
        (logo.y - 0.5) * 2,
      ),
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Transform.rotate(
          angle: angle,
          child: Opacity(
            opacity: logo.opacity,
            child: Image.asset(
              'assets/images/persib_float.png',
              width: logo.width,
              height: logo.width * 1.418,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingTrophyData {
  static final List<_LogoFloat> trophies = _createTrophies();

  static List<_LogoFloat> _createTrophies() {
    final raw = <List<double>>[
      [0.12, 0.30, 70, 0.32, 0.9, 0.9, 12],
      [0.76, 0.20, 84, 0.30, 1.1, 2.4, 14],
      [0.34, 0.78, 64, 0.32, 1.0, 3.8, 12],
      [0.88, 0.62, 76, 0.28, 0.85, 1.5, 14],
      [0.58, 0.38, 58, 0.34, 1.2, 5.0, 10],
      [0.22, 0.55, 74, 0.30, 0.95, 4.2, 13],
    ];
    return raw
        .map(
          (r) => _LogoFloat(
            x: r[0],
            y: r[1],
            width: r[2],
            opacity: r[3],
            speed: r[4],
            phase: r[5],
            drift: r[6],
          ),
        )
        .toList();
  }
}

class _FloatingTrophy extends StatelessWidget {
  final _LogoFloat trophy;
  final double t;

  const _FloatingTrophy({required this.trophy, required this.t});

  @override
  Widget build(BuildContext context) {
    final dx = math.sin(t * trophy.speed + trophy.phase) * trophy.drift;
    final dy = math.cos(t * trophy.speed * 0.7 + trophy.phase) * trophy.drift * 0.8;
    final angle = math.sin(t * trophy.speed * 0.5 + trophy.phase) * 0.12;

    return Align(
      alignment: Alignment(
        (trophy.x - 0.5) * 2,
        (trophy.y - 0.5) * 2,
      ),
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Transform.rotate(
          angle: angle,
          child: Opacity(
            opacity: trophy.opacity,
            child: SizedBox(
              width: trophy.width,
              height: trophy.width * 1.776,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xCCFFE9A8),
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(
                        'assets/images/Thropy Liga 1.png',
                        width: trophy.width,
                        height: trophy.width * 1.776,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      1.2, 0, 0, 0, 30,
                      0, 1.2, 0, 0, 30,
                      0, 0, 1.2, 0, 30,
                      0, 0, 0, 1, 0,
                    ]),
                    child: Image.asset(
                      'assets/images/Thropy Liga 1.png',
                      width: trophy.width,
                      height: trophy.width * 1.776,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MeteorData {
  final double xFrac;
  final double dx;
  final double phase;
  final double size;
  final double peakOpacity;

  const _MeteorData({
    required this.xFrac,
    required this.dx,
    required this.phase,
    required this.size,
    required this.peakOpacity,
  });
}

class _Meteors {
  static final List<_MeteorData> list = [
    const _MeteorData(
      xFrac: 0.12,
      dx: 0.24,
      phase: 0.0,
      size: 26,
      peakOpacity: 0.55,
    ),
    const _MeteorData(
      xFrac: 0.70,
      dx: 0.18,
      phase: 0.24,
      size: 20,
      peakOpacity: 0.5,
    ),
    const _MeteorData(
      xFrac: 0.42,
      dx: 0.28,
      phase: 0.48,
      size: 30,
      peakOpacity: 0.55,
    ),
    const _MeteorData(
      xFrac: 0.88,
      dx: 0.16,
      phase: 0.68,
      size: 22,
      peakOpacity: 0.45,
    ),
    const _MeteorData(
      xFrac: 0.58,
      dx: 0.22,
      phase: 0.84,
      size: 24,
      peakOpacity: 0.5,
    ),
  ];
}

class _Meteor extends StatelessWidget {
  final _MeteorData meteor;
  final double progress;

  const _Meteor({required this.meteor, required this.progress});

  @override
  Widget build(BuildContext context) {
    final prog = (progress + meteor.phase) % 1.0;
    final x = meteor.xFrac + meteor.dx * prog;
    final y = -0.15 + prog * 1.3;
    final alpha = math.sin(prog * math.pi).clamp(0.0, 1.0).toDouble() *
        meteor.peakOpacity;

    return Align(
      alignment: Alignment(
        (x - 0.5) * 2,
        (y - 0.5) * 2,
      ),
      child: Opacity(
        opacity: alpha,
        child: Transform.rotate(
          angle: -0.5,
          child: SizedBox(
            width: meteor.size * 2.4,
            height: meteor.size,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: 2,
                  margin: EdgeInsets.only(right: meteor.size * 0.15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/bintang.png',
                  width: meteor.size,
                  height: meteor.size,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingDecorations extends StatelessWidget {
  final AnimationController controller;

  const _FloatingDecorations({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value * 2 * math.pi;
        return IgnorePointer(
          child: Stack(
            children: [
              for (final logo in _FloatingLogoData.logos)
                _FloatingLogo(logo: logo, t: t),
              for (final trophy in _FloatingTrophyData.trophies)
                _FloatingTrophy(trophy: trophy, t: t),
              for (final meteor in _Meteors.list)
                _Meteor(meteor: meteor, progress: controller.value),
            ],
          ),
        );
      },
    );
  }
}
// ===== asal: lib/screens/home_screen.dart =====



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _starting = false;

  Future<void> _handleStartQuiz() async {
    if (_starting) return;
    _starting = true;
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuizScreen()),
      );
    } finally {
      _starting = false;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              const HeroLogo(),
              const SizedBox(height: 14),
              Text(
                strings.welcomeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                strings.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              GradientButton(
                label: strings.startQuiz,
                icon: Icons.play_arrow_rounded,
                onPressed: _handleStartQuiz,
              ),
              const SizedBox(height: 26),
              FutureBuilder<List<QuizResult>>(
                future: StorageService.instance.loadHistory(),
                builder: (context, snapshot) {
                  final results = snapshot.data ?? <QuizResult>[];
                  int? best;
                  int? average;
                  if (results.isNotEmpty) {
                    best = results
                        .map((r) => r.percentage)
                        .reduce(math.max);
                    final sum = results.fold<int>(
                      0,
                      (acc, r) => acc + r.percentage,
                    );
                    average = (sum / results.length).round();
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            label: strings.statBest,
                            value: best == null ? '—' : '$best%',
                          ),
                        ),
                        const _VertDivider(),
                        Expanded(
                          child: _StatTile(
                            label: strings.statQuiz,
                            value: '${results.length}',
                          ),
                        ),
                        const _VertDivider(),
                        Expanded(
                          child: _StatTile(
                            label: strings.statAverage,
                            value: average == null ? '—' : '$average%',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                strings.footerTag,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  const _VertDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.16),
    );
  }
}

// ===== asal: lib/screens/settings_screen.dart =====


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: FutureBuilder<AppSettings>(
            future: StorageService.instance.loadSettings(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return _SettingsForm(initial: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _SettingsForm extends StatefulWidget {
  final AppSettings initial;

  const _SettingsForm({required this.initial});

  @override
  State<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<_SettingsForm> {
  late double _volume = widget.initial.musicVolume;
  late AppLanguage _language = widget.initial.language;

  Future<void> _save() async {
    await StorageService.instance.saveSettings(
      AppSettings(
        musicVolume: _volume,
        language: LocaleService.instance.language,
      ),
    );
  }

  void _selectLanguage(AppLanguage language) {
    if (_language == language) return;
    setState(() => _language = language);
    LocaleService.instance.setLanguage(language);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.settingsTitle,
          style: const TextStyle(
            color: PersibColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        _SectionLabel(strings.musicSection),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.volume_up_rounded,
                    color: PersibColors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      strings.volumeLabel,
                      style: const TextStyle(
                        color: PersibColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: PersibColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(_volume * 100).round()}%',
                      style: const TextStyle(
                        color: PersibColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _volume.clamp(0.0, 1.0),
                min: 0,
                max: 1,
                divisions: 20,
                activeColor: PersibColors.blue,
                inactiveColor: const Color(0xFFDCE5EF),
                onChanged: (value) {
                  setState(() => _volume = value);
                  MusicService.instance.setVolume(value);
                  _save();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionLabel(strings.languageSection),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.translate_rounded,
                    color: PersibColors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      strings.languageLabel,
                      style: const TextStyle(
                        color: PersibColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _LanguageOption(
                        label: strings.languageIndonesian,
                        selected: _language == AppLanguage.indonesian,
                        onTap: () =>
                            _selectLanguage(AppLanguage.indonesian),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _LanguageOption(
                        label: strings.languageEnglish,
                        selected: _language == AppLanguage.english,
                        onTap: () => _selectLanguage(AppLanguage.english),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                strings.languageInfo,
                style: const TextStyle(
                  color: PersibColors.slate,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.music_note_rounded, color: PersibColors.gold),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  strings.musicInfo,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: PersibColors.gold,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected ? PersibColors.brandGradient : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: PersibColors.blue.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : PersibColors.slate,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ===== asal: lib/screens/quiz_screen.dart =====



class QuizScreen extends StatefulWidget {
  static const int timePerQuestion = 20;
  static const int questionCount = 30;

  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<Question> _questions;

  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;

  Timer? timer;
  late int remainingSeconds;
  bool _isAdvancing = false;

  int get _timePerQuestion => QuizScreen.timePerQuestion;

  @override
  void initState() {
    super.initState();
    remainingSeconds = _timePerQuestion;

    var prepared = List.of(questions)..shuffle();
    final count = QuizScreen.questionCount.clamp(
      1,
      prepared.length,
    );
    if (count < prepared.length) {
      prepared = prepared.sublist(0, count);
    }
    _questions = prepared;

    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer?.cancel();

    setState(() {
      remainingSeconds = _timePerQuestion;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          timer.cancel();
          if (selectedAnswer == null) {
            _nextQuestion();
          }
        }
      },
    );
  }

  void _selectAnswer(int index) {
    if (selectedAnswer != null) return;

    setState(() {
      selectedAnswer = index;
    });

    if (index == _questions[currentQuestion].answer) {
      score++;
    }

    timer?.cancel();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_isAdvancing) return;
    _isAdvancing = true;

    timer?.cancel();

    if (currentQuestion < _questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });

      _isAdvancing = false;

      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            total: _questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[currentQuestion];
    final revealed = selectedAnswer != null;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              children: [
                QuizHeader(
                  current: currentQuestion + 1,
                  total: _questions.length,
                  score: score,
                  remaining: remainingSeconds,
                  fullSeconds: _timePerQuestion,
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 380),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final curved = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.06, 0),
                            end: Offset.zero,
                          ).animate(curved),
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey<int>(currentQuestion),
                      child: Center(
                        child: _QuestionCard(
                          question: question,
                          selectedAnswer: selectedAnswer,
                          revealed: revealed,
                          onSelect: _selectAnswer,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedAnswer;
  final bool revealed;
  final ValueChanged<int> onSelect;

  const _QuestionCard({
    required this.question,
    required this.selectedAnswer,
    required this.revealed,
    required this.onSelect,
  });

  IconData get _categoryIcon {
    switch (question.category.toLowerCase()) {
      case 'sejarah':
        return Icons.history_edu_rounded;
      case 'stadion':
        return Icons.stadium_rounded;
      case 'pelatih':
        return Icons.sports_score_rounded;
      case 'prestasi':
        return Icons.emoji_events_rounded;
      case 'kompetisi':
        return Icons.emoji_events_outlined;
      case 'klub':
      case 'warna klub':
        return Icons.palette_rounded;
      default:
        return Icons.sports_soccer_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);
    final options = question.optionTexts(strings.language);
    final isAnswerCorrect =
        revealed && selectedAnswer == question.answer;
    final correctLetter = String.fromCharCode(65 + question.answer);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 720),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: PersibColors.lightBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_categoryIcon, size: 15, color: PersibColors.blue),
                  const SizedBox(width: 7),
                  Text(
                    strings.category(question.category).toUpperCase(),
                    style: const TextStyle(
                      color: PersibColors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              question.text(strings.language),
              style: const TextStyle(
                color: PersibColors.ink,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              strings.chooseAnswer,
              style: const TextStyle(
                color: PersibColors.slate,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              options.length,
              (index) => AnswerCard(
                letter: String.fromCharCode(65 + index),
                answer: options[index],
                selected: selectedAnswer == index,
                isCorrect: index == question.answer,
                revealed: revealed,
                onTap: () => onSelect(index),
              ),
            ),
            if (revealed) ...[
              const SizedBox(height: 4),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isAnswerCorrect
                        ? const Color(0xFFE8FBF3)
                        : const Color(0xFFFDEBEC),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAnswerCorrect
                            ? Icons.check_circle_rounded
                            : Icons.lightbulb_rounded,
                        size: 18,
                        color: isAnswerCorrect
                            ? PersibColors.green
                            : PersibColors.red,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        isAnswerCorrect
                            ? strings.correctFeedback
                            : strings.wrongFeedback(correctLetter),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isAnswerCorrect
                              ? PersibColors.green
                              : PersibColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== asal: lib/screens/result_screen.dart =====


class ResultScreen extends StatefulWidget {
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _navigating = false;

  int get _total => widget.total <= 0 ? 1 : widget.total;

  int get _percentage =>
      ((widget.score / _total) * 100).round();

  IconData get _trophyIcon {
    if (_percentage >= 75) return Icons.emoji_events_rounded;
    if (_percentage >= 40) return Icons.military_tech_rounded;
    return Icons.sports_soccer_rounded;
  }

  Color get _trophyColor {
    if (_percentage >= 75) return PersibColors.gold;
    if (_percentage >= 40) return PersibColors.sky;
    return const Color(0xFF9AA8BD);
  }

  Color get _ringColor {
    if (_percentage >= 75) return PersibColors.green;
    if (_percentage >= 40) return PersibColors.gold;
    return PersibColors.sky;
  }

  String get _playerLabel => 'Bobotoh';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StorageService.instance.saveResult(
        QuizResult(
          playerName: _playerLabel,
          score: widget.score,
          total: _total,
          finishedAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) =>
                          Transform.scale(scale: value, child: child),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _trophyColor.withValues(alpha: 0.55),
                              blurRadius: 36,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _trophyIcon,
                          color: _trophyColor,
                          size: 54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      strings.quizComplete,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.goodJob(strings.playerLabel),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            strings.yourScore,
                            style: const TextStyle(
                              color: PersibColors.slate,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: widget.score.toDouble()),
                            duration: const Duration(milliseconds: 1100),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) => Text(
                              '${value.round()} / $_total',
                              style: const TextStyle(
                                color: PersibColors.blue,
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0,
                              end: _percentage.toDouble(),
                            ),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) {
                              return SizedBox(
                                width: 150,
                                height: 150,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox.expand(
                                      child: CircularProgressIndicator(
                                        value: value / 100,
                                        strokeWidth: 12,
                                        strokeCap: StrokeCap.round,
                                        backgroundColor:
                                            const Color(0xFFEAF1F8),
                                        valueColor: AlwaysStoppedAnimation(
                                          _ringColor,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${value.round()}',
                                          style: const TextStyle(
                                            color: PersibColors.ink,
                                            fontSize: 40,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const Text(
                                          '%',
                                          style: TextStyle(
                                            color: PersibColors.slate,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F6FF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  strings.resultTitle(_percentage),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: PersibColors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  strings.resultDescription(_percentage),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: PersibColors.slate,
                                    height: 1.5,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          GradientButton(
                            label: strings.retryQuiz,
                            icon: Icons.refresh_rounded,
                            onPressed: () {
                              if (_navigating) return;
                              _navigating = true;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const QuizScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 11),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (_navigating) return;
                                _navigating = true;
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                              icon: const Icon(Icons.home_rounded),
                              label: Text(
                                strings.backHome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: PersibColors.blue,
                                side: const BorderSide(
                                  color: PersibColors.blue,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      strings.footerTag,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== asal: lib/screens/main_shell.dart =====


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PersibColors.navyDark,
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 700;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Sidebar(
                    compact: compact,
                    currentIndex: _index,
                    onSelected: (index) {
                      setState(() => _index = index);
                    },
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _index,
                      children: const [
                        HomeScreen(),
                        SettingsScreen(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final bool compact;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  const _Sidebar({
    required this.compact,
    required this.currentIndex,
    required this.onSelected,
  });

  static const List<(IconData, IconData)> _items = [
    (Icons.home_outlined, Icons.home_rounded),
    (Icons.settings_outlined, Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);
    final labels = [strings.navHome, strings.navSettings];
    final width = compact ? 78.0 : 232.0;

    return Container(
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A2350),
            Color(0xFF051233),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: Color(0x33FFFFFF),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarBrand(compact: compact),
          Divider(
            height: 1,
            thickness: 1,
            indent: compact ? 16 : 20,
            endIndent: compact ? 16 : 20,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 14),
          for (final entry in _items.asMap().entries)
            _SidebarItem(
              compact: compact,
              icon: entry.value.$1,
              selectedIcon: entry.value.$2,
              label: labels[entry.key],
              selected: currentIndex == entry.key,
              onTap: () => onSelected(entry.key),
            ),
        ],
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  final bool compact;

  const _SidebarBrand({required this.compact});

  @override
  Widget build(BuildContext context) {
    final strings = AppStringsScope.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 12 : 20,
        24,
        compact ? 12 : 20,
        18,
      ),
      child: compact
          ? const Center(
              child: PersibLogoBadge(size: 44),
            )
          : Row(
              children: [
                const PersibLogoBadge(size: 46),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.brandName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        strings.brandSubtitle,
                        style: const TextStyle(
                          color: PersibColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final bool compact;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.compact,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final compact = widget.compact;

    final Color fg = selected
        ? Colors.white
        : (_hovered ? Colors.white : Colors.white70);

    return SizedBox(
      height: 58,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 4,
            height: selected ? 26 : 0,
            decoration: const BoxDecoration(
              color: PersibColors.gold,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Tooltip(
              message: compact ? widget.label : '',
              waitDuration: const Duration(milliseconds: 400),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onTap,
                  onHover: (value) => setState(() => _hovered = value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    height: 50,
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 0 : 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: selected ? PersibColors.brandGradient : null,
                      color: selected
                          ? null
                          : (_hovered
                              ? Colors.white.withValues(alpha: 0.07)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color:
                                    PersibColors.blue.withValues(alpha: 0.45),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: compact
                        ? Icon(
                            selected ? widget.selectedIcon : widget.icon,
                            size: 24,
                            color: selected ? Colors.white : Colors.white70,
                          )
                        : Row(
                            children: [
                              Icon(
                                selected ? widget.selectedIcon : widget.icon,
                                size: 22,
                                color: fg,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  widget.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: fg,
                                    fontSize: 14.5,
                                    fontWeight: selected
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== asal: lib/main.dart =====



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MusicService.instance.init());
  unawaited(LocaleService.instance.init());
  runApp(const PersibQuizApp());
}

class PersibQuizApp extends StatelessWidget {
  const PersibQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: PersibColors.blue,
    ).copyWith(
      primary: PersibColors.blue,
      secondary: PersibColors.gold,
    );

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => MusicService.instance.enableAfterGesture(),
      child: ListenableBuilder(
        listenable: LocaleService.instance,
        builder: (context, _) {
          return AppStringsScope(
            strings: LocaleService.instance.strings,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'PERSIB Quiz 2026/27',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: colorScheme,
                scaffoldBackgroundColor: PersibColors.navyDark,
              ),
              home: const MainShell(),
            ),
          );
        },
      ),
    );
  }
}

