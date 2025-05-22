// Model de donnée dans Hive
class CryptoDetail {
  final String id;
  final String name;
  final String description;
  final String homepageUrl;

  CryptoDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.homepageUrl,
  });

  factory CryptoDetail.fromJson(Map<String, dynamic> json) {
    return CryptoDetail(
      id: json['id'],
      name: json['name'],
      description: json['description']['en'] ?? '',
      homepageUrl: (json['links']['homepage'] as List).first ?? '',
    );
  }
}
