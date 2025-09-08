# Karam Kottish — Flutter Portfolio 🚀

A modern, animated **portfolio** built with Flutter for web and mobile. It showcases projects, skills, courses, and a courses-styled **Diploma** section, with smooth motion and a centered sticky navbar.

---

## ✨ Highlights

- **Responsive UI** (mobile → desktop)
- **Animated Hero** (rainbow headline, blobs, confetti)
- **Sticky Centered Navbar** with smooth scroll to  
  **About · Experience · Skills · Projects · Courses · Diploma**
- **Projects Grid** with gradient accents and tech tags
- **Courses Carousel** (autoplay, pause on user interaction)  
  Images open with pinch/zoom; PDFs open in an embedded viewer
- **Diploma Section** (like Courses): number badge (e.g. `01`), gentle float, expandable 4-image gallery
- **Social Buttons** (SVG/PNG) with graceful fallbacks

---

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) · Material 3  
- **Language:** Dart  
- **Navigation:** smooth scroll via `Scrollable.ensureVisible`  
- **Packages:**
  - Links / email — [`url_launcher`](https://pub.dev/packages/url_launcher)
  - SVG icons — [`flutter_svg`](https://pub.dev/packages/flutter_svg)
  - Image zoom — [`photo_view`](https://pub.dev/packages/photo_view)
  - PDF viewer — [`syncfusion_flutter_pdfviewer`](https://pub.dev/packages/syncfusion_flutter_pdfviewer)

---

## 📂 Organized Structure

```text
lib/
├─ pages/
│  └─ portfolio_home_page.dart          # Main screen (slivers + section anchors)
├─ widgets/
│  ├─ portfolio_hero.dart               # Hero + DiplomaSection (courses-style)
│  ├─ sticky_rainbow_nav.dart           # Centered navbar (has "Diploma")
│  ├─ courses_section.dart              # Autoplay carousel + image/PDF viewers
│  ├─ experience_section.dart
│  ├─ skills_section.dart
│  ├─ social_icon_button.dart
│  ├─ blob_background.dart
│  ├─ colorful_background.dart
│  └─ elegant_background.dart
assets/
└─ lib/assets/
   ├─ icons/
   ├─ courses/
   ├─ projects/
   └─ Diploma/
      ├─ uiuxDiploma.png
      ├─ userxperienceDesign.png
      ├─ userxperienceReserach.png          
      ├─ userdesignFundementals.png         
      └─ designPrincepls.png               
