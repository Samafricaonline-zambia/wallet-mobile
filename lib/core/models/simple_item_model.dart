import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleItemModel {
  final String title;
  final String? subTitle;
  final String? description;
  final IconData? icon;
  final String? image;

  SimpleItemModel({
    required this.title,
    this.subTitle,
    this.description,
    this.icon,
    this.image,
  });

  SimpleItemModel copyWith({
    String? title,
    ValueGetter<String?>? subTitle,
    ValueGetter<String?>? description,
    ValueGetter<IconData?>? icon,
    ValueGetter<String?>? image,
  }) {
    return SimpleItemModel(
      title: title ?? this.title,
      subTitle: subTitle != null ? subTitle() : this.subTitle,
      description: description != null ? description() : this.description,
      icon: icon != null ? icon() : this.icon,
      image: image != null ? image() : this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subTitle': subTitle,
      'description': description,
      'icon': icon?.codePoint,
      'image': image,
    };
  }

  factory SimpleItemModel.fromMap(Map<String, dynamic> map) {
    return SimpleItemModel(
      title: map['title'] ?? '',
      subTitle: map['subTitle'],
      description: map['description'],
      icon: map['icon'] != null
          ? IconData(map['icon'], fontFamily: 'MaterialIcons')
          : null,
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleItemModel.fromJson(String source) =>
      SimpleItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SimpleItemModel(title: $title, subTitle: $subTitle, description: $description, icon: $icon, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimpleItemModel &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.description == description &&
        other.icon == icon &&
        other.image == image;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subTitle.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        image.hashCode;
  }
}
