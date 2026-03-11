# Gerald is Watching

**The neighborhood isn't going to watch itself.**

A paranoid suburban surveillance game where you play as Gerald — a retired man convinced his perfectly safe neighborhood is a hotbed of criminal activity. Watch your neighbors through binoculars, observe their mundane activities, and file increasingly unhinged reports.

**Play now:** [gerald-208.pages.dev](https://gerald-208.pages.dev/)

## How to Play

- **Drag** to pan your binoculars across the street
- **Tap** on neighbors to observe their activity
- **Choose a paranoia level** for your report:
  - *Mild* (10 pts) — reasonable observation
  - *Suspicious* (25 pts) — stretching the truth
  - *Unhinged* (50 pts) — full conspiracy mode
- **Meet your report quota** before the shift timer runs out
- Survive 5 shifts of escalating paranoia

## Current Design

The world is a nighttime suburban street with 6 houses, viewed through Gerald's binoculars with a CRT/VCR surveillance camera aesthetic.

**Three zone types** determine where activities appear:
- **Window** — neighbors spotted through house windows (reading, phone calls)
- **Yard** — front yard activities (watering plants, yoga, BBQ, packages)
- **Street** — sidewalk encounters (dog walking, washing cars)

10 different activities, each with 3 tiers of increasingly paranoid report options. 5 rounds with escalating difficulty (faster spawns, tighter quotas, shorter visibility).

## Tech

- [Flutter](https://flutter.dev) + [Flame](https://flame-engine.org) game engine
- Procedural canvas-drawn background (no sprite assets yet)
- Deployed to [Cloudflare Pages](https://pages.cloudflare.com)
- Adaptive viewport — fills both desktop and mobile screens

## WIP

- All art is placeholder (colored rectangles + emoji for NPCs, canvas-drawn houses)
- Proper sprite assets and animations are planned
- Audio/SFX not yet implemented
- No persistent high scores yet

## Run Locally

```bash
flutter run -d chrome
```

## Credits

Built for the [Flame Game Jam 2025](https://itch.io/jam/flame-game-jam-2025).

GitHub: [layogtima/gerald](https://github.com/layogtima/gerald)
