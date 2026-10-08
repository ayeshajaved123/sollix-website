# SOLLIX Website — Flutter Frontend

Single-page corporate website matching the approved mockup. Simple structure —
no state management library, no routing package, no unnecessary folders.

## How to run
```bash
flutter pub get
flutter run -d chrome
```

## Folder structure
```
lib/
  main.dart
  theme/
    app_colors.dart        → ALL brand colors
    app_text_styles.dart   → ALL typography
    responsive.dart        → mobile/tablet/desktop breakpoints
  widgets/
    custom_button.dart     → single reusable button
    section_header.dart    → red eyebrow label + heading
    brand_logo.dart         → logo (assets/images/logo.png)
    scroll_reveal.dart      → fade+slide-up animation on scroll
  sections/
    navbar_section.dart
    hero_section.dart
    features_section.dart
    services_section.dart
    stats_section.dart
    projects_section.dart
    cta_banner_section.dart
    footer_section.dart
  screens/
    home_screen.dart        → assembles all sections
assets/
  images/
    logo.png                  → placeholder — REPLACE with your real logo
    hero_facility.jpg         → cropped from mockup (low-res placeholder)
    project_commercial.jpg    → cropped from mockup (low-res placeholder)
    project_residential.jpg   → cropped from mockup (low-res placeholder)
    project_industrial.jpg    → cropped from mockup (low-res placeholder)
    project_infrastructure.jpg→ cropped from mockup (low-res placeholder)
```

## IMPORTANT — About the images included
- `logo.png` is a rough placeholder (not your real logo) — replace it with your
  actual AI-generated / final logo file, keeping the exact filename `logo.png`.
- The 5 project/hero photos were cropped directly from your mockup screenshot
  so the LOOK matches exactly — but since the mockup screenshot itself was
  only ~1024px wide, these cropped images are low resolution (some as small
  as 173x136px). They will look fine at small sizes but may look soft/blurry
  if the site is viewed on a large monitor. Replace them with high-resolution
  originals (1200px+ wide) as soon as you have them — same filenames, no code
  changes needed.

## Known gaps / confirm before backend phase
- "About Us" and "Our Values" nav links currently scroll to the nearest
  existing section (Features / Stats) — no dedicated section design was
  provided for these yet.
- Phone/email are still mockup placeholders (+971 50 123 4567 / info@sollix.ae)
  — confirm real details before going live.
- Contact form isn't wired up yet — "CONTACT US" / "GET A QUOTE" just scroll
  to the contact section. Will be added once backend/DB is ready.

## Dependencies
- `google_fonts` — Oswald (headings) + Inter (body)
- `url_launcher` — reserved for phone/email/WhatsApp links later
- `visibility_detector` — powers the scroll-reveal animation
