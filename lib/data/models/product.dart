class ProductModel{
  String? _id;
  String? _name;
  String? _address;
  int? _price;
  String? _img;
  int? _quatity;
  List<String>? _gallery;

  ProductModel(this._id, this._name, this._address, this._price, this._img,
      this._quatity, this._gallery);

  List<String> get gallery => _gallery ?? [];

  int get quatity => _quatity ?? 0;

  String get img => _img ?? "";

  int get price => _price ?? 0;

  String get address => _address ?? "";

  String get name => _name ?? "";

  String get id => _id ?? "";

}