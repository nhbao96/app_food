class ProductDTO {
  String? id;
  String? name;
  String? address;
  int? price;
  String? img;
  int? quantity;
  List<String>? gallery;
  String? dateCreated;
  String? dateUpdated;

  ProductDTO(
      {this.id,
        this.name,
        this.address,
        this.price,
        this.img,
        this.quantity,
        this.gallery,
        this.dateCreated,
        this.dateUpdated});

  ProductDTO.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    gallery = json['gallery'].cast<String>();
    dateCreated = json['date_created'];
    dateUpdated = json['date_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['price'] = this.price;
    data['img'] = this.img;
    data['quantity'] = this.quantity;
    data['gallery'] = this.gallery;
    data['date_created'] = this.dateCreated;
    data['date_updated'] = this.dateUpdated;
    return data;
  }

  static ProductDTO parser(Map<String,dynamic> json){
    return ProductDTO.fromJson(json);
  }

  static List<ProductDTO> parserListProducts(List<dynamic> json){
    return (json as List).map((e) => ProductDTO.fromJson(e)).toList();
  }
}