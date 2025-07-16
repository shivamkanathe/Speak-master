class VerbEntity {
  String? v2;
  String? hindi;
  String? v2Past;
  String? v3Past;
  String? v4IngForm;

  VerbEntity({this.v2, this.hindi, this.v2Past, this.v3Past, this.v4IngForm});

  VerbEntity.fromJson(Map<String, dynamic> json) {
    v2 = json['v2'];
    hindi = json['hindi'];
    v2Past = json['v2_past'];
    v3Past = json['v3_past'];
    v4IngForm = json['v4_ing_form'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v2'] = this.v2;
    data['hindi'] = this.hindi;
    data['v2_past'] = this.v2Past;
    data['v3_past'] = this.v3Past;
    data['v4_ing_form'] = this.v4IngForm;
    return data;
  }
}
