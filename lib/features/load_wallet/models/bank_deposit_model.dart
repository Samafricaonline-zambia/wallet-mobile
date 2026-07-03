import 'dart:io';

import 'package:http/http.dart' as http;

class BankDepositModel {
  final double depositamount;
  final String depositbank;
  final String bankref;
  final String depositdate;
  final File? depositfile;

  BankDepositModel({
    required this.depositamount,
    required this.depositbank,
    required this.bankref,
    required this.depositdate,
    required this.depositfile,
  });

  factory BankDepositModel.empty() => BankDepositModel(
    depositamount: 0.0,
    depositbank: "",
    bankref: "",
    depositdate: "",
    depositfile: null,
  );

  BankDepositModel copyWith({
    double? depositamount,
    String? depositbank,
    String? bankref,
    String? depositdate,
    File? depositfile,
  }) {
    return BankDepositModel(
      depositamount: depositamount ?? this.depositamount,
      depositbank: depositbank ?? this.depositbank,
      bankref: bankref ?? this.bankref,
      depositdate: depositdate ?? this.depositdate,
      depositfile: depositfile ?? this.depositfile,
    );
  }

  Map<String, String> toMap() {
    return {
      'depositamount': depositamount.toStringAsFixed(2),
      'depositbank': depositbank,
      'bankref': bankref,
      'depositdate': depositdate,
    };
  }

  Future<http.MultipartFile> toMultipartFile() async {
    return http.MultipartFile.fromPath(
      'depositfile',
      depositfile!.path,
      contentType: http.MediaType(
        'application',
        'octet-stream',
      ), // Adjust content type as needed
    );
  }

  Future<http.MultipartRequest> toFormDataRequest(Uri url) async {
    final request = http.MultipartRequest('POST', url);

    // Add regular fields
    request.fields.addAll({
      'depositamount': depositamount.toString(),
      'depositbank': depositbank,
      'bankref': bankref,
      'depositdate': depositdate,
    });

    // Add file if it exists
    if (depositfile != null && await depositfile!.exists()) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'depositfile',
          depositfile!.path,
          contentType: http.MediaType(
            'application',
            'octet-stream',
          ), // Adjust content type as needed
        ),
      );
    }

    return request;
  }
}
