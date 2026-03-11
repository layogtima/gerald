import 'dart:ui' show Color;

import 'zone_type.dart';

/// All activities and their 4 internal-monologue choices.
enum Activity {
  // Act 1 — Normal suburban life (always available)
  wateringPlants,
  carryingGroceries,
  doingYoga,
  walkingDog,
  readingOnPorch,
  receivingPackage,
  leavingHouseEarly,
  barbecuing,
  washingCar,
  talkingOnPhone,
  hangingLaundry,
  checkingMailbox,
  playingWithKids,
  sweepingPorch,
  feedingBirds,
  // Act 2 — Something's Off + Pushback (shifts 3-4)
  measuringFence,
  identicalTwins,
  nightGardening,
  photographingHouses,
  signingPetition,
  puttingUpSigns,
  tooManyVisitors,
  loudMusic,
  // Act 3 — The Watchers (shift 5)
  watchingYouBack,
  writingReportAboutYou,
  installingCamera,
  neighborhoodMeeting,
  formingHumanChain,
}

class ReportOption {
  final String text; // Gerald's internal monologue
  final int tension; // Hidden: 0, 2, 5, or 12
  final String? consequence; // Newspaper headline (null = no story)

  const ReportOption({
    required this.text,
    required this.tension,
    this.consequence,
  });
}

class ActivityData {
  final Activity activity;
  final String displayName;
  final String emoji;
  final Color color;
  final List<ZoneType> compatibleZones;
  final List<ReportOption> reports; // exactly 4 choices
  final int minAct; // 1 = always, 2 = Act 2+, 3 = Act 3

  const ActivityData({
    required this.activity,
    required this.displayName,
    required this.emoji,
    required this.color,
    required this.compatibleZones,
    required this.reports,
    this.minAct = 1,
  });
}

const List<ActivityData> allActivities = [
  // ============================================================
  // ACT 1 — Normal suburban life
  // ============================================================
  ActivityData(
    activity: Activity.wateringPlants,
    displayName: 'Watering Plants',
    emoji: '🌱',
    color: Color(0xFF4CAF50),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(text: '...just gardening.', tension: 0),
      ReportOption(
        text: 'Same plant. Three days running.',
        tension: 2,
        consequence: 'Garden Club Issues Overwatering Advisory',
      ),
      ReportOption(
        text: 'The pressure is all wrong for petunias.',
        tension: 5,
        consequence: 'Water Pressure Complaint Triggers Utility Review',
      ),
      ReportOption(
        text: "That plant is dead. They're watering a grave.",
        tension: 12,
        consequence: 'ORDINANCE 51-A: Unsupervised Yard Digging Now Requires Permit',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.carryingGroceries,
    displayName: 'Carrying Groceries',
    emoji: '🛒',
    color: Color(0xFFFF9800),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    reports: [
      ReportOption(text: 'Normal shopping trip.', tension: 0),
      ReportOption(
        text: 'Six bags. On a Tuesday.',
        tension: 2,
        consequence: 'Local Store Reports Rise in Bulk Purchasing',
      ),
      ReportOption(
        text: 'Nobody needs that many bags for one person.',
        tension: 5,
        consequence: 'NEW GUIDELINE: Single-Household Bag Limits Suggested',
      ),
      ReportOption(
        text: 'Fourteen lemons. The syndicate lives.',
        tension: 12,
        consequence: 'CITRUS TASK FORCE Formed After Anonymous Tip',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.doingYoga,
    displayName: 'Doing Yoga',
    emoji: '🧘',
    color: Color(0xFF9C27B0),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(text: 'Exercise. Fine.', tension: 0),
      ReportOption(
        text: 'Very flexible. Suspiciously flexible.',
        tension: 2,
        consequence: 'Parks Dept. Reminds Residents of Exercise Etiquette',
      ),
      ReportOption(
        text: "That's not a yoga pose I recognize.",
        tension: 5,
        consequence: 'COMPLAINT: Unusual Physical Activity on Residential Lawn',
      ),
      ReportOption(
        text: 'Escape preparation. Obviously.',
        tension: 12,
        consequence: 'ORDINANCE 88-C: Outdoor Calisthenics Require 48-Hour Notice',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.walkingDog,
    displayName: 'Walking a Dog',
    emoji: '🐕',
    color: Color(0xFF795548),
    compatibleZones: [ZoneType.street],
    reports: [
      ReportOption(text: 'Just a dog walk.', tension: 0),
      ReportOption(
        text: 'Counterclockwise today. Pattern shift.',
        tension: 2,
        consequence: 'Dog Walkers Urged to Register Preferred Routes',
      ),
      ReportOption(
        text: 'It stops at every mailbox. Every single one.',
        tension: 5,
        consequence: 'NEW CURFEW: Pet Walking Restricted to 7am\u20137pm',
      ),
      ReportOption(
        text: 'Too small. Too quiet. Not a real dog.',
        tension: 12,
        consequence: 'INVESTIGATION: Unregistered Canine Units on Maple Drive',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.readingOnPorch,
    displayName: 'Reading on Porch',
    emoji: '📖',
    color: Color(0xFF2196F3),
    compatibleZones: [ZoneType.yard, ZoneType.window],
    reports: [
      ReportOption(text: "Someone reading. That's allowed.", tension: 0),
      ReportOption(
        text: 'The cover is deliberately hidden.',
        tension: 2,
        consequence: 'Library Adds Security Cameras After Patron Complaint',
      ),
      ReportOption(
        text: 'Physical books in 2026. Who does that?',
        tension: 5,
        consequence: 'ADVISORY: Residents Urged to Report Suspicious Literature',
      ),
      ReportOption(
        text: "It's hollow. It's a dead drop.",
        tension: 12,
        consequence: "BOOK BAN PROPOSED: 'For the Safety of Maple Drive'",
      ),
    ],
  ),
  ActivityData(
    activity: Activity.receivingPackage,
    displayName: 'Receiving a Package',
    emoji: '📦',
    color: Color(0xFFFFEB3B),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(text: 'Delivery. Nothing unusual.', tension: 0),
      ReportOption(
        text: 'Third one this week.',
        tension: 2,
        consequence: 'Post Office Implements Enhanced Tracking on Maple Drive',
      ),
      ReportOption(
        text: "Those dimensions don't match any standard box.",
        tension: 5,
        consequence: 'NEW RULE: Packages Over 10kg Require Inspection',
      ),
      ReportOption(
        text: 'Shadow logistics confirmed.',
        tension: 12,
        consequence: 'CUSTOMS ALERT: Maple Drive Flagged for Unusual Parcel Volume',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.leavingHouseEarly,
    displayName: 'Leaving Early',
    emoji: '🌅',
    color: Color(0xFF607D8B),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    reports: [
      ReportOption(text: 'Early riser. Some people are.', tension: 0),
      ReportOption(
        text: 'Before sunrise. Deliberate.',
        tension: 2,
        consequence: 'Street Lights Extended 2 Hours After Safety Concern',
      ),
      ReportOption(
        text: 'Nobody leaves that early voluntarily.',
        tension: 5,
        consequence: 'CURFEW PROPOSAL: Pre-Dawn Movement Requires Justification',
      ),
      ReportOption(
        text: 'Rendezvous. Has to be.',
        tension: 12,
        consequence: 'SECURITY PATROL: Dawn Hours Now Monitored on Maple Drive',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.barbecuing,
    displayName: 'Barbecuing',
    emoji: '🔥',
    color: Color(0xFFF44336),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(text: 'Outdoor cooking. Summer.', tension: 0),
      ReportOption(
        text: 'Charcoal on a Tuesday.',
        tension: 2,
        consequence: 'Fire Dept. Issues Weekday Grilling Reminder',
      ),
      ReportOption(
        text: "That's a lot of smoke for burgers.",
        tension: 5,
        consequence: 'COMPLAINT: Excessive Smoke Prompts Air Quality Review',
      ),
      ReportOption(
        text: "Smoke signals. I've cracked it.",
        tension: 12,
        consequence: 'BURN BAN: All Outdoor Flames Require 24-Hour Notice',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.washingCar,
    displayName: 'Washing Car',
    emoji: '🚗',
    color: Color(0xFF00BCD4),
    compatibleZones: [ZoneType.street],
    reports: [
      ReportOption(text: 'Clean car. Good for them.', tension: 0),
      ReportOption(
        text: 'Twice this week already.',
        tension: 2,
        consequence: 'Water Conservation Notice Posted on Maple Drive',
      ),
      ReportOption(
        text: "The wheel wells. What's under there?",
        tension: 5,
        consequence: 'VEHICLE INSPECTION: Random Checks Begin Next Monday',
      ),
      ReportOption(
        text: 'Toothbrush on the rims. Evidence removal.',
        tension: 12,
        consequence: 'FORENSIC UNIT Requested for Maple Drive Parking Area',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.talkingOnPhone,
    displayName: 'Talking on Phone',
    emoji: '📱',
    color: Color(0xFFE91E63),
    compatibleZones: [ZoneType.window, ZoneType.yard, ZoneType.street],
    reports: [
      ReportOption(text: 'Phone call. People make those.', tension: 0),
      ReportOption(
        text: 'Twenty-three minutes. Excessive.',
        tension: 2,
        consequence: 'Cell Tower Audit Commissioned for Maple Drive Area',
      ),
      ReportOption(
        text: 'Laughing. Nobody laughs that long.',
        tension: 5,
        consequence: 'NOISE COMPLAINT: Extended Outdoor Phone Calls Under Review',
      ),
      ReportOption(
        text: 'Coded instructions. Definitely coded.',
        tension: 12,
        consequence: 'ORDINANCE 22-D: Public Calls Limited to 10 Minutes',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.hangingLaundry,
    displayName: 'Hanging Laundry',
    emoji: '👔',
    color: Color(0xFF81D4FA),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(text: 'Drying clothes. Normal.', tension: 0),
      ReportOption(
        text: 'White, red, white, red. A pattern.',
        tension: 2,
        consequence: 'HOA Reminds Residents of Clothesline Regulations',
      ),
      ReportOption(
        text: 'Who hangs laundry at this hour?',
        tension: 5,
        consequence: 'NEW BYLAW: Outdoor Drying Hours Set to 9am\u20135pm',
      ),
      ReportOption(
        text: "Semaphore. They're using flag signals.",
        tension: 12,
        consequence: 'COMMUNICATION BAN: Visual Signaling Devices Prohibited',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.checkingMailbox,
    displayName: 'Checking Mailbox',
    emoji: '📬',
    color: Color(0xFF78909C),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    reports: [
      ReportOption(text: 'Getting their mail.', tension: 0),
      ReportOption(
        text: 'They checked twice. Why twice?',
        tension: 2,
        consequence: 'Postal Service Increases Delivery Security',
      ),
      ReportOption(
        text: 'Lingered at the box. Too long.',
        tension: 5,
        consequence: 'MAILBOX AUDIT: Residents Must Register Outgoing Mail',
      ),
      ReportOption(
        text: 'Dead drop. Classic dead drop.',
        tension: 12,
        consequence: 'SURVEILLANCE CAMERAS Installed at All Maple Drive Mailboxes',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.playingWithKids,
    displayName: 'Kids Playing',
    emoji: '⚽',
    color: Color(0xFF66BB6A),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    reports: [
      ReportOption(text: 'Kids playing. Normal kid stuff.', tension: 0),
      ReportOption(
        text: 'Those kids are very organized.',
        tension: 2,
        consequence: 'Parents Reminded to Supervise Outdoor Play',
      ),
      ReportOption(
        text: "That's not a game. The formations...",
        tension: 5,
        consequence: 'PLAY HOURS: Outdoor Recreation Limited to Designated Times',
      ),
      ReportOption(
        text: "Training exercises. They're drilling.",
        tension: 12,
        consequence: 'YOUTH ACTIVITIES Must Be Pre-Approved by Neighborhood Board',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.sweepingPorch,
    displayName: 'Sweeping Porch',
    emoji: '🧹',
    color: Color(0xFF8D6E63),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(text: 'Cleaning. Commendable.', tension: 0),
      ReportOption(
        text: 'Same spot. Four times now.',
        tension: 2,
        consequence: 'Street Cleaning Schedule Expanded After Resident Request',
      ),
      ReportOption(
        text: 'Sweeping toward the drain. Destroying evidence.',
        tension: 5,
        consequence: 'DRAIN INSPECTION: Storm System Audit After Anonymous Report',
      ),
      ReportOption(
        text: 'The broom moves in morse code.',
        tension: 12,
        consequence: 'ORDINANCE 33-F: Outdoor Cleaning Restricted to Daylight',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.feedingBirds,
    displayName: 'Feeding Birds',
    emoji: '🐦',
    color: Color(0xFF43A047),
    compatibleZones: [ZoneType.yard, ZoneType.window],
    reports: [
      ReportOption(text: 'Bird feeding. Peaceful hobby.', tension: 0),
      ReportOption(
        text: 'The birds arrive at exactly the same time daily.',
        tension: 2,
        consequence: 'Wildlife Control Monitors Bird Population on Maple Drive',
      ),
      ReportOption(
        text: "Those aren't local species.",
        tension: 5,
        consequence: 'ADVISORY: Unauthorized Wildlife Feeding Under Review',
      ),
      ReportOption(
        text: 'Carrier pigeons. Analog comms network.',
        tension: 12,
        consequence: "BIRD FEEDING BANNED: 'Avian Interference' Ordinance Passes 3\u20132",
      ),
    ],
  ),

  // ============================================================
  // ACT 2 — Something's Off + Pushback (shifts 3-4)
  // ============================================================
  ActivityData(
    activity: Activity.measuringFence,
    displayName: 'Measuring Fence',
    emoji: '📏',
    color: Color(0xFF9E9E9E),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    minAct: 2,
    reports: [
      ReportOption(text: 'Probably just a contractor.', tension: 0),
      ReportOption(
        text: 'Military precision. Those measurements.',
        tension: 2,
        consequence: 'Property Survey Reveals Minor Boundary Discrepancies',
      ),
      ReportOption(
        text: "They're mapping the perimeter.",
        tension: 5,
        consequence: 'FENCE HEIGHT MAXIMUM Established: 6 Feet, No Exceptions',
      ),
      ReportOption(
        text: 'Perimeter breach planning. Textbook.',
        tension: 12,
        consequence: 'SECURITY FENCE Approved for Maple Drive Perimeter',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.identicalTwins,
    displayName: 'Identical Twins',
    emoji: '👯',
    color: Color(0xFF7B1FA2),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    minAct: 2,
    reports: [
      ReportOption(text: 'Twins. The Hendersons mentioned twins.', tension: 0),
      ReportOption(
        text: 'Are they... the same person?',
        tension: 2,
        consequence: 'Census Update Requested for Maple Drive Households',
      ),
      ReportOption(
        text: "I've only ever seen one of them.",
        tension: 5,
        consequence: 'IDENTITY CHECK: Residents Asked to Carry Neighborhood ID',
      ),
      ReportOption(
        text: 'The cloning program is operational.',
        tension: 12,
        consequence: 'EMERGENCY: Duplicate Persons Reported \u2014 ID Verification Mandatory',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.nightGardening,
    displayName: '3 AM Gardening',
    emoji: '🌙',
    color: Color(0xFF1A237E),
    compatibleZones: [ZoneType.yard],
    minAct: 2,
    reports: [
      ReportOption(text: 'Night owl. Some people garden late.', tension: 0),
      ReportOption(
        text: 'The timing is suspect.',
        tension: 2,
        consequence: 'Street Light Brightness Increased After Evening Report',
      ),
      ReportOption(
        text: 'What goes into the ground at 3 AM?',
        tension: 5,
        consequence: 'CURFEW: Outdoor Activity After 11pm Requires Permit',
      ),
      ReportOption(
        text: 'Something is being buried.',
        tension: 12,
        consequence: 'EXCAVATION BAN: All Digging Requires Municipal Oversight',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.photographingHouses,
    displayName: 'Photographing Houses',
    emoji: '📸',
    color: Color(0xFFE65100),
    compatibleZones: [ZoneType.street],
    minAct: 2,
    reports: [
      ReportOption(text: 'Probably a real estate agent.', tension: 0),
      ReportOption(
        text: 'They photographed MY house.',
        tension: 2,
        consequence: 'Photography Permits Now Required on Maple Drive',
      ),
      ReportOption(
        text: 'Building a dossier. House by house.',
        tension: 5,
        consequence: 'SURVEILLANCE ORDINANCE: Recording Devices Restricted',
      ),
      ReportOption(
        text: 'Reconnaissance. Intel gathering.',
        tension: 12,
        consequence: 'DRONE BAN: Aerial Photography Prohibited Within 500m',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.signingPetition,
    displayName: 'Signing a Petition',
    emoji: '✍️',
    color: Color(0xFF009688),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    minAct: 2,
    reports: [
      ReportOption(text: 'Civic engagement. Democracy.', tension: 0),
      ReportOption(
        text: 'What are they collecting signatures for?',
        tension: 2,
        consequence: 'Petition Circulating on Maple Drive \u2014 Contents Unknown',
      ),
      ReportOption(
        text: "Forty-seven signatures against... what?",
        tension: 5,
        consequence: "PETITION DISMISSED: 'Lacks Sufficient Evidence' Says Board",
      ),
      ReportOption(
        text: 'Organized dissent. Need to monitor.',
        tension: 12,
        consequence: 'ASSEMBLY BAN: Groups of 3+ Require Prior Authorization',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.puttingUpSigns,
    displayName: 'Putting Up Signs',
    emoji: '🪧',
    color: Color(0xFFD32F2F),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    minAct: 2,
    reports: [
      ReportOption(text: 'Free speech. Technically.', tension: 0),
      ReportOption(
        text: 'Those signs look coordinated.',
        tension: 2,
        consequence: 'Sign Ordinance Reminder: Permits Required for Postings',
      ),
      ReportOption(
        text: "'STOP WATCHING US.' Interesting.",
        tension: 5,
        consequence: 'SIGNS REMOVED: Unauthorized Postings Cleared Overnight',
      ),
      ReportOption(
        text: 'Counter-surveillance propaganda.',
        tension: 12,
        consequence: 'FREE SPEECH ZONE Established \u2014 All Other Areas Sign-Free',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.tooManyVisitors,
    displayName: 'Lots of Visitors',
    emoji: '🚪',
    color: Color(0xFFFF6F00),
    compatibleZones: [ZoneType.yard],
    minAct: 2,
    reports: [
      ReportOption(text: 'Popular household.', tension: 0),
      ReportOption(
        text: 'Five visitors in one hour.',
        tension: 2,
        consequence: 'Parking Restrictions Tightened on Maple Drive',
      ),
      ReportOption(
        text: "That's not a party. That's a meeting.",
        tension: 5,
        consequence: 'GATHERING PERMIT: Events Over 4 People Require Notice',
      ),
      ReportOption(
        text: "Cell. They're forming a cell.",
        tension: 12,
        consequence: 'GUEST REGISTRY: All Visitors Must Sign In at Gate',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.loudMusic,
    displayName: 'Playing Loud Music',
    emoji: '🎵',
    color: Color(0xFFEC407A),
    compatibleZones: [ZoneType.yard, ZoneType.window],
    minAct: 2,
    reports: [
      ReportOption(text: 'Music. People like music.', tension: 0),
      ReportOption(
        text: 'Same song. On repeat. A signal?',
        tension: 2,
        consequence: 'Noise Ordinance Hours Expanded by 2 Hours',
      ),
      ReportOption(
        text: 'The bass shakes my binoculars.',
        tension: 5,
        consequence: 'SOUND LIMIT: 60 Decibels Maximum After 6pm',
      ),
      ReportOption(
        text: 'Acoustic warfare. Testing my resolve.',
        tension: 12,
        consequence: 'MUSIC BAN: Amplified Sound Prohibited Without Permit',
      ),
    ],
  ),

  // ============================================================
  // ACT 3 — The Watchers (shift 5)
  // ============================================================
  ActivityData(
    activity: Activity.watchingYouBack,
    displayName: 'Watching You',
    emoji: '🔭',
    color: Color(0xFFD32F2F),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    minAct: 3,
    reports: [
      ReportOption(text: "They're just... looking this way.", tension: 0),
      ReportOption(
        text: 'Binoculars. Pointed HERE.',
        tension: 2,
        consequence: 'Counter-Surveillance Activity Detected on Maple Drive',
      ),
      ReportOption(
        text: 'How long have they been watching?',
        tension: 5,
        consequence: 'MUTUAL OBSERVATION: Both Parties File Simultaneous Reports',
      ),
      ReportOption(
        text: "I'm the subject now.",
        tension: 12,
        consequence: 'WATCHER WATCHED: Gerald Named in 12 Separate Reports',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.writingReportAboutYou,
    displayName: 'Writing About You',
    emoji: '📋',
    color: Color(0xFFC62828),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    minAct: 3,
    reports: [
      ReportOption(text: "They're just writing. People write.", tension: 0),
      ReportOption(
        text: 'That clipboard looks familiar.',
        tension: 2,
        consequence: 'FORMAL COMPLAINT: Resident Files Counter-Report',
      ),
      ReportOption(
        text: "They're filing a report. About ME.",
        tension: 5,
        consequence: 'INVESTIGATION: Observer Becomes Subject of Own System',
      ),
      ReportOption(
        text: "'Gerald won't stop.' Signed: Everyone.",
        tension: 12,
        consequence: "UNANIMOUS VOTE: Gerald's Watch Authority Under Review",
      ),
    ],
  ),
  ActivityData(
    activity: Activity.installingCamera,
    displayName: 'Installing a Camera',
    emoji: '📹',
    color: Color(0xFFB71C1C),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    minAct: 3,
    reports: [
      ReportOption(text: 'Security camera. Their right.', tension: 0),
      ReportOption(
        text: 'Pointed right at my window.',
        tension: 2,
        consequence: 'Camera Installation Spike: 400% Increase This Month',
      ),
      ReportOption(
        text: 'Two watchers on one street.',
        tension: 5,
        consequence: 'CAMERA NETWORK: Maple Drive Now Most Surveilled Street',
      ),
      ReportOption(
        text: "It says 'GERALD-CAM.'",
        tension: 12,
        consequence: 'DEDICATED MONITORING: Residents Pool Funds for Gerald-Facing Camera',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.neighborhoodMeeting,
    displayName: 'Neighborhood Meeting',
    emoji: '📢',
    color: Color(0xFF880E4F),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    minAct: 3,
    reports: [
      ReportOption(text: 'Community meeting. Healthy.', tension: 0),
      ReportOption(
        text: "'The Gerald Situation' is agenda item 1.",
        tension: 2,
        consequence: "Town Hall Scheduled: 'The Future of Neighborhood Watch'",
      ),
      ReportOption(
        text: 'They formed a committee. About me.',
        tension: 5,
        consequence: 'GERALD ACCOUNTABILITY TASK FORCE Established',
      ),
      ReportOption(
        text: "I'm being out-organized.",
        tension: 12,
        consequence: "VOTE PASSED: Gerald's Neighborhood Captain Status Revoked",
      ),
    ],
  ),
  ActivityData(
    activity: Activity.formingHumanChain,
    displayName: 'Human Chain',
    emoji: '🤝',
    color: Color(0xFFE53935),
    compatibleZones: [ZoneType.street],
    minAct: 3,
    reports: [
      ReportOption(text: 'Block party? Maybe?', tension: 0),
      ReportOption(
        text: "They're holding hands across the street.",
        tension: 2,
        consequence: 'Community Solidarity Event Draws Record Attendance',
      ),
      ReportOption(
        text: 'Human chain. Blocking my line of sight.',
        tension: 5,
        consequence: "PROTEST: 'We Are Not Suspects' Movement Grows",
      ),
      ReportOption(
        text: 'Coordinated visual obstruction.',
        tension: 12,
        consequence: 'MAPLE DRIVE DECLARES INDEPENDENCE FROM GERALD',
      ),
    ],
  ),
];
