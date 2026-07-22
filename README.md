# PiensaPlay

**Every click can change the world.** PiensaPlay is a bilingual, child-centred media and information literacy game for learners aged 8–12. Players restore trust in a digital city by checking sources, recognizing manipulated media and choosing responsible ways to share information.

The project is being prepared for the [UNESCO Youth Hackathon 2026](https://www.unesco.org/en/articles/unesco-youth-hackathon-2026), under the theme *Play Your Part: Youth Designing the Future of Media and Information Literacy*.

## What makes it different

- **PIENSA method:** Pause, Identify, Examine, Notice, Seek and Act—a reusable decision routine, not a one-time quiz.
- **Three-mission flagship demo:** viral misinformation, AI-generated media and the social ripple of sharing.
- **Learning evidence:** anonymous baseline and transfer questions show change in decision quality.
- **Inclusive by design:** Spanish and English, larger text, reduced motion, dark mode and a classroom mode.
- **Low-connectivity ready:** the flagship experience and local progress work without an account or network.
- **Child safety:** no ads, no public profiles and no need to collect a child's real name.

## Run the project

Prerequisites: Flutter stable, Dart and a browser or Android emulator.

```bash
cd piensa_play
flutter pub get
flutter run
```

Useful routes in the web build:

- `/#/demo` — direct three-minute flagship demo
- `/#/missions` — Digital City mission map
- `/#/facilitator` — in-app facilitator guide

## Quality checks

```bash
cd piensa_play
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --release
```

GitHub Actions repeats these checks on pushes and pull requests.

## Repository map

```text
piensa_play/
  lib/core/                 theme, localization, accessibility and services
  lib/features/flagship/    UNESCO-ready learning experience
  lib/features/             existing game modules
  test/                     policy, content and local-impact tests
  firestore.rules           least-privilege database rules
docs/                       submission, pitch, facilitation and safeguarding
scripts/                    Firebase catalogue seed tools
```

## Competition material

- [Product and impact brief](docs/unesco-2026-product-brief.md)
- [Three-minute pitch script](docs/pitch-video-script.md)
- [Facilitator and pilot guide](docs/facilitator-and-pilot-guide.md)
- [Privacy and safeguarding](docs/privacy-and-safeguarding.md)

## Current scope and next evidence milestone

The repository contains a functional prototype and a complete flagship learning loop. Before making outcome claims, the team should run a small supervised pilot, obtain guardian/school consent where required, and report anonymized aggregate results. Production release also requires deploying the versioned Firestore rules and replacing development application identifiers with new Firebase configuration owned by the current team.

## Team

Dara Van Gijsel · Carlos Mejía · Sebastián Calderón · Alex Ramírez
