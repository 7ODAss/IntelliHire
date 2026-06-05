class GetInitials {
  static String getInitials(String name) {
    String cleanName = name.trim();
    if (cleanName.isEmpty) return 'TT';
    List<String> names = cleanName.split(RegExp(r'\s+'));

    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else {
      String singleWord = names[0];
      return singleWord.length >= 2
          ? singleWord.substring(0, 2).toUpperCase()
          : singleWord.toUpperCase();
    }
  }
}