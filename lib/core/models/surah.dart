class Surah {
  final int number;
  final String englishName;
  final String name; // Arabic
  final String revelationType;
  final int ayahCount;

  Surah({
    required this.number,
    required this.englishName,
    required this.name,
    required this.revelationType,
    required this.ayahCount,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      englishName: json['englishName'] as String,
      name: json['name'] as String,
      revelationType: json['revelationType'] as String,
      ayahCount: json['numberOfAyahs'] as int,
    );
  }
}
