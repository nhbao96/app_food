class AppResource<T>{
  String? message;
  T? data;
  AppResource({this.message, this.data});

  AppResource.fromJson(Map<String, dynamic> json, Function parserModel){
    message = json["message"];
    data = parserModel(json["data"]);
  }
}