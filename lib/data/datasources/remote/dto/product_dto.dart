class ProductDTO{
  String? sId;
  String? name;
  String? address;
  int? price;
  String? img;
  int? quantity;
  List<String>? gallery;
  String? dateCreated;

  ProductDTO(
      {this.sId,
        this.name,
        this.address,
        this.price,
        this.img,
        this.quantity,
        this.gallery,
        this.dateCreated});

  ProductDTO.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    gallery = json['gallery'].cast<String>();
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['price'] = this.price;
    data['img'] = this.img;
    data['quantity'] = this.quantity;
    data['gallery'] = this.gallery;
    data['date_created'] = this.dateCreated;
    return data;
  }

  @override
  String toString() {
    return 'ProductDTO{sId: $sId, name: $name, address: $address, price: $price, img: $img, quantity: $quantity, gallery: $gallery, dateCreated: $dateCreated}';
  }

  static List<ProductDTO> parser(List<dynamic> json) {
    return (json as List).map((e) => ProductDTO.fromJson(e)).toList();
  }
}