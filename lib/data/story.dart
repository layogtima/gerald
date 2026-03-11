/// Story data for each shift — briefings and Gerald's mutters.
class ShiftStory {
  final String actTitle;
  final String briefing;
  final List<String> mutters;

  const ShiftStory({
    required this.actTitle,
    required this.briefing,
    required this.mutters,
  });
}

/// 6 shifts: prologue (0) + 5 regular shifts.
/// Act 1 = shifts 0-2, Act 2 = shifts 3-4, Act 3 = shift 5.
const List<ShiftStory> shiftStories = [
  // --- PROLOGUE (Shift 0): "First Day on the Job" ---
  ShiftStory(
    actTitle: 'FIRST DAY ON THE JOB',
    briefing:
        'Another quiet evening on Maple Drive. 0% crime rate — thanks to ME.\n\n'
        'Time to earn that Neighborhood Captain badge.',
    mutters: [
      'Drag to scan the neighborhood...',
      'There! Someone suspicious. Tap them.',
      'Now file your report. Choose wisely... or don\'t.',
      'The neighborhood depends on me.',
      'First shift. Can\'t let my guard down.',
    ],
  ),

  // --- ACT 1, Shift 1: "The Routine" ---
  ShiftStory(
    actTitle: 'THE ROUTINE',
    briefing:
        'Standard patrol. The neighborhood depends on you.\n\n'
        'Remember: there is no such thing as "too suspicious."',
    mutters: [
      'Hmm... suspicious.',
      'Nobody fools Gerald.',
      'That\'s going in the report.',
      'Noted.',
      'Highly irregular.',
      'Trust no one.',
      'Classic.',
    ],
  ),

  // --- ACT 1, Shift 2: "The Routine" (cont.) ---
  ShiftStory(
    actTitle: 'THE ROUTINE',
    briefing:
        'Reports of "nothing happening" on Maple Drive.\n\n'
        'Suspicious in itself.',
    mutters: [
      'I see everything.',
      'They think they\'re clever.',
      'This one\'s definitely up to something.',
      'My surveillance log doesn\'t lie.',
      'Nobody fools Gerald. Nobody.',
      'Very interesting...',
    ],
  ),

  // --- ACT 2, Shift 3: "Something's Off" ---
  ShiftStory(
    actTitle: 'SOMETHING\'S OFF',
    briefing:
        'Multiple unusual reports from neighboring blocks.\n\n'
        'Stay sharp. Something feels... different tonight.',
    mutters: [
      'Wait... that one might actually be suspicious.',
      'Is it me, or is everyone acting strange today?',
      'Something doesn\'t feel right.',
      'That\'s new. That\'s definitely new.',
      'I don\'t remember the Hendersons having twins.',
      'Why is everyone looking over here?',
    ],
  ),

  // --- ACT 2, Shift 4: "Something's Off" (cont.) ---
  ShiftStory(
    actTitle: 'SOMETHING\'S OFF',
    briefing:
        'Gerald, we\'ve noticed some... patterns.\n\n'
        'Keep watching. Trust your instincts.',
    mutters: [
      'I don\'t like this. I don\'t like this at all.',
      'Are they... coordinating?',
      'That person was definitely looking at my house.',
      'Three people on the phone at the same time. Coincidence?',
      'I need to file a report about the report-writers.',
      'Something is very wrong on Maple Drive.',
    ],
  ),

  // --- ACT 3, Shift 5: "The Watchers" ---
  ShiftStory(
    actTitle: 'THE WATCHERS',
    briefing:
        'Something is very wrong on Maple Drive.\n\n'
        'The neighbors are acting strange. All of them. At once.\n\n'
        'Keep watching. Someone has to.',
    mutters: [
      'They\'re... watching me?',
      'How long have they known?',
      'I\'ve become what I swore to observe.',
      'Is that... binoculars? Pointed at MY window?',
      'Oh no. Oh no no no.',
      'The watcher has become the watched.',
    ],
  ),
];

/// Which "act" a shift belongs to. Used for gating activities.
/// Weirdness starts from the second shift (shift 1).
int actForShift(int shift) {
  if (shift == 0) return 1; // Prologue: normal only
  if (shift <= 3) return 2; // Shifts 1-3: weird stuff appears
  return 3; // Shifts 4-5: the watchers
}
