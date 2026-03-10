/// All 10 activities and their 3 paranoia-level reports.
enum Activity {
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
  final List<ReportOption> reports;

  const ActivityData({
    required this.activity,
    required this.displayName,
    required this.reports,
  });
}

const List<ActivityData> allActivities = [
  ActivityData(
    activity: Activity.wateringPlants,
    displayName: 'Watering Plants',
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
];
