class Product {
  String id = "";
  String name = "";
  String address = "";
  int price = 0;
  String img = "";
  int quantity = 0;
  List<String> gallery = [];
  String dateCreated = "";
  String dateUpdated = "";

  Product(
      String? id,
      String? name,
      String? address,
      int? price,
      String? img,
      int? quantity,
      List<String>? gallery,
      String? dateCreated,
      String? dateUpdated) {
    this.id = id ?? "";
    this.name = name ?? "";
    this.address = address ?? "";
    this.price = price ?? 0;
    this.img = img ?? "";
    this.quantity = quantity ?? 0;
    this.gallery = gallery ?? [];
    this.dateCreated = dateCreated ?? "";
    this.dateUpdated = dateUpdated ?? "";
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, address: $address, price: $price, img: $img, quantity: $quantity, gallery: $gallery, dateCreated: $dateCreated, dateUpdated: $dateUpdated}';
  }
}
