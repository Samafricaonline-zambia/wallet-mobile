import 'dart:convert';

class DialogOptionModel {
  final String? id;
  final String image;
  final String title;
  final String? subTitle;
  final String description;
  final String badgeText;
  final bool hasAdditionalCharge;

  const DialogOptionModel({
    this.id,
    required this.image,
    required this.title,
    this.subTitle,
    required this.description,
    required this.badgeText,
    this.hasAdditionalCharge = false,
  });

  DialogOptionModel copyWith({
    String? id,
    String? image,
    String? title,
    String? subTitle,
    String? description,
    String? badgeText,
    bool? hasAdditionalCharge,
  }) {
    return DialogOptionModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      description: description ?? this.description,
      badgeText: badgeText ?? this.badgeText,
      hasAdditionalCharge: hasAdditionalCharge ?? this.hasAdditionalCharge,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'subTitle': subTitle,
      'description': description,
      'badgeText': badgeText,
      'hasAdditionalCharge': hasAdditionalCharge,
    };
  }

  factory DialogOptionModel.fromMap(Map<String, dynamic> map) {
    return DialogOptionModel(
      id: map['id'] ?? '',
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      description: map['description'] ?? '',
      badgeText: map['badgeText'] ?? '',
      hasAdditionalCharge: map['hasAdditionalCharge'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DialogOptionModel.fromJson(String source) =>
      DialogOptionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DialogOptionModel(id: $id, image: $image, title: $title, subTitle: $subTitle, description: $description, hasAdditionalCharge: $hasAdditionalCharge, badgeText: $badgeText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DialogOptionModel &&
        other.id == id &&
        other.image == image &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.description == description &&
        other.badgeText == badgeText &&
        other.hasAdditionalCharge == hasAdditionalCharge;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        subTitle.hashCode ^
        description.hashCode ^
        badgeText.hashCode ^
        hasAdditionalCharge.hashCode;
  }
}
