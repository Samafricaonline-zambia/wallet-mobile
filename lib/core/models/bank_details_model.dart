import 'dart:convert';

class BankDetailsModel {
  final String name;
  final String accountNumber;
  final String branchName;
  final String branchCode;
  final String sortCode;
  final String swiftCode;
  final String logo;
  final String description; // New property

  BankDetailsModel({
    required this.name,
    required this.accountNumber,
    required this.branchName,
    required this.branchCode,
    required this.sortCode,
    required this.swiftCode,
    required this.logo,
    required this.description, // Added required
  });

  BankDetailsModel copyWith({
    String? name,
    String? accountNumber,
    String? branchName,
    String? branchCode,
    String? sortCode,
    String? swiftCode,
    String? logo,
    String? description, // Added optional description parameter
  }) {
    return BankDetailsModel(
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      sortCode: sortCode ?? this.sortCode,
      swiftCode: swiftCode ?? this.swiftCode,
      logo: logo ?? this.logo,
      description:
          description ?? this.description, // Added description assignment
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'accountNumber': accountNumber,
      'branchName': branchName,
      'branchCode': branchCode,
      'sortCode': sortCode,
      'swiftCode': swiftCode,
      'logo': logo,
      'description': description, // Added description to map
    };
  }

  factory BankDetailsModel.empty() => BankDetailsModel(
    name: "",
    accountNumber: "",
    branchName: "",
    branchCode: "",
    sortCode: "",
    swiftCode: "",
    logo: "",
    description: "", // Added empty description
  );

  factory BankDetailsModel.fromMap(Map<String, dynamic> map) {
    return BankDetailsModel(
      name: map['name'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      branchName: map['branchName'] ?? '',
      branchCode: map['branchCode'] ?? '',
      sortCode: map['sortCode'] ?? '',
      swiftCode: map['swiftCode'] ?? '',
      logo: map['logo'] ?? '',
      description: map['description'] ?? '', // Added description with fallback
    );
  }

  String toJson() => json.encode(toMap());

  factory BankDetailsModel.fromJson(String source) =>
      BankDetailsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BankDetailsModel(name: $name, accountNumber: $accountNumber, branchName: $branchName, branchCode: $branchCode, sortCode: $sortCode, swiftCode: $swiftCode, logo: $logo, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankDetailsModel &&
        other.name == name &&
        other.accountNumber == accountNumber &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.sortCode == sortCode &&
        other.swiftCode == swiftCode &&
        other.logo == logo &&
        other.description == description; // Added description comparison
  }

  @override
  int get hashCode {
    return name.hashCode ^
        accountNumber.hashCode ^
        branchName.hashCode ^
        branchCode.hashCode ^
        sortCode.hashCode ^
        swiftCode.hashCode ^
        logo.hashCode ^
        description.hashCode; // Added description hash
  }
}
