/// CS442 Lab 3 — Library Desk Assistant
/// Name: Rafia Naeem
/// Roll No: 04072313032

final List<Map<String, dynamic>> books = [
  {
    'title': 'Dart in Action',
    'author': 'Ada',
    'year': 2021,
    'copies': 3,
    'tags': ['dart', 'programming'],
  },
  {
    'title': 'Flutter Basics',
    'author': 'Sam',
    'year': 2023,
    'copies': 0,
    'tags': ['flutter', 'mobile'],
  },
  {
    'title': 'Clean Code',
    'author': 'Martin',
    'year': 2008,
    'copies': 2,
    'tags': ['programming', 'design'],
  },
  {
    'title': 'Algorithms',
    'author': 'Knuth',
    'year': 1968,
    'copies': 1,
    'tags': ['programming', 'math'],
  },
  {
    'title': 'UI Design',
    'author': 'Nora',
    'year': 2019,
    'copies': 4,
    'tags': ['design', 'mobile'],
  },
];

double lateFee(int daysLate, double ratePerDay) => daysLate * ratePerDay;

String formatTitle(String title, [String? author]) {
  if (author == null) {
    return title;
  }
  return '$title by $author';
}

Map<String, dynamic> makeBook({
  required String title,
  required String author,
  int year = 2024,
  int copies = 1,
}) {
  return {'title': title, 'author': author, 'year': year, 'copies': copies};
}

bool isClassic(int year) => year < 2000;
void part1() {
  print('--- Part 1 ---');
  print('Late fee: ${lateFee(5, 0.5)}');
  print(formatTitle('Dart in Action'));
  print(formatTitle('Dart in Action', 'Ada'));
  print(makeBook(title: 'Clean Code', author: 'Martin'));
  print(makeBook(title: 'Algorithms', author: 'Knuth', year: 1968));
  print(isClassic(1968));
  print(isClassic(2021));
}

// part 2 helper functions
List<String> transformAll(List<String> items, String Function(String) fn) {
  return items.map(fn).toList();
}

int Function() makeCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

double Function(int) makeFeeCalculator(double rate) {
  return (int days) => days * rate;
}

int sumDigits(int n) {
  if (n < 10) {
    return n;
  }
  return n % 10 + sumDigits(n ~/ 10);
}

void part2() {
  print('--- Part 2 ---');

  final titles = ['Dart in Action', 'Clean Code'];

  print(transformAll(titles, (title) => title.toUpperCase()));
  print(transformAll(titles, (title) => '$title!'));

  final desk1 = makeCounter();
  final desk2 = makeCounter();

  print(desk1());
  print(desk1());
  print(desk1());
  print(desk2());

  final studentFee = makeFeeCalculator(0.25);
  final staffFee = makeFeeCalculator(0.10);

  print('Student fee: ${studentFee(4)}');
  print('Staff fee: ${staffFee(4)}');
  print('Sum of digits: ${sumDigits(125)}');
}

Map<String, int> buildStock() {
  return {
    for (final book in books) book['title'] as String: book['copies'] as int,
  };
}

void part3() {
  print('--- Part 3 ---');

  final titles = books.map((b) => b['title'] as String).toList();
  print('Titles: $titles');

  final available = books
      .where((b) => (b['copies'] as int) >= 1)
      .map((b) => b['title'] as String)
      .toList();
  print('Available: $available');

  final totalCopies = books.fold<int>(
    0,
    (total, b) => total + (b['copies'] as int),
  );
  print('Total copies: $totalCopies');

  final years = books.map((b) => b['year'] as int).toList();
  final oldestYear = years.reduce((a, b) => a < b ? a : b);
  print('Oldest year: $oldestYear');

  final sortedBooks = List<Map<String, dynamic>>.of(books);
  sortedBooks.sort((a, b) => (a['year'] as int).compareTo(b['year'] as int));
  print('By year: ${sortedBooks.map((b) => b['title']).toList()}');

  final stock = buildStock();
  print('Stock: $stock');

  stock.forEach((title, copies) {
    if (copies == 0) {
      print('Out of stock: $title');
    }
  });

  print('Copies of Unknown: ${stock['Unknown'] ?? 0}');

  final allTags = <String>{
    for (final book in books) ...(book['tags'] as List<String>),
  };
  print('All tags: $allTags');

  final a = {'Dart in Action', 'Clean Code', 'Flutter Basics'};
  final b = {'Clean Code', 'Flutter Basics', 'Algorithms'};

  print('Union: ${a.union(b)}');
  print('Common: ${a.intersection(b)}');
  print('Only in A: ${a.difference(b)}');
}

class Box<T> {
  T value;

  Box(this.value);
}

T firstOr<T>(List<T> items, T fallback) {
  if (items.isEmpty) {
    return fallback;
  }
  return items.first;
}

class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}

void part4() {
  print('--- Part 4 ---');

  final intBox = Box<int>(5);
  final stringBox = Box<String>('dart');

  print('Box<int>: ${intBox.value}');
  print('Box<String>: ${stringBox.value}');

  print(firstOr<String>(['Dart in Action', 'Clean Code'], 'none'));

  print(firstOr<String>([], 'z'));

  print(Pair('Dart in Action', 3));
}

class BookNotFoundException implements Exception {
  final String title;

  BookNotFoundException(this.title);
}

class BookNotAvailableException implements Exception {
  final String title;

  BookNotAvailableException(this.title);
}

void checkOut(Map<String, int> stock, String title) {
  if (!stock.containsKey(title)) {
    throw BookNotFoundException(title);
  }

  if (stock[title]! <= 0) {
    throw BookNotAvailableException(title);
  }

  stock[title] = stock[title]! - 1;
}

Map<String, dynamic> findBook(String title) {
  return books.firstWhere((book) => book['title'] == title);
}

void part5() {
  print('--- Part 5 ---');

  final stock = buildStock();

  for (final title in ['Dart in Action', 'Flutter Basics', 'Unknown Book']) {
    try {
      checkOut(stock, title);
      print('Checked out: $title');
    } on BookNotAvailableException catch (e) {
      print('Sorry: "${e.title}" has no copies left');
    } on BookNotFoundException catch (e) {
      print('Not found: "${e.title}"');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      print('Transaction logged.');
    }
  }

  print('Copies left of Dart in Action: ${stock['Dart in Action']}');

  try {
    findBook('Missing');
  } on StateError {
    print('Search failed: no such book');
  }
}

Future<String> fetchBookOfTheDay() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Dart in Action';
}

Future<String> fetchBroken() async {
  await Future.delayed(const Duration(milliseconds: 500));
  throw Exception('Server down');
}

Future<void> part6() async {
  print('--- Part 6 ---');
  print('Fetching...');

  final book = await fetchBookOfTheDay();
  print('Book of the day: $book');

  try {
    await fetchBroken();
  } catch (e) {
    print('Fetch failed: $e');
  }
}

Future<void> main() async {
  part1();
  part2();
  part3();
  part4();
  part5();
  await part6();
}

// Reflection 1: fold can use an initial value and works on an empty collection;
// reduce combines existing elements and requires a non-empty collection.

// Reflection 2: A closure captures variables from its surrounding scope.
// In makeCounter, the closure captures the count variable.

// Reflection 3: The specific exception handler must come before a general
// catch so the expected error can be handled separately.

// Reflection 4: Without await, the function returns a Future instead of its
// completed result, so the program may print the wrong value.
