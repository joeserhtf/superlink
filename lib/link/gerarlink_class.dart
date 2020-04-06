class GeradorLink {
  String type;
  String name;
  String description;
  String price;
  int weight;
  String expirationDate;
  String maxNumberOfInstallments;
  int quantity;
  String sku;
  Shipping shipping;
  String softDescriptor;

  GeradorLink(
      {this.type,
        this.name,
        this.description,
        this.price,
        this.weight,
        this.expirationDate,
        this.maxNumberOfInstallments,
        this.quantity,
        this.sku,
        this.shipping,
        this.softDescriptor});

  GeradorLink.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    weight = json['weight'];
    expirationDate = json['ExpirationDate'];
    maxNumberOfInstallments = json['maxNumberOfInstallments'];
    quantity = json['quantity'];
    sku = json['Sku'];
    shipping = json['shipping'] != null
        ? new Shipping.fromJson(json['shipping'])
        : null;
    softDescriptor = json['SoftDescriptor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['ExpirationDate'] = this.expirationDate;
    data['maxNumberOfInstallments'] = this.maxNumberOfInstallments;
    data['quantity'] = this.quantity;
    data['Sku'] = this.sku;
    if (this.shipping != null) {
      data['shipping'] = this.shipping.toJson();
    }
    data['SoftDescriptor'] = this.softDescriptor;
    return data;
  }
}

class Shipping {
  String type;
  String name;
  String price;

  Shipping({this.type, this.name, this.price});

  Shipping.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}