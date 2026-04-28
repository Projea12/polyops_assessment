class SelectedFile {
  final String path;
  final String name;
  final int size;

  const SelectedFile({
    required this.path,
    required this.name,
    required this.size,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedFile &&
          other.path == path &&
          other.name == name &&
          other.size == size;

  @override
  int get hashCode => Object.hash(path, name, size);

  @override
  String toString() => 'SelectedFile(name: $name, size: $size)';
}
