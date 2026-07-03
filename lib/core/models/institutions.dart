import 'dart:convert';

import 'package:flutter/foundation.dart';

class InstitutionsModel {
  final bool status;
  final int count;
  final List<InstitutionModel> data;
  InstitutionsModel({
    required this.status,
    required this.count,
    required this.data,
  });

  factory InstitutionsModel.empty() =>
      InstitutionsModel(status: false, count: 0, data: []);

  InstitutionsModel copyWith({
    bool? status,
    int? count,
    List<InstitutionModel>? data,
  }) {
    return InstitutionsModel(
      status: status ?? this.status,
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'count': count,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory InstitutionsModel.fromMap(Map<String, dynamic> map) {
    return InstitutionsModel(
      status: map['status'] ?? false,
      count: map['count']?.toInt() ?? 0,
      data: List<InstitutionModel>.from(
        map['data']?.map((x) => InstitutionModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory InstitutionsModel.fromJson(String source) =>
      InstitutionsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'InstitutionsModel(status: $status, count: $count, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InstitutionsModel &&
        other.status == status &&
        other.count == count &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ count.hashCode ^ data.hashCode;
}

class InstitutionModel {
  final int id;
  final String nfsId;
  final String participantName;
  final String institutionType;
  final String switchChannel;
  final String environment;
  final int isActive;
  final dynamic createdBy;
  final dynamic updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String logo;

  InstitutionModel({
    required this.id,
    required this.nfsId,
    required this.participantName,
    required this.institutionType,
    required this.switchChannel,
    required this.environment,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.logo,
  });

  factory InstitutionModel.empty() {
    return InstitutionModel(
      id: -1,
      nfsId: "",
      participantName: "",
      institutionType: "",
      switchChannel: "",
      environment: "",
      isActive: 0,
      createdBy: "",
      updatedBy: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      logo: "",
    );
  }

  InstitutionModel copyWith({
    int? id,
    String? nfsId,
    String? participantName,
    String? institutionType,
    String? switchChannel,
    String? environment,
    int? isActive,
    dynamic createdBy,
    dynamic updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? logo,
  }) {
    return InstitutionModel(
      id: id ?? this.id,
      nfsId: nfsId ?? this.nfsId,
      participantName: participantName ?? this.participantName,
      institutionType: institutionType ?? this.institutionType,
      switchChannel: switchChannel ?? this.switchChannel,
      environment: environment ?? this.environment,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      logo: logo ?? this.logo,
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nfs_id': nfsId,
      'participant_name': participantName,
      'institution_type': institutionType,
      'switch_channel': switchChannel,
      'environment': environment,
      'is_active': isActive,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'logo': logo,
    };
  }

  // fromMap method
  factory InstitutionModel.fromMap(Map<String, dynamic> map) {
    return InstitutionModel(
      id: map['id']?.toInt() ?? -1,
      nfsId: map['nfs_id'] ?? '',
      participantName: map['participant_name'] ?? '',
      institutionType: map['institution_type'] ?? '',
      switchChannel: map['switch_channel'] ?? '',
      environment: map['environment'] ?? '',
      isActive: map['is_active']?.toInt() ?? 0,
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
      logo: map['logo'] ?? '',
    );
  }

  // toJson method (returns JSON string)
  String toJson() => json.encode(toMap());

  // fromJson method (from JSON string)
  factory InstitutionModel.fromJson(String source) =>
      InstitutionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InstitutionModel('
        'id: $id, '
        'nfsId: $nfsId, '
        'participantName: $participantName, '
        'institutionType: $institutionType, '
        'switchChannel: $switchChannel, '
        'environment: $environment, '
        'isActive: $isActive, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'logo: $logo'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InstitutionModel &&
        other.id == id &&
        other.nfsId == nfsId &&
        other.participantName == participantName &&
        other.institutionType == institutionType &&
        other.switchChannel == switchChannel &&
        other.environment == environment &&
        other.isActive == isActive &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nfsId.hashCode ^
        participantName.hashCode ^
        institutionType.hashCode ^
        switchChannel.hashCode ^
        environment.hashCode ^
        isActive.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        logo.hashCode;
  }
}
