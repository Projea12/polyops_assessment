enum DocumentType {
  passport,
  nationalId,
  utilityBill;

  String get apiValue => switch (this) {
        DocumentType.passport => 'PASSPORT',
        DocumentType.nationalId => 'NATIONAL_ID',
        DocumentType.utilityBill => 'UTILITY_BILL',
      };

  String get label => switch (this) {
        DocumentType.passport => 'Passport',
        DocumentType.nationalId => 'National ID',
        DocumentType.utilityBill => 'Utility Bill',
      };

  static DocumentType fromApi(String value) => switch (value) {
        'PASSPORT' => DocumentType.passport,
        'NATIONAL_ID' => DocumentType.nationalId,
        'UTILITY_BILL' => DocumentType.utilityBill,
        _ => DocumentType.nationalId,
      };
}
