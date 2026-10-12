# OOP Lab — Answers

**Name:** Rafia Naeem  
**Roll Number:** 04072313032

### Q1. What can a subclass using extends use for free that a class using implements has to write itself?

A subclass using `extends` can reuse the parent class's existing methods, fields, and implementation without writing them again. A class using `implements` has to provide its own implementation of the interface's required members.

### Q2. Book and Dvd both use Renewable. When would you pick a mixin, and when an abstract parent class?

I would use a mixin when I want to share reusable behaviour, such as renewal functionality, between classes without making them inherit from the same parent. I would use an abstract parent class when related classes share common properties and behaviour, such as the title and publication year of library items.

### Q3. Why must you override hashCode whenever you override ==?

When two objects are equal according to `==`, they must have the same `hashCode` so that collections such as `Set` and `Map` handle them correctly. If equal objects have different hash codes, these collections may treat them as separate objects.

### Q4. An extension method on String and a subclass of String both add behaviour. Why does Dart let you write the first one but not the second?

Dart allows extension methods to add functionality to `String` without changing its original class. However, `String` is a built-in final type in Dart, so it cannot be extended through subclassing.