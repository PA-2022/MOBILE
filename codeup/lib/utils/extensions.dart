extension NullEmptyStringCheck on String? {
  bool isNullOrEmpty() {
    return this == null || (this != null && this!.isEmpty);
  }

  bool isEmptyNonNull() {
    return this != null && this!.isEmpty;
  }
}