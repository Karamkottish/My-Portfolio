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
      'A cross-platform Flutter application that lets clients browse, book, and manage home-service appointments (plumbers, electricians, carpenters, etc.), track their booking history, manage their profile & settings, and receive notifications.',
      link: 'https://revonix.app',
      gitlabLink: 'https://gitlab.com/revonix1/revonix-frontend',
    ),
    Project(
      name: 'Shein Replica',
      role: 'Personal Project',
      date: '10/2024',
      summary:
      'A shopping experience replica with intuitive browsing and purchase flows.',
      link: 'https://github.com/Karamkottish/shein-replica',
    ),
    Project(
      name: 'Change Volunteering App',
      role: 'Semester Project (B+)',
      date: '05/2024',
      summary:
      'Helps users discover and join volunteering opportunities in one tap.',
      link: 'https://github.com/Karamkottish/Change-ASPU/tree/flutter',
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
    'Front-end Engineering with React (Manara, 07/2025–08/2025)',
    'Intro to Cryptography (Leeds/ClickStart/IofC, 02/2025)',
    'Intro to Computational Thinking (Open University, 01/2025)',
    'GIT Training (Simplilearn, 01/2025)',
    'Ethical Hacking 101 (Simplilearn, 12/2024)',
    'UI/UX — Vica Web Solutions (08/2024–12/2024)',
    'Flutter Advanced — Focal X Agency (02/2024–06/2024)',
    'Flutter Beginner — Merit Center (10/2023–01/2024)',
    'CCNA — Hadara Intl. Center (03/2023–05/2023)',
  ];

  // ===================== CERTIFICATES =====================
  static const certificates = [
    'Innovating with Google Cloud AI (01/2025)',
    'Scaling with Google Cloud Operations (12/2024)',
    'Introduction to Database & SQL (06/2021)',
    'Python Programming for Beginners (05/2021)',
    'Cloud Security (03/2021)',
    'Network & Cyber Security (03/2021)',
    'Google Applications (03/2021)',
    'Future of Display Advertising (03/2021)',
    'What is the micro:bit? (03/2021)',
    'TOT 60 hrs — TVTC (10/2020)',
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
    'English',
    'Arabic',
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
  final String? link;
  final String? gitlabLink; // New field for GitLab repo

  const Project({
    required this.name,
    required this.role,
    required this.date,
    required this.summary,
    this.link,
    this.gitlabLink,
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
