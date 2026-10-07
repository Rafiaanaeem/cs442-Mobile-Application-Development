# CS 442 Week 1 – Enhanced Counter App

**Name:** Rafia Naeem  
**Roll Number:** 04072313032

## Running App

![Running App](Lab-Task1/Screenshot%202026-09-11%20152151.png)

## What I Learned About `setState()`

When I press the **+** or **Reset** button, the value of the counter changes, but Flutter needs to be told that it should show that change on the screen. That is what `setState()` does—it lets Flutter know that the data has changed and the related widgets should be rebuilt with the new value. Without `setState()`, the value might change in the code, but the screen would continue showing the old value because Flutter was not notified about the change.


# Course Roster Console App — Lab 2

## Overview

This project is a console-based **Course Roster Manager** developed in Dart as part of Lab 2 for the Mobile Application Development course.

The lab focuses on the fundamental concepts of Dart, including syntax, data types, null safety, operators, control flow, loops, and collection literals.

The application manages basic course information, enrolled students, waitlisted students, attendance records, and enrollment status.

## Learning Objectives Covered

The following Dart concepts were implemented in the project:

- Dart functions and `main()`
- `const`, `final`, and typed variables
- `String`, `int`, `double`, and `bool`
- `List`, `Set`, and `Map`
- Null safety
- `?`, `??`, `?.`, `late`, and `??=`
- String interpolation and string methods
- Integer division `~/`
- Remainder operator `%`
- Type checking with `is` and `is!`
- Cascade notation `..`
- Null-aware cascade `?..`
- `if/else`
- `switch`
- Ternary operator `?:`
- `for-in`
- `forEach`
- Collection `if`
- Collection `for`

## Parts Completed

### Part 1 — Setup & Welcome

Implemented:

- `main()`
- `printWelcome(String appName)` helper function
- Documentation comment using `///`
- Welcome banner

Example output:

```text
=== Course Roster Manager ===
```

### Part 2 — Course & Roster Data

Implemented:

- `const` for maximum course capacity
- `final` for runtime creation date
- Explicitly typed variables
- `List<String>` for enrolled students
- `Set<String>` for the waitlist
- `Map<String, int>` for attendance records

Example:

```dart
const int maxCapacity = 4;
final DateTime createdAt = DateTime.now();

String courseTitle = 'CS201: Mobile App Development';
int capacity = maxCapacity;
double creditHours = 3.0;
bool isOpen = true;
```

### Part 3 — Null-Safe Instructor Information

Implemented:

- Nullable `String?`
- Null fallback using `??`
- `late` variable
- Safe null-aware access using `?.`

The instructor email is left null and safely displayed as `TBA`.

### Part 4 — Formatting Strings

Implemented:

- `split(',')`
- `trim()`
- `for-in`
- Multi-line strings using triple quotes
- String interpolation with expressions

The application also calculates and displays the number of remaining seats.

### Part 5 — Operators in Action

Implemented:

- `~/` for integer division
- `%` for remainder
- `is` for type checking
- `is!` for negative type checking
- Cascade notation `..`
- Null-aware cascade `?..`
- Null-coalescing assignment `??=`

The program creates a formatted course report using `StringBuffer`.

### Part 6 — Enrollment Logic

Implemented:

- `if/else` for enrollment eligibility
- `switch` with `200`, `404`, and `default` cases
- `break` statements
- Ternary operator for the course status tag

### Part 7 — Reports & Loops

Implemented:

- `for-in` loop for displaying the roster
- `forEach` for displaying attendance
- Collection literal with embedded `if`
- Collection literal with embedded `for`
- Announcement generation and display

## Sample Output

```text
=== Course Roster Manager ===
CS201: Mobile App Development | Capacity: 4 | Enrolled: 3
Created at: 2026-10-07 09:13:29.525757
TBA
Enrollment code: CS101
Instructor email length: 0
Clean names: [Aiden, maria, JAMAL, Priya]
Course: CS201: Mobile App Development
Credit Hours: 3.0
Capacity: 4 students

Seats left: 1
Full groups of 3: 1, leftover: 0
This is text!
This input is not an integer.
Report: CS201: Mobile App Development | Cap: 4 | Roster: 3
Extra notes: null
Bonus seats: 0
You're in! Welcome aboard.
Enrolled
OPEN
Aiden
Maria
Jamal
Aiden: 3
Maria: 4
Jamal: 2
Welcome to CS201: Mobile App Development
Reminder: Priya, please confirm attendance
Reminder: Noah, please confirm attendance
```

## Tools Used

- **Dart**
-