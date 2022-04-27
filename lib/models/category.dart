class Category {
  int categoryId;
  String categoryName;
  String categoryDesc;
  int parent;

  Image image;

  Category(
      {this.categoryId,
      this.categoryName,
      this.categoryDesc,
      this.image,
      this.parent});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['name'];
    categoryDesc = json['description'];
    parent = json['parent'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    if (image == null) {
      image = Image.fromJson(json);
    }
  }
}

class Image {
  String url;

  Image({
    this.url,
  });

  Image.fromJson(Map<String, dynamic> json) {
    url = json['src'];
  }
}
