import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IconItemModel {
  final IconData? icon;
  final String? image;
  final String? label;
  final String? route;

  IconItemModel({this.icon, this.image, this.label, this.route});

  IconItemModel copyWith({
    ValueGetter<IconData?>? icon,
    ValueGetter<String?>? image,
    ValueGetter<String?>? label,
    ValueGetter<String?>? route,
  }) {
    return IconItemModel(
      icon: icon != null ? icon() : this.icon,
      image: image != null ? image() : this.image,
      label: label != null ? label() : this.label,
      route: route != null ? route() : this.route,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'icon': icon?.codePoint,
      'image': image,
      'label': label,
      'route': route,
    };
  }

  factory IconItemModel.fromMap(Map<String, dynamic> map) {
    return IconItemModel(
      icon: map['icon'] != null
          ? IconData(map['icon'], fontFamily: 'MaterialIcons')
          : null,
      image: map['image'],
      label: map['label'],
      route: map['route'],
    );
  }

  String toJson() => json.encode(toMap());

  factory IconItemModel.fromJson(String source) =>
      IconItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IconItemModel(icon: $icon, image: $image, label: $label, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IconItemModel &&
        other.icon == icon &&
        other.image == image &&
        other.label == label &&
        other.route == route;
  }

  @override
  int get hashCode {
    return icon.hashCode ^ image.hashCode ^ label.hashCode ^ route.hashCode;
  }
}
