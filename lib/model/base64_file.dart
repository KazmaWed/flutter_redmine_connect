class Base64File {
  Base64File({
    required this.fileName,
    required this.fileInBase64,
  });
  String fileName;
  String fileInBase64;

  @override
  String toString() {
    return '{fileName: $fileName, fileInBase64: $fileInBase64,}';
  }

  Map<String, String> toMap() {
    return {
      'fileName': fileName,
      'fileInBase64': fileInBase64,
    };
  }
}
