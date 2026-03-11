import 'dart:ui' show Color;

import 'zone_type.dart';

/// All activities and their 3 paranoia-level reports.
enum Activity {
  // Act 1 (always available)
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
  // Act 2 (shifts 3-4)
  measuringFence,
  identicalTwins,
  nightGardening,
  photographingHouses,
  // Act 3 (shift 5)
  watchingYouBack,
  writingReportAboutYou,
  installingCamera,
  neighborhoodMeeting,
}

class ReportOption {
  final int level; // 1, 2, or 3
  final String text;
  final int points;

  const ReportOption({
    required this.level,
    required this.text,
    required this.points,
  });
}

class ActivityData {
  final Activity activity;
  final String displayName;
  final String emoji;
  final Color color;
  final List<ZoneType> compatibleZones;
  final List<ReportOption> reports;
  final int minAct; // 1 = always available, 2 = Act 2+, 3 = Act 3 only

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
  // ACT 1 — Normal suburban activities (always available)
  // ============================================================
  ActivityData(
    activity: Activity.wateringPlants,
    displayName: 'Watering Plants',
    emoji: '🌱',
    color: Color(0xFF4CAF50),
    compatibleZones: [ZoneType.yard],
    reports: [
      ReportOption(
        level: 1,
        text: 'Resident irrigating foliage. Appears routine.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text: 'Garden hosed at irregular pressure. Possible coded water signal.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Subject has been watering the SAME PLANT for 3 days. That plant is already dead. What is being buried?',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Resident transporting provisions. Bag count: standard.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Unusually heavy bag detected. Contents exceed normal nutritional requirements.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Subject purchased 14 lemons. Nobody needs 14 lemons. Lemon syndicate activity suspected.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Resident performing stretching exercises on lawn.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text: 'Downward dog held for 47 seconds. Suspiciously flexible.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            "Subject assuming surveillance evasion postures. 'Yoga' is clearly cover for advanced flexibility training.",
        points: 50,
      ),
    ],
  ),
  ActivityData(
    activity: Activity.walkingDog,
    displayName: 'Walking a Small Dog',
    emoji: '🐕',
    color: Color(0xFF795548),
    compatibleZones: [ZoneType.street],
    reports: [
      ReportOption(
        level: 1,
        text: 'Canine exercise observed. Dog appears regulation-sized.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Dog walked counterclockwise today. Yesterday was clockwise. Alternating pattern.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'That is NOT a real dog. No dog is that small. Possible robotic reconnaissance unit.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Subject reading unidentified literature outdoors.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Book cover obscured. Deliberate concealment of reading material noted.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            "Nobody reads PHYSICAL BOOKS in 2026. This is a dead-drop. The 'book' is hollow.",
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Delivery received. Standard residential mail activity.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Package dimensions inconsistent with typical online purchases.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Third package this WEEK. No one orders this much. Shadow logistics network confirmed.',
        points: 50,
      ),
    ],
  ),
  ActivityData(
    activity: Activity.leavingHouseEarly,
    displayName: 'Leaving the House Early',
    emoji: '🌅',
    color: Color(0xFF607D8B),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    reports: [
      ReportOption(
        level: 1,
        text: 'Resident departed at 0547. Earlier than usual.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text: 'Pre-dawn exit suggests desire to avoid detection.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'WHO leaves their house before sunrise voluntarily? Nobody. This is a rendezvous.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Outdoor cooking activity in progress. Smoke detected.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Charcoal usage on a TUESDAY. Outside normal weekend grilling patterns.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            "Smoke signals. They're using smoke signals. I've cracked the code.",
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Vehicle maintenance observed. Appears routine.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text: 'Car washed twice this week. What are they cleaning off?',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Subject scrubbing wheel wells with a TOOTHBRUSH. Destroying forensic evidence.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Resident engaged in mobile communication.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Call lasted 23 minutes. Excessive for standard social interaction.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Subject LAUGHING during call. Nobody laughs that much naturally. Receiving coded instructions.',
        points: 50,
      ),
    ],
  ),

  // ============================================================
  // ACT 2 — Something's Off (inverted logic: mild=paranoid, unhinged=reasonable)
  // ============================================================
  ActivityData(
    activity: Activity.measuringFence,
    displayName: 'Measuring Your Fence',
    emoji: '📏',
    color: Color(0xFF9E9E9E),
    compatibleZones: [ZoneType.yard, ZoneType.street],
    minAct: 2,
    reports: [
      ReportOption(
        level: 1,
        text:
            'Someone measuring our fence. Clearly planning a perimeter breach.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Suspect taking precise measurements of property boundaries. Surveying for... something.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Actually, they might just be from the city planning office. This looks official.',
        points: 50,
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
      ReportOption(
        level: 1,
        text:
            'Two identical people. The cloning program is operational.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Subjects appear to be... the same person? Temporal anomaly?',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Oh wait. Those are just twins. The Hendersons mentioned this.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Digging at night. Burying evidence, obviously.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Nocturnal soil disturbance detected. What\'s going in that hole?',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Some people garden at odd hours to avoid sun. Still... the timing.',
        points: 50,
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
      ReportOption(
        level: 1,
        text:
            'Subject documenting residential structures. Reconnaissance confirmed.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Multiple photos taken of houses. Building a target dossier?',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'Could be a real estate photographer. But why THIS street?',
        points: 50,
      ),
    ],
  ),

  // ============================================================
  // ACT 3 — The Watchers (neighbors watching Gerald back)
  // ============================================================
  ActivityData(
    activity: Activity.watchingYouBack,
    displayName: 'Watching You Back',
    emoji: '🔭',
    color: Color(0xFFD32F2F),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    minAct: 3,
    reports: [
      ReportOption(
        level: 1,
        text: 'Subject appears to be... observing this location.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text: 'They have BINOCULARS. Pointed at MY window.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text: 'Wait. Am I... the subject of their surveillance?',
        points: 50,
      ),
    ],
  ),
  ActivityData(
    activity: Activity.writingReportAboutYou,
    displayName: 'Writing a Report About You',
    emoji: '📋',
    color: Color(0xFFC62828),
    compatibleZones: [ZoneType.window, ZoneType.yard],
    minAct: 3,
    reports: [
      ReportOption(
        level: 1,
        text: 'Subject is writing something while looking this way.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'That clipboard. That pen. They\'re filing a report. About ME.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'INCIDENT REPORT: \'Gerald won\'t stop watching us.\' Signed: Everyone.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Security camera installation in progress. Pointed at... here.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Surveillance equipment being mounted. This neighborhood has TWO watchers now.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'The camera has a label: \'GERALD-CAM.\' They named it after me.',
        points: 50,
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
      ReportOption(
        level: 1,
        text: 'Multiple residents gathered. Appears organized.',
        points: 10,
      ),
      ReportOption(
        level: 2,
        text:
            'Agenda item visible: \'The Gerald Situation.\' I\'m an AGENDA ITEM.',
        points: 25,
      ),
      ReportOption(
        level: 3,
        text:
            'They\'ve formed a committee. The \'Gerald Accountability Task Force.\'',
        points: 50,
      ),
    ],
  ),
];
