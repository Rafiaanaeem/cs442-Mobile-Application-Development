/// Course Roster Console App — Lab 1
/// Name: Rafia Naeem
/// Roll No: 04072313032

void main() {
  // ---------- Part 1: Setup & Welcome ----------
  printWelcome('Course Roster Manager');

  // ---------- Part 2: Course & Roster Data ----------
  const int maxCapacity = 4;
  final DateTime createdAt = DateTime.now();

  String courseTitle = 'CS201: Mobile App Development';
  int capacity = maxCapacity;
  double creditHours = 3.0;
  bool isOpen = true;

  List<String> enrolledStudents = ['Aiden', 'Maria', 'Jamal'];

  Set<String> waitlist = {'Priya', 'Noah'};

  Map<String, int> attendanceCount = {'Aiden': 3, 'Maria': 4, 'Jamal': 2};

  print(
    '$courseTitle | Capacity: $capacity | Enrolled: ${enrolledStudents.length}',
  );

  print('Created at: $createdAt');

  // ---------- Part 3: Null-Safe Instructor Info ----------
  String? instructorEmail;

  print(instructorEmail ?? 'TBA');

  late String enrollmentCode;

  enrollmentCode = generateCode(courseTitle);

  print('Enrollment code: $enrollmentCode');

  // Safe version of the deliberately crashing ! example.
  print('Instructor email length: ${instructorEmail?.length ?? 0}');

  // ---------- Part 4: Formatting Strings ----------
  String rawNames = ' Aiden , maria ,JAMAL , Priya ';

  List<String> cleanNames = [];

  for (String name in rawNames.split(',')) {
    cleanNames.add(name.trim());
  }

  print('Clean names: $cleanNames');

  String courseDescription =
      '''
Course: $courseTitle
Credit Hours: $creditHours
Capacity: $capacity students
''';

  print(courseDescription);

  print('Seats left: ${capacity - enrolledStudents.length}');

  // ---------- Part 5: Operators in Action ----------
  int fullGroups = enrolledStudents.length ~/ 3;
  int leftover = enrolledStudents.length % 3;

  print('Full groups of 3: $fullGroups, leftover: $leftover');

  Object formInput = 'twenty-two';

  if (formInput is String) {
    print('This is text!');
  }

  if (formInput is! int) {
    print('This input is not an integer.');
  }

  final report = StringBuffer()
    ..write('Report: $courseTitle')
    ..write(' | Cap: $capacity')
    ..write(' | Roster: ${enrolledStudents.length}');

  print(report.toString());

  List<String>? extraNotes;

  extraNotes?..add('Room change pending');

  print('Extra notes: $extraNotes');

  int? bonusSeats;

  bonusSeats ??= 0;

  print('Bonus seats: $bonusSeats');

  // ---------- Part 6: Enrollment Logic ----------
  if (isOpen && enrolledStudents.length < capacity) {
    print("You're in! Welcome aboard.");
  } else {
    print('Sorry, enrollment is closed or the course is full.');
  }

  int enrollmentStatusCode = 200;

  switch (enrollmentStatusCode) {
    case 200:
      print('Enrolled');
      break;

    case 404:
      print('Course not found');
      break;

    default:
      print('Unknown error');
      break;
  }

  String statusTag = isOpen ? 'OPEN' : 'FULL';

  print(statusTag);

  // ---------- Part 7: Reports & Loops ----------

  // for-in loop
  for (String student in enrolledStudents) {
    print(student);
  }

  // forEach loop
  attendanceCount.forEach((student, count) {
    print('$student: $count');
  });

  // Collection literal with embedded if and for
  List<String> announcements = [
    'Welcome to $courseTitle',
    if (!isOpen) 'Course is FULL — waitlist open',
    for (var student in waitlist)
      'Reminder: $student, please confirm attendance',
  ];

  // Print each announcement
  for (String announcement in announcements) {
    print(announcement);
  }
}

/// Prints the welcome banner for the Course Roster application.
void printWelcome(String appName) {
  print('=== $appName ===');
}

/// Generates an enrollment code from the first two
/// characters of the course title.
String generateCode(String title) {
  return title.substring(0, 2).toUpperCase() + '101';
}
