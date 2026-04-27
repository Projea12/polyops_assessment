class DocumentUploadRequestDto {
  final String type; // PASSPORT | NATIONAL_ID | UTILITY_BILL
  final DocumentMetadataDto metadata;

  const DocumentUploadRequestDto({
    required this.type,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'metadata': metadata.toJson(),
      };
}

class DocumentMetadataDto {
  final String originalName;
  final int size;
  final String checksum;

  const DocumentMetadataDto({
    required this.originalName,
    required this.size,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
        'originalName': originalName,
        'size': size,
        'checksum': checksum,
      };
}
