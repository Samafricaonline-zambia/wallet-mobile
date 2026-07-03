import 'dart:convert';

class FavouriteItemModel {
  final String? accountNumber;
  final String? tag;
  final String? category;
  FavouriteItemModel({this.accountNumber, this.tag, this.category});

  FavouriteItemModel copyWith({
    String? accountNumber,
    String? tag,
    String? category,
  }) {
    return FavouriteItemModel(
      accountNumber: accountNumber ?? this.accountNumber,
      tag: tag ?? this.tag,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {'accountNumber': accountNumber, 'tag': tag, 'category': category};
  }

  factory FavouriteItemModel.fromMap(Map<String, dynamic> map) {
    return FavouriteItemModel(
      accountNumber: map['accountNumber'],
      tag: map['tag'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteItemModel.fromJson(String source) =>
      FavouriteItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FavouriteItemModel(accountNumber: $accountNumber, tag: $tag, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavouriteItemModel &&
        other.accountNumber == accountNumber &&
        other.tag == tag &&
        other.category == category;
  }

  @override
  int get hashCode => accountNumber.hashCode ^ tag.hashCode ^ category.hashCode;
}
