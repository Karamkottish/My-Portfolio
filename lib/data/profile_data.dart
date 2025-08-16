// lib/data/profile_data.dart
import 'package:flutter/material.dart';

class ProfileData {
  static const String name = 'Karam Kottish';

  static const List<String> taglines = [
    'Crafting high-quality Flutter apps with precision',
    'Turning UI/UX visions into seamless mobile experiences',
    'Building scalable, user-focused digital products',
    'Passionate about performance and clean architecture',
  ];

  static const String location = 'Riyadh, Saudi Arabia';
  static const String phone = '+966597733571';
  static const String email = 'Karamkottish@gmail.com';

  // Social links
  static const String linkedin = 'https://www.linkedin.com/in/karam-kottish/';
  static const String github = 'https://github.com/Karamkottish';
  static const String gitlab = 'https://gitlab.com/KaramKottish';
  static const String revonixRepo =
      'https://gitlab.com/revonix1/revonix-frontend';

  static const String profileSummary =
      'Motivated student and developer passionate about Flutter, building user-centered, high-quality applications. Eager to contribute to innovative, impact-driven products.';

  // ===================== EXPERIENCE =====================
  static const experiences = [
    Experience(
      title: 'Flutter App Developer',
      org: 'Focal X Agency',
      location: 'Damascus, Syria',
      start: '02/2024',
      end: '06/2024',
      bullets: [
        'Delivered production-ready features in Flutter/Dart using Riverpod/GetX and clean architecture.',
        'Built responsive Material 3 UIs from Figma with theming, dark mode, and smooth animations.',
        'Integrated REST APIs & Firebase (Auth, Firestore, RTDB, Cloud Messaging), push notifications, and error reporting.',
        'Offline caching and graceful retries to handle poor connectivity.',
        'Implemented full i18n/RTL (Arabic/English) support.',
        'Set up CI/CD with Codemagic & GitHub Actions for TestFlight/Play Console deployments.',
        'Created API and developer setup documentation to onboard new engineers quickly.'
      ],
    ),
  ];

  // ===================== PROJECTS =====================
  static const projects = [
    Project(
      name: 'Revonix / Artisan SY',
      role: 'Graduation Project (A-)',
      date: '10/2024 – 07/2025',
      summary:
      'A cross-platform Flutter application that lets clients browse, book, and manage home-service appointments.',
      link: 'https://revonix.app',
      gitlabLink: 'https://gitlab.com/revonix1/revonix-frontend',
      image: 'lib/assets/projects/RevonixYellow.jpg', // ✅ correct path
    ),
    Project(
      name: 'Shein Replica',
      role: 'Personal Project',
      date: '10/2024',
      summary:
      'A shopping experience replica with intuitive browsing and purchase flows.',
      link: 'https://github.com/Karamkottish/shein-replica',
      image: 'lib/assets/projects/Shein-logo.png', // ✅ correct path
    ),
    Project(
      name: 'Change Volunteering App',
      role: 'Semester Project (B+)',
      date: '05/2024',
      summary:
      'Helps users discover and join volunteering opportunities in one tap.',
      link: 'https://github.com/Karamkottish/Change-ASPU/tree/flutter',
      image: 'lib/assets/projects/Change.png', // ✅ correct path
    ),
  ];

  // ===================== EDUCATION =====================
  static const education = [
    Education(
      program: 'BEng: Informatics Engineering (5th year ITE)',
      place: 'Al Sham Private University',
      location: 'Damascus, Syria',
      endDate: 'Present',
    ),
    Education(
      program: 'American Highschool Diploma',
      place: 'Future Window International School',
      location: 'Riyadh, Saudi Arabia',
      endDate: '05/2018',
    ),
  ];

  // ===================== COURSES =====================
  static const courses = [
    Course(
      title: 'Front-end Engineering with React',
      provider: 'Manara',
      date: '07/2025–08/2025',
      image: 'lib/assets/courses/manara.png',
    ),
    Course(
      title: 'Intro to Cryptography',
      provider: 'Leeds/ClickStart/IofC',
      date: '02/2025',
    ),
    Course(
      title: 'Intro to Computational Thinking',
      provider: 'Open University',
      date: '01/2025',
    ),
    Course(
      title: 'GIT Training',
      provider: 'Simplilearn',
      date: '01/2025',
    ),
    Course(
      title: 'Ethical Hacking 101',
      provider: 'Simplilearn',
      date: '12/2024',
    ),
    Course(
      title: 'UI/UX',
      provider: 'Vica Web Solutions',
      date: '08/2024–12/2024',
    ),
    Course(
      title: 'Flutter Advanced',
      provider: 'Focal X Agency',
      date: '02/2024–06/2024',
      image: 'lib/assets/courses/flutterad.jpg',
    ),
    Course(
      title: 'Flutter Beginner',
      provider: 'Merit Center',
      date: '10/2023–01/2024',
    ),
    Course(
      title: 'CCNA',
      provider: 'Hadara Intl. Center',
      date: '03/2023–05/2023',
    ),
  ];

  // ===================== CERTIFICATES =====================
  static const certificates = [
    Certificate(
      title: 'Innovating with Google Cloud AI',
      provider: 'Google Cloud',
      date: '01/2025',
    ),
    Certificate(
      title: 'Scaling with Google Cloud Operations',
      provider: 'Google Cloud',
      date: '12/2024',
    ),
    Certificate(
      title: 'Introduction to Database & SQL',
      provider: 'Open University',
      date: '06/2021',
    ),
    Certificate(
      title: 'Python Programming for Beginners',
      provider: 'Open University',
      date: '05/2021',
    ),
    Certificate(title: 'Cloud Security', provider: 'TVTC', date: '03/2021'),
    Certificate(
      title: 'Network & Cyber Security',
      provider: 'TVTC',
      date: '03/2021',
    ),
    Certificate(title: 'Google Applications', provider: 'TVTC', date: '03/2021'),
    Certificate(
      title: 'Future of Display Advertising',
      provider: 'Google',
      date: '03/2021',
    ),
    Certificate(title: 'What is the micro:bit?', provider: 'BBC', date: '03/2021'),
    Certificate(title: 'TOT 60 hrs', provider: 'TVTC', date: '10/2020'),
  ];

  // ===================== SKILLS =====================
  static const skills = [
    'Flutter/Dart',
    'Firebase',
    'REST APIs',
    'Git/GitHub/GitLab',
    'State Management (Riverpod/GetX)',
    'UI/UX & Responsive Design',
    'Front-end Development',
    'API Integration',
    'Mobile Development',
    'Microsoft Office',
  ];

  // ===================== SOFT SKILLS =====================
  static const softSkills = [
    'Problem Solving',
    'Communication',
    'Teamwork',
    'Adaptability',
    'Work Under Pressure',
    'Quick Learner',
  ];

  // ===================== LANGUAGES =====================
  static const languages = [
    Language(name: 'English', level: 4),
    Language(name: 'Arabic', level: 5),
  ];
}

// ===================== MODELS =====================
class Experience {
  final String title, org, location, start, end;
  final List<String> bullets;
  const Experience({
    required this.title,
    required this.org,
    required this.location,
    required this.start,
    required this.end,
    required this.bullets,
  });
}

class Project {
  final String name, role, date, summary;
  final String? link, gitlabLink, image;
  const Project({
    required this.name,
    required this.role,
    required this.date,
    required this.summary,
    this.link,
    this.gitlabLink,
    this.image,
  });
}

class Education {
  final String program, place, location, endDate;
  const Education({
    required this.program,
    required this.place,
    required this.location,
    required this.endDate,
  });
}

class Course {
  final String title, provider, date;
  final String? image;
  const Course({
    required this.title,
    required this.provider,
    required this.date,
    this.image,
  });
}

class Certificate {
  final String title, provider, date;
  const Certificate({
    required this.title,
    required this.provider,
    required this.date,
  });
}

class Language {
  final String name;
  final int level; // 1–5
  const Language({required this.name, required this.level});
}
