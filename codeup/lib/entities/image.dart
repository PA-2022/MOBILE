class Image {
  final int id;
  final int imageUrl;
  final bool imageName;

  const Image(this.id, this.imageUrl, this.imageName);

factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      json['id'],
      json['imageUrl'],
      json['imageName']
    );
  }
 @override
  String toString() {
    return "{id: $id, title: $imageUrl, content: $imageName}";
  }
}