/// Which weirdness tier a shift unlocks. Higher tiers = stranger activities.
/// Tier 1: mundane, Tier 2: odd, Tier 3: surreal, Tier 4: magical, Tier 5: existential
int tierForShift(int shift) {
  if (shift == 0) return 1;
  if (shift <= 2) return 2;
  if (shift <= 4) return 3;
  if (shift <= 6) return 4;
  return 5;
}
