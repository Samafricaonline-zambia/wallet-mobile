import 'dart:convert';
import 'package:flutter/widgets.dart';

class EcommerceModel {
  final String? image;
  final String? link;
  final String? title;

  EcommerceModel({this.image, this.link, this.title});

  EcommerceModel copyWith({
    ValueGetter<String?>? image,
    ValueGetter<String?>? link,
    ValueGetter<String?>? title,
  }) {
    return EcommerceModel(
      image: image != null ? image() : this.image,
      link: link != null ? link() : this.link,
      title: title != null ? title() : this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {'image': image, 'link': link, 'title': title};
  }

  factory EcommerceModel.fromMap(Map<String, dynamic> map) {
    return EcommerceModel(
      image: map['image'],
      link: map['link'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EcommerceModel.fromJson(String source) =>
      EcommerceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'EcommerceModel(image: $image, link: $link, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EcommerceModel &&
        other.image == image &&
        other.link == link &&
        other.title == title;
  }

  @override
  int get hashCode => image.hashCode ^ link.hashCode ^ title.hashCode;
}
