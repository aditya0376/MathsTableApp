import 'package:flutter/material.dart';

/// A cartoon character that comments on the user's results.
class CartoonCharacter {
  final String name;
  final IconData icon;
  final Color color;

  const CartoonCharacter({
    required this.name,
    required this.icon,
    required this.color,
  });

  /// Returns a comment appropriate for the given score.
  String commentFor(int score) {
    if (score >= 200) return 'Mind blowing! You are a maths superstar!';
    if (score >= 150) return 'Genius! I am so proud of you!';
    if (score >= 100) return 'Superb! Keep up the amazing work!';
    if (score >= 50) return 'Wow! You are doing great!';
    if (score >= 20) return 'Good job! You are getting better!';
    return 'Keep practicing! You can do it!';
  }
}

/// A collection of friendly cartoon characters.
const List<CartoonCharacter> cartoonCharacters = [
  CartoonCharacter(
    name: 'Sunny the Lion',
    icon: Icons.emoji_nature,
    color: Color(0xFFFFB300),
  ),
  CartoonCharacter(
    name: 'Bubbles the Bear',
    icon: Icons.emoji_emotions,
    color: Color(0xFF8D6E63),
  ),
  CartoonCharacter(
    name: 'Zippy the Zebra',
    icon: Icons.emoji_people,
    color: Color(0xFF5C6BC0),
  ),
  CartoonCharacter(
    name: 'Momo the Monkey',
    icon: Icons.emoji_food_beverage,
    color: Color(0xFF66BB6A),
  ),
  CartoonCharacter(
    name: 'Daisy the Dolphin',
    icon: Icons.emoji_transportation,
    color: Color(0xFF29B6F6),
  ),
];