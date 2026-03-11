import 'dart:ui' show Color;

import 'zone_type.dart';

/// All activities Gerald can observe, and his 4 report choices for each.
enum Activity {
  // Tier 1 — Mundane (15)
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

  // Tier 2 — Odd (12)
  measuringFence,
  identicalTwins,
  nightGardening,
  photographingHouses,
  signingPetition,
  puttingUpSigns,
  tooManyVisitors,
  loudMusic,
  walkingBackwards,
  talkingToTree,
  drawingChalkSymbols,
  wearingLabCoat,

  // Tier 3 — Surreal (10)
  houseMovedOvernight,
  samePersonTwoPlaces,
  mailboxFromFuture,
  gardenGnomesMoved,
  paintingInvisibleDoor,
  clocksRunBackwards,
  shadowWrongDirection,
  birdsInFormation,
  treeGrowingFast,
  streetLongerThanYesterday,

  // Tier 4 — Magical (8)
  neighborFloating,
  catThroughFence,
  plantsWaterBack,
  stairsToNowhere,
  moonTooClose,
  mailboxGlowing,
  houseBreathing,
  skyWrongColor,

  // Tier 5 — Existential/Watchers (8)
  watchingYouBack,
  writingReportAboutYou,
  installingCamera,
  neighborhoodMeeting,
  formingHumanChain,
  geraldSeesHimself,
  everyoneFreeze,
  emptyStreetReports,
}

class ReportOption {
  final String text;
  final int tension;
  final String? consequence;
  final String? deadEnd;

  const ReportOption({
    required this.text,
    required this.tension,
    this.consequence,
    this.deadEnd,
  });
}

class ActivityData {
  final Activity activity;
  final String displayName;
  final String emoji;
  final Color color;
  final List<ZoneType> compatibleZones;
  final List<ReportOption> reports;
  final int tier;

  const ActivityData({
    required this.activity,
    required this.displayName,
    required this.emoji,
    required this.color,
    required this.compatibleZones,
    required this.reports,
    this.tier = 1,
  });
}

const List<ActivityData> allActivities = [
  // ============================================================
  // TIER 1 — Mundane (15)
  // Normal suburban life. Gerald's paranoia makes them suspicious.
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
        text: 'Contortionist training. Escape preparation.',
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
        consequence: 'NEW CURFEW: Pet Walking Restricted After Dark',
      ),
      ReportOption(
        text: 'Too small. Too quiet. Not a real dog.',
        tension: 12,
        consequence: 'INVESTIGATION: Unregistered Canine Units on Residential Street',
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
        text: 'Physical books in this day and age. Who does that?',
        tension: 5,
        consequence: 'ADVISORY: Residents Urged to Report Suspicious Literature',
      ),
      ReportOption(
        text: "It's hollow. It's a dead drop.",
        tension: 12,
        consequence: "BOOK BAN PROPOSED: 'For the Safety of This Street'",
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
        consequence: 'Post Office Implements Enhanced Tracking for Local Deliveries',
      ),
      ReportOption(
        text: "Those dimensions don't match any standard box.",
        tension: 5,
        consequence: 'NEW RULE: Packages Over 10kg Require Inspection',
      ),
      ReportOption(
        text: 'Shadow logistics confirmed.',
        tension: 12,
        consequence: 'CUSTOMS ALERT: Residential Area Flagged for Unusual Parcel Volume',
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
        consequence: 'SECURITY PATROL: Dawn Hours Now Monitored on This Street',
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
        consequence: 'Water Conservation Notice Posted on the Street',
      ),
      ReportOption(
        text: "The wheel wells. What's under there?",
        tension: 5,
        consequence: 'VEHICLE INSPECTION: Random Checks Begin Next Monday',
      ),
      ReportOption(
        text: 'Toothbrush on the rims. Evidence removal.',
        tension: 12,
        consequence: 'FORENSIC UNIT Requested for Residential Parking Area',
        deadEnd: 'Gerald called the county forensics hotline about soap '
            'residue on a Honda Civic. The dispatcher asked him to repeat '
            'himself. He did. Twice. They sent someone — not forensics. '
            'A counselor. Gerald was found explaining luminol theory to '
            'a garden hose. His binoculars were confiscated at the curb.',
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
        consequence: 'Cell Tower Audit Commissioned for This Area',
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
        consequence: 'SURVEILLANCE CAMERAS Installed at All Street Mailboxes',
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
        consequence: 'Wildlife Control Monitors Bird Population in Area',
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
  // TIER 2 — Odd (12)
  // Things that are genuinely a bit weird.
  // ============================================================
  ActivityData(
    activity: Activity.measuringFence,
    displayName: 'Measuring Fence',
    emoji: '📏',
    color: Color(0xFF9E9E9E),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 2,
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
        consequence: 'SECURITY FENCE Approved for Street Perimeter',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.identicalTwins,
    displayName: 'Identical Twins',
    emoji: '👯',
    color: Color(0xFF7B1FA2),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    tier: 2,
    reports: [
      ReportOption(text: 'Twins. It happens.', tension: 0),
      ReportOption(
        text: 'Are they... the same person?',
        tension: 2,
        consequence: 'Census Update Requested for Local Households',
      ),
      ReportOption(
        text: "I've only ever seen one of them at a time. Until now.",
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
    tier: 2,
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
        deadEnd: 'Gerald called the non-emergency line to report a burial '
            'in progress. Two officers arrived with flashlights. They found '
            'Mrs. Chen planting tulip bulbs in compost. Gerald insisted on a '
            'soil analysis. The officers suggested he go inside. The tulips '
            'bloomed beautifully that spring. Gerald was not invited to see them.',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.photographingHouses,
    displayName: 'Photographing Houses',
    emoji: '📸',
    color: Color(0xFFE65100),
    compatibleZones: [ZoneType.street],
    tier: 2,
    reports: [
      ReportOption(text: 'Probably a real estate agent.', tension: 0),
      ReportOption(
        text: 'They photographed MY house.',
        tension: 2,
        consequence: 'Photography Permits Now Required on This Street',
      ),
      ReportOption(
        text: 'Building a dossier. House by house.',
        tension: 5,
        consequence: 'SURVEILLANCE ORDINANCE: Recording Devices Restricted',
      ),
      ReportOption(
        text: 'Reconnaissance. Full spectrum intel.',
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
    tier: 2,
    reports: [
      ReportOption(text: 'Civic engagement. Democracy.', tension: 0),
      ReportOption(
        text: 'What are they collecting signatures for?',
        tension: 2,
        consequence: 'Petition Circulating on the Street \u2014 Contents Unknown',
      ),
      ReportOption(
        text: "Forty-seven signatures against... what, exactly?",
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
    tier: 2,
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
    tier: 2,
    reports: [
      ReportOption(text: 'Popular household.', tension: 0),
      ReportOption(
        text: 'Five visitors in one hour.',
        tension: 2,
        consequence: 'Parking Restrictions Tightened on This Street',
      ),
      ReportOption(
        text: "That's not a party. That's a meeting.",
        tension: 5,
        consequence: 'GATHERING PERMIT: Events Over 4 People Require Notice',
      ),
      ReportOption(
        text: "Cell structure. They're forming a cell.",
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
    tier: 2,
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
  ActivityData(
    activity: Activity.walkingBackwards,
    displayName: 'Walking Backwards',
    emoji: '🔄',
    color: Color(0xFF5C6BC0),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    tier: 2,
    reports: [
      ReportOption(text: 'Eccentric exercise. Harmless.', tension: 0),
      ReportOption(
        text: 'Deliberate. Not stumbling. Practiced.',
        tension: 2,
        consequence: 'Pedestrian Safety Review After Unusual Walking Reports',
      ),
      ReportOption(
        text: "They're rewinding. Tracing steps back to something.",
        tension: 5,
        consequence: 'SIDEWALK ADVISORY: Directional Walking Lanes Proposed',
      ),
      ReportOption(
        text: 'Time displacement rehearsal. Noted.',
        tension: 12,
        consequence: 'ORDINANCE 71-B: Reverse Pedestrian Activity Requires Escort',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.talkingToTree,
    displayName: 'Talking to a Tree',
    emoji: '🌳',
    color: Color(0xFF2E7D32),
    compatibleZones: [ZoneType.yard],
    tier: 2,
    reports: [
      ReportOption(text: 'Gardener. Talks to plants. Common.', tension: 0),
      ReportOption(
        text: 'The tree is an oak. Oaks listen.',
        tension: 2,
        consequence: 'Arborist Called to Inspect Prominent Street Tree',
      ),
      ReportOption(
        text: 'They paused. As if it answered.',
        tension: 5,
        consequence: 'PARKS DEPT: No Evidence of Listening Devices in Trees',
      ),
      ReportOption(
        text: 'Dead drop inside the trunk. Has to be.',
        tension: 12,
        consequence: 'TREE REMOVAL PETITION Filed After Surveillance Concerns',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.drawingChalkSymbols,
    displayName: 'Drawing Chalk Symbols',
    emoji: '🔷',
    color: Color(0xFF6A1B9A),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    tier: 2,
    reports: [
      ReportOption(text: 'Kids with chalk. Probably.', tension: 0),
      ReportOption(
        text: 'Those are not hopscotch squares.',
        tension: 2,
        consequence: 'Public Works to Pressure-Wash Unusual Street Markings',
      ),
      ReportOption(
        text: 'Repeating glyphs. Third time this week.',
        tension: 5,
        consequence: 'GRAFFITI TASK FORCE Reviews Chalk-Based Street Art',
      ),
      ReportOption(
        text: 'Summoning circle. Right on the pavement.',
        tension: 12,
        consequence: 'EMERGENCY ORDINANCE: All Ground Markings Require Permit',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.wearingLabCoat,
    displayName: 'Wearing a Lab Coat',
    emoji: '🥼',
    color: Color(0xFFECEFF1),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    tier: 2,
    reports: [
      ReportOption(text: 'Scientist. Or painter. Or dentist.', tension: 0),
      ReportOption(
        text: 'No hospital within five miles. Why the coat?',
        tension: 2,
        consequence: 'Residents Reminded: Professional Attire Not Regulated Outdoors',
      ),
      ReportOption(
        text: 'Sampling the soil. I saw the vials.',
        tension: 5,
        consequence: 'ENVIRONMENTAL REVIEW: Soil Samples Taken from Residential Area',
      ),
      ReportOption(
        text: 'Unlicensed experiments. In a residential zone.',
        tension: 12,
        consequence: 'HOME LABORATORY BAN Proposed After Neighborhood Complaint',
        deadEnd: 'Gerald reported an unlicensed laboratory to the city. '
            'Inspectors found Dr. Priya Anand, a retired veterinarian, '
            'treating a neighbor\'s hamster on her porch. Gerald had '
            'started a petition by then. Forty-one signatures against '
            'a hamster. Dr. Anand still treats the hamster. Gerald\'s '
            'petition was framed and hung in the vet\'s old office.',
      ),
    ],
  ),

  // ============================================================
  // TIER 3 — Surreal (10)
  // Reality bends. Gerald reports with bureaucratic seriousness.
  // ============================================================
  ActivityData(
    activity: Activity.houseMovedOvernight,
    displayName: 'House Moved Overnight',
    emoji: '🏠',
    color: Color(0xFF455A64),
    compatibleZones: [ZoneType.street],
    tier: 3,
    reports: [
      ReportOption(text: 'I must be misremembering. Houses stay put.', tension: 0),
      ReportOption(
        text: 'Number 14 was not that close to number 16 yesterday.',
        tension: 2,
        consequence: 'City Surveyor Confirms All Properties Within Legal Boundaries',
      ),
      ReportOption(
        text: 'Three feet east. I measured.',
        tension: 5,
        consequence: 'PROPERTY LINE DISPUTE: Neighbors Disagree on Foundation Placement',
      ),
      ReportOption(
        text: 'The houses are migrating. Southward.',
        tension: 12,
        consequence: 'GEOLOGICAL SURVEY Ordered After Foundation Drift Report',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.samePersonTwoPlaces,
    displayName: 'Same Person, Two Places',
    emoji: '👤',
    color: Color(0xFF37474F),
    compatibleZones: [ZoneType.street, ZoneType.window],
    tier: 3,
    reports: [
      ReportOption(text: 'Looked similar. Just similar.', tension: 0),
      ReportOption(
        text: 'Same jacket. Same walk. Both sides of the street.',
        tension: 2,
        consequence: 'Resident Reports Doppelganger Sighting; Police Decline Comment',
      ),
      ReportOption(
        text: 'One waved at the other. At themselves.',
        tension: 5,
        consequence: 'IDENTITY FRAUD SUSPECTED: Fingerprint Checks Proposed',
      ),
      ReportOption(
        text: 'The bifurcation is confirmed. File under: multiplication.',
        tension: 12,
        consequence: 'CENSUS ERROR: Street Population Count Exceeds Registered Residents',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.mailboxFromFuture,
    displayName: 'Mail from Tomorrow',
    emoji: '📮',
    color: Color(0xFF0277BD),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 3,
    reports: [
      ReportOption(text: 'Misprint on the date. Happens.', tension: 0),
      ReportOption(
        text: "Tomorrow's date. On today's mail.",
        tension: 2,
        consequence: 'Post Office Blames Sorting Machine for Date Errors',
      ),
      ReportOption(
        text: 'It references events that have not happened yet.',
        tension: 5,
        consequence: 'POSTAL INVESTIGATION: Pre-Dated Mail Flagged as Anomalous',
      ),
      ReportOption(
        text: 'Someone on this street has access to the future.',
        tension: 12,
        consequence: 'TEMPORAL MAIL ORDINANCE: All Deliveries Must Bear Current Date',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.gardenGnomesMoved,
    displayName: 'Garden Gnomes Moved',
    emoji: '🍄',
    color: Color(0xFFE53935),
    compatibleZones: [ZoneType.yard],
    tier: 3,
    reports: [
      ReportOption(text: 'Wind. Or kids. Or wind.', tension: 0),
      ReportOption(
        text: 'The red one faces my house now.',
        tension: 2,
        consequence: 'HOA Issues Reminder: Lawn Ornaments Must Face Street',
      ),
      ReportOption(
        text: "They've formed a semicircle. Overnight.",
        tension: 5,
        consequence: 'LAWN ORNAMENT AUDIT: All Decorative Figures Must Be Registered',
      ),
      ReportOption(
        text: "I will observe them directly tonight. They won't move if I'm watching.",
        tension: 12,
        consequence: 'GNOME WATCH: Resident Found on Lawn at Dawn, Refused to Explain',
        deadEnd: 'Gerald positioned himself behind a rhododendron at 11 PM '
            'with a thermos and a notebook labeled "GNOME LOG." At 3:17 AM '
            'he was certain the one with the fishing rod had shifted. He '
            'hadn\'t blinked in forty minutes. Mrs. Park found him at dawn, '
            'rigid on the lawn, binoculars trained on a ceramic fisherman. '
            'The paramedics were gentle. The gnomes were unmoved.',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.paintingInvisibleDoor,
    displayName: 'Painting an Invisible Door',
    emoji: '🚪',
    color: Color(0xFF8E24AA),
    compatibleZones: [ZoneType.yard, ZoneType.window],
    tier: 3,
    reports: [
      ReportOption(text: "Artistic expression. It's a mural.", tension: 0),
      ReportOption(
        text: 'They painted a door on a wall with no door.',
        tension: 2,
        consequence: 'Zoning Board Reviews Trompe-l\'Oeil Mural Regulations',
      ),
      ReportOption(
        text: 'They tried the handle. On the painted door.',
        tension: 5,
        consequence: 'BUILDING INSPECTION: Unauthorized Exits Under Review',
      ),
      ReportOption(
        text: 'It opened. I saw it open.',
        tension: 12,
        consequence: 'EMERGENCY PERMIT: All Doors Must Lead to Registered Rooms',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.clocksRunBackwards,
    displayName: 'Clocks Run Backwards',
    emoji: '🕰️',
    color: Color(0xFF4E342E),
    compatibleZones: [ZoneType.window],
    tier: 3,
    reports: [
      ReportOption(text: 'Battery dying. Clocks do that.', tension: 0),
      ReportOption(
        text: "Their kitchen clock goes counter-clockwise. I've confirmed it.",
        tension: 2,
        consequence: 'Novelty Clock Sales Rise After Social Media Post',
      ),
      ReportOption(
        text: "Every clock in their house. All backward. I've checked three windows.",
        tension: 5,
        consequence: 'TIME STANDARD ADVISORY: Residents Reminded of Official Time Zone',
      ),
      ReportOption(
        text: 'This house is moving backward through time. The clocks are honest.',
        tension: 12,
        consequence: 'CHRONOLOGICAL ORDINANCE: All Visible Clocks Must Show Correct Time',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.shadowWrongDirection,
    displayName: 'Shadow Wrong Direction',
    emoji: '🌑',
    color: Color(0xFF263238),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    tier: 3,
    reports: [
      ReportOption(text: 'Trick of the light. Overcast day.', tension: 0),
      ReportOption(
        text: "Sun is east. Their shadow points east. That's not how shadows work.",
        tension: 2,
        consequence: 'Resident Reports Optical Illusion; Meteorologist Consulted',
      ),
      ReportOption(
        text: 'The shadow moved independently. I timed it.',
        tension: 5,
        consequence: 'STREET LIGHTING REVIEW After Shadow Anomaly Complaint',
      ),
      ReportOption(
        text: 'The shadow is not theirs. It belongs to someone else.',
        tension: 12,
        consequence: 'SHADOW REGISTRATION: Outdoor Silhouettes Subject to Verification',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.birdsInFormation,
    displayName: 'Birds in Formation',
    emoji: '🦅',
    color: Color(0xFF546E7A),
    compatibleZones: [ZoneType.street, ZoneType.yard],
    tier: 3,
    reports: [
      ReportOption(text: 'Migration pattern. Natural behavior.', tension: 0),
      ReportOption(
        text: "That's not a V. That's a letter. An actual letter.",
        tension: 2,
        consequence: 'Ornithological Society Dismisses Formation Claims',
      ),
      ReportOption(
        text: 'They spelled something. I almost read it.',
        tension: 5,
        consequence: 'WILDLIFE ADVISORY: Unusual Avian Behavior Documented',
      ),
      ReportOption(
        text: "It said 'GERALD.' The birds spelled my name.",
        tension: 12,
        consequence: 'FAA CONTACTED: Unexplained Bird Patterns Over Residential Zone',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.treeGrowingFast,
    displayName: 'Tree Growing Fast',
    emoji: '🌲',
    color: Color(0xFF1B5E20),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 3,
    reports: [
      ReportOption(text: 'Fast-growing species. Nothing more.', tension: 0),
      ReportOption(
        text: 'It was a sapling yesterday. Now it blocks the second floor.',
        tension: 2,
        consequence: 'Arborist Cannot Explain Accelerated Growth in Local Tree',
      ),
      ReportOption(
        text: 'I can hear it growing. A creaking, at night.',
        tension: 5,
        consequence: 'EMERGENCY TRIMMING: City Arborist Dispatched to Residential Area',
      ),
      ReportOption(
        text: "It's reaching for my window. Deliberately.",
        tension: 12,
        consequence: 'BOTANICAL QUARANTINE: Fast-Growing Flora Declared Public Hazard',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.streetLongerThanYesterday,
    displayName: 'Street Seems Longer',
    emoji: '🛤️',
    color: Color(0xFF757575),
    compatibleZones: [ZoneType.street],
    tier: 3,
    reports: [
      ReportOption(text: 'Perspective trick. Streets feel different at dusk.', tension: 0),
      ReportOption(
        text: 'I counted the houses. There are more.',
        tension: 2,
        consequence: 'City Planner Reviews Complaint About Street Length Discrepancy',
      ),
      ReportOption(
        text: 'My walk to the end took four minutes longer today.',
        tension: 5,
        consequence: 'SURVEY TEAM Dispatched to Measure Residential Street',
      ),
      ReportOption(
        text: 'The street is growing. It added a house last week.',
        tension: 12,
        consequence: 'MAPPING CRISIS: GPS Coordinates No Longer Match Physical Addresses',
      ),
    ],
  ),

  // ============================================================
  // TIER 4 — Magical (8)
  // Outright impossible. Gerald doesn't notice.
  // ============================================================
  ActivityData(
    activity: Activity.neighborFloating,
    displayName: 'Neighbor Floating',
    emoji: '🎈',
    color: Color(0xFFE040FB),
    compatibleZones: [ZoneType.yard, ZoneType.window],
    tier: 4,
    reports: [
      ReportOption(text: 'Good posture. Very upright.', tension: 0),
      ReportOption(
        text: 'Their feet are not touching the ground. Unusual shoes, maybe.',
        tension: 2,
        consequence: 'Podiatrist Sees Uptick in Footwear Complaints on Local Street',
      ),
      ReportOption(
        text: 'Six inches off the lawn. I measured against the fence post.',
        tension: 5,
        consequence: 'BUILDING CODE VIOLATION: Unauthorized Elevation of Persons',
      ),
      ReportOption(
        text: 'Levitation is not covered by the HOA bylaws. Filing a gravity violation.',
        tension: 12,
        consequence: 'GRAVITY ORDINANCE Proposed; Council Table Flips During Vote',
        deadEnd: 'Gerald submitted a formal gravity violation to the neighborhood '
            'council. Form 7-G. He had invented Form 7-G. The council chair '
            'read it aloud. "Resident observed at non-standard altitude." There '
            'was a silence. Then a vote. Gerald\'s position of Neighborhood Watch '
            'Captain was dissolved 5-0. The neighbor continued to float.',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.catThroughFence,
    displayName: 'Cat Walked Through Fence',
    emoji: '🐈',
    color: Color(0xFFFF6E40),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 4,
    reports: [
      ReportOption(text: 'Squeezed through a gap. Cats are flexible.', tension: 0),
      ReportOption(
        text: 'There is no gap. I checked.',
        tension: 2,
        consequence: 'Animal Control Unable to Locate Cat Reported on Street',
      ),
      ReportOption(
        text: 'Through. Not under, not over. Through the solid wood.',
        tension: 5,
        consequence: 'FENCE INTEGRITY INSPECTION After Animal Phasing Report',
      ),
      ReportOption(
        text: 'The cat is not subject to the fence. The fence is subject to the cat.',
        tension: 12,
        consequence: 'ANIMAL REGISTRATION: All Pets Must Demonstrate Solid-State Compliance',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.plantsWaterBack,
    displayName: 'Plants Watering Back',
    emoji: '💧',
    color: Color(0xFF00897B),
    compatibleZones: [ZoneType.yard],
    tier: 4,
    reports: [
      ReportOption(text: 'Sprinkler splash-back. Physics.', tension: 0),
      ReportOption(
        text: 'The hose was off. The plant was still dripping. Upward.',
        tension: 2,
        consequence: 'Plumber Finds No Explanation for Reverse Water Flow in Garden',
      ),
      ReportOption(
        text: 'The sunflower aimed the water at the owner. Deliberately.',
        tension: 5,
        consequence: 'BOTANICAL ADVISORY: Aggressive Hydration Reported in Local Gardens',
      ),
      ReportOption(
        text: 'Reciprocal care arrangement. The plants are tending the humans now.',
        tension: 12,
        consequence: 'HORTICULTURE EMERGENCY: Plants Reclassified as Active Participants',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.stairsToNowhere,
    displayName: 'Stairs to Nowhere',
    emoji: '🪜',
    color: Color(0xFF6D4C41),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 4,
    reports: [
      ReportOption(text: 'Unfinished construction project.', tension: 0),
      ReportOption(
        text: 'The stairs go up. There is nothing up there.',
        tension: 2,
        consequence: 'Building Inspector Cannot Locate Destination of Outdoor Staircase',
      ),
      ReportOption(
        text: 'They walked up. They did not come down.',
        tension: 5,
        consequence: 'MISSING PERSONS REPORT: Resident Last Seen Ascending Staircase',
      ),
      ReportOption(
        text: 'The stairs go somewhere. We just cannot see where.',
        tension: 12,
        consequence: 'CONSTRUCTION FREEZE: All Staircases Must Have Documented Endpoints',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.moonTooClose,
    displayName: 'Moon Too Close',
    emoji: '🌕',
    color: Color(0xFFBDBDBD),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    tier: 4,
    reports: [
      ReportOption(text: 'Full moon. They look bigger near the horizon.', tension: 0),
      ReportOption(
        text: 'The moon is behind the Hendersons\' chimney. It was above it last month.',
        tension: 2,
        consequence: 'Astronomy Club Reports No Abnormalities in Lunar Orbit',
      ),
      ReportOption(
        text: 'I could see the craters without binoculars. That is not right.',
        tension: 5,
        consequence: 'NASA QUERY: Local Resident Reports Lunar Proximity Concerns',
      ),
      ReportOption(
        text: 'The moon is specifically closer to this street. I am calling NASA.',
        tension: 12,
        consequence: 'ASTRONOMICAL INCIDENT: Resident Detained After Calling NASA Hotline',
        deadEnd: 'Gerald called NASA\'s public affairs line at 2:47 AM to report '
            'a "localized lunar anomaly." He was transferred four times. The '
            'final transfer was to a crisis counselor in Topeka. Gerald '
            'explained, patiently, that the moon was 200 feet above the '
            'Hendersons\' roof. The counselor was very kind. Gerald\'s '
            'binoculars were placed in a sealed bag labeled "personal effects."',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.mailboxGlowing,
    displayName: 'Mailbox Glowing',
    emoji: '✉️',
    color: Color(0xFFFFD54F),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 4,
    reports: [
      ReportOption(text: 'Reflective paint. Or a phone left inside.', tension: 0),
      ReportOption(
        text: 'Steady amber glow. No visible light source.',
        tension: 2,
        consequence: 'Electrician Finds No Wiring Connected to Glowing Mailbox',
      ),
      ReportOption(
        text: "It pulses. Rhythmically. Like it's breathing.",
        tension: 5,
        consequence: 'HAZMAT CALLED: Luminescent Mailbox Defies Explanation',
      ),
      ReportOption(
        text: "The mailbox is receiving something that isn't mail.",
        tension: 12,
        consequence: 'POSTAL EMERGENCY: Non-Physical Deliveries Reported on Residential Street',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.houseBreathing,
    displayName: 'House Breathing',
    emoji: '🫁',
    color: Color(0xFF8D6E63),
    compatibleZones: [ZoneType.street, ZoneType.window],
    tier: 4,
    reports: [
      ReportOption(text: 'Old houses creak. Thermal expansion.', tension: 0),
      ReportOption(
        text: 'The walls expand and contract. Rhythmically.',
        tension: 2,
        consequence: 'Structural Engineer Puzzled by Oscillating Wall Measurements',
      ),
      ReportOption(
        text: 'I matched it to a metronome. 14 breaths per minute.',
        tension: 5,
        consequence: 'BUILDING INSPECTION: House Exhibits Unexplained Structural Rhythm',
      ),
      ReportOption(
        text: 'The house is alive. I will not be filing a noise complaint against a living house.',
        tension: 12,
        consequence: 'ZONING CRISIS: Residential Property May Require Reclassification as Organism',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.skyWrongColor,
    displayName: 'Sky Is Wrong Color',
    emoji: '🌆',
    color: Color(0xFFCE93D8),
    compatibleZones: [ZoneType.window, ZoneType.yard, ZoneType.street],
    tier: 4,
    reports: [
      ReportOption(text: 'Unusual sunset. Atmospheric particles.', tension: 0),
      ReportOption(
        text: 'Green. The sky is green. It is 2 PM.',
        tension: 2,
        consequence: 'Weather Service Attributes Green Sky to Rare Atmospheric Event',
      ),
      ReportOption(
        text: 'Only over this street. The next block has a normal sky.',
        tension: 5,
        consequence: 'MICROCLIMATE STUDY: Localized Atmospheric Anomaly Under Review',
      ),
      ReportOption(
        text: 'The sky is a different color because this is a different place now.',
        tension: 12,
        consequence: 'DIMENSIONAL ADVISORY: Residents Urged to Confirm Reality of Surroundings',
      ),
    ],
  ),

  // ============================================================
  // TIER 5 — Existential / Watchers (8)
  // Gerald becomes the subject. Reality questions itself.
  // ============================================================
  ActivityData(
    activity: Activity.watchingYouBack,
    displayName: 'Watching You Back',
    emoji: '🔭',
    color: Color(0xFFD32F2F),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    tier: 5,
    reports: [
      ReportOption(text: "They're just looking this way. Coincidence.", tension: 0),
      ReportOption(
        text: 'Binoculars. Pointed HERE.',
        tension: 2,
        consequence: 'Counter-Surveillance Activity Detected on Residential Street',
      ),
      ReportOption(
        text: 'They are taking notes. About me. In a binder.',
        tension: 5,
        consequence: 'MUTUAL OBSERVATION: Both Parties File Simultaneous Reports',
      ),
      ReportOption(
        text: "I'm the subject now. I've always been the subject.",
        tension: 12,
        consequence: 'WATCHER WATCHED: Gerald Named in 12 Separate Counter-Reports',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.writingReportAboutYou,
    displayName: 'Writing About You',
    emoji: '📋',
    color: Color(0xFFC62828),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    tier: 5,
    reports: [
      ReportOption(text: "They're just writing. Journaling, perhaps.", tension: 0),
      ReportOption(
        text: 'That clipboard looks exactly like mine.',
        tension: 2,
        consequence: 'FORMAL COMPLAINT: Resident Files Counter-Report on Neighborhood Watch',
      ),
      ReportOption(
        text: "They're filing a report. About ME. On MY forms.",
        tension: 5,
        consequence: 'INVESTIGATION: Observer Becomes Subject of Own System',
      ),
      ReportOption(
        text: "I am filing a report about them filing a report about me.",
        tension: 12,
        consequence: "RECURSIVE COMPLAINT: Gerald's Report About the Report Gets Rejected",
        deadEnd: 'Gerald submitted Report 2,741: "Resident observed writing a report '
            'about the Neighborhood Watch Captain (me)." The council reviewed it. '
            'They found the counter-report more credible. Gerald appealed with '
            'Report 2,742: a report about the rejection of the report about the '
            'report. It was rejected on the grounds of infinite regression. '
            'Gerald is still writing the appeal.',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.installingCamera,
    displayName: 'Installing a Camera',
    emoji: '📹',
    color: Color(0xFFB71C1C),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    tier: 5,
    reports: [
      ReportOption(text: 'Security camera. Their right.', tension: 0),
      ReportOption(
        text: 'Pointed directly at my window. Directly.',
        tension: 2,
        consequence: 'Camera Installation Spike: 400% Increase This Month',
      ),
      ReportOption(
        text: 'Two watchers on one street. This is an arms race.',
        tension: 5,
        consequence: 'CAMERA NETWORK: This Street Now Most Surveilled in County',
      ),
      ReportOption(
        text: "The label says 'GERALD-CAM.' In stencil.",
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
    tier: 5,
    reports: [
      ReportOption(text: 'Community meeting. Healthy civic life.', tension: 0),
      ReportOption(
        text: "'The Gerald Situation' is agenda item one.",
        tension: 2,
        consequence: "Town Hall Scheduled: 'The Future of Neighborhood Watch'",
      ),
      ReportOption(
        text: 'They formed a committee. About me. With bylaws.',
        tension: 5,
        consequence: 'GERALD ACCOUNTABILITY TASK FORCE Established',
      ),
      ReportOption(
        text: "I'm being out-organized. They have a treasurer.",
        tension: 12,
        consequence: "VOTE PASSED: Gerald's Neighborhood Watch Authority Revoked 14\u20131",
      ),
    ],
  ),
  ActivityData(
    activity: Activity.formingHumanChain,
    displayName: 'Human Chain',
    emoji: '🤝',
    color: Color(0xFFE53935),
    compatibleZones: [ZoneType.street],
    tier: 5,
    reports: [
      ReportOption(text: 'Block party, probably.', tension: 0),
      ReportOption(
        text: "They're holding hands across the street. All of them.",
        tension: 2,
        consequence: 'Community Solidarity Event Draws Record Attendance',
      ),
      ReportOption(
        text: 'Human chain. Blocking my line of sight. Coordinated.',
        tension: 5,
        consequence: "PROTEST: 'We Are Not Suspects' Movement Gains Traction",
      ),
      ReportOption(
        text: 'Visual obstruction protocol. They have rehearsed this.',
        tension: 12,
        consequence: 'THE STREET DECLARES INDEPENDENCE FROM GERALD',
        deadEnd: 'The neighbors formed a continuous human chain from one end '
            'of the street to the other, blocking every sightline Gerald had. '
            'They read a prepared statement. It was brief: "We, the residents '
            'of this street, hereby declare ourselves an independent observation-'
            'free zone." They had a flag. Gerald filed a report about the flag. '
            'No one was left to receive it.',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.geraldSeesHimself,
    displayName: 'Gerald Sees Himself',
    emoji: '🪞',
    color: Color(0xFF311B92),
    compatibleZones: [ZoneType.street, ZoneType.window],
    tier: 5,
    reports: [
      ReportOption(text: 'Resemblance. Everyone has a double somewhere.', tension: 0),
      ReportOption(
        text: 'Same jacket. Same binoculars. Same posture.',
        tension: 2,
        consequence: 'Resident Reports Encountering Look-Alike on Morning Walk',
      ),
      ReportOption(
        text: 'He was filing a report. My report. In my handwriting.',
        tension: 5,
        consequence: 'IDENTITY CRISIS: Duplicate Watch Captain Sighting Unresolved',
      ),
      ReportOption(
        text: 'I am watching me watch me. I must report this to myself.',
        tension: 12,
        consequence: 'PARADOX ALERT: Two Identical Reports Filed From Same Address Simultaneously',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.everyoneFreeze,
    displayName: 'Everyone Freezes',
    emoji: '🧊',
    color: Color(0xFF90A4AE),
    compatibleZones: [ZoneType.street, ZoneType.yard, ZoneType.window],
    tier: 5,
    reports: [
      ReportOption(text: 'Just a quiet moment. People pause.', tension: 0),
      ReportOption(
        text: 'Everyone. All at once. Mid-step. For eleven seconds.',
        tension: 2,
        consequence: 'Flash Mob Suspected After Mass Stillness Event on Local Street',
      ),
      ReportOption(
        text: 'Only I kept moving. Only I noticed.',
        tension: 5,
        consequence: 'UNEXPLAINED PAUSE: Residents Cannot Recall 11-Second Gap',
      ),
      ReportOption(
        text: 'Time stopped for everyone but me. I am outside the pause.',
        tension: 12,
        consequence: 'TEMPORAL INCIDENT REPORT Filed; Council Has No Form For This',
      ),
    ],
  ),
  ActivityData(
    activity: Activity.emptyStreetReports,
    displayName: 'Empty Street, Full Reports',
    emoji: '📝',
    color: Color(0xFF424242),
    compatibleZones: [ZoneType.street, ZoneType.window],
    tier: 5,
    reports: [
      ReportOption(text: 'Quiet day. Nothing to report.', tension: 0),
      ReportOption(
        text: 'Nothing is happening. That is itself suspicious.',
        tension: 2,
        consequence: 'Neighborhood Watch Captain Files Report on Absence of Activity',
      ),
      ReportOption(
        text: 'No people. No cars. No birds. The street is holding its breath.',
        tension: 5,
        consequence: 'GHOST STREET: Authorities Investigate Reports of Deserted Residential Area',
      ),
      ReportOption(
        text: 'The street is watching me watch nothing. I will file a report about the nothing.',
        tension: 12,
        consequence: 'FINAL REPORT: Gerald Files Complaint Against Silence Itself',
      ),
    ],
  ),
];
