import 'package:flutter/material.dart';

import '../widgets/cartoon_character_view.dart';

/// A cartoon character that comments on the user's results.
class CartoonCharacter {
  final String name;
  final CartoonType type;
  final Color color;

  const CartoonCharacter({
    required this.name,
    required this.type,
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

/// A collection of friendly original cartoon characters.
const List<CartoonCharacter> cartoonCharacters = [
  CartoonCharacter(
    name: 'Robo the Robot',
    type: CartoonType.robot,
    color: Color(0xFF42A5F5),
  ),
  CartoonCharacter(
    name: 'Sunny the Sun',
    type: CartoonType.sun,
    color: Color(0xFFFFB300),
  ),
  CartoonCharacter(
    name: 'Whiskers the Cat',
    type: CartoonType.cat,
    color: Color(0xFF8D6E63),
  ),
  CartoonCharacter(
    name: 'Stella the Star',
    type: CartoonType.star,
    color: Color(0xFFFFD54F),
  ),
  CartoonCharacter(
    name: 'Rocket the Racer',
    type: CartoonType.rocket,
    color: Color(0xFF66BB6A),
  ),
  CartoonCharacter(
    name: 'Hooty the Owl',
    type: CartoonType.owl,
    color: Color(0xFF7E57C2),
  ),
];