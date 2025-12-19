/// Helper class to manage mascot images for glossary cards
class GlossaryMascots {
  // List of all available mascot images
  static const List<String> mascots = [
    'assets/images/Gemini_Generated_Image_a4qyzja4qyzja4qy-removebg-preview.png',
    'assets/images/Gemini_Generated_Image_cx29n4cx29n4cx29-removebg-preview(1).png',
    'assets/images/Gemini_Generated_Image_jcxhyxjcxhyxjcxh-removebg-preview(1).png',
    'assets/images/Gemini_Generated_Image_jg9xj5jg9xj5jg9x-removebg-preview.png',
    'assets/images/Gemini_Generated_Image_lrvc3wlrvc3wlrvc-removebg-preview.png',
    'assets/images/Gemini_Generated_Image_qq2rz6qq2rz6qq2r-removebg-preview-removebg-preview.png',
    'assets/images/Gemini_Generated_Image_y9mmi0y9mmi0y9mm-removebg-preview.png',
    'assets/images/Mascota1-removebg-preview.png',
    'assets/images/Mascota2-removebg-preview.png',
  ];

  /// Get mascot configuration for a card (always 1 mascot)
  /// Returns a list with 1 mascot config (path + position)
  static List<Map<String, dynamic>> getMascotsForCard(int index) {
    // Get mascot index
    final mascotIndex = index % mascots.length;

    // Single mascot positions (varied corners)
    final positions = [
      {'top': 5.0, 'right': 5.0, 'rotation': 0.15},
      {'bottom': 5.0, 'left': 5.0, 'rotation': -0.12},
      {'top': 5.0, 'left': 5.0, 'rotation': -0.15},
      {'bottom': 5.0, 'right': 5.0, 'rotation': 0.12},
    ];

    final position = positions[index % positions.length];

    return [
      {'path': mascots[mascotIndex], 'position': position},
    ];
  }
}
