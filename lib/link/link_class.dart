class Link {
  String id;
  String type;
  String name;
  String description;
  bool showDescription;
  int price;
  int weight;
  Shipping shipping;
  String sku;
  String softDescriptor;
  String expirationDate;
  String createdDate;
  int maxNumberOfInstallments;
  int quantity;
  String shortUrl;
  List<Links> links;

  Link(
      {this.id,
        this.type,
        this.name,
        this.description,
        this.showDescription,
        this.price,
        this.weight,
        this.shipping,
        this.sku,
        this.softDescriptor,
        this.expirationDate,
        this.createdDate,
        this.maxNumberOfInstallments,
        this.quantity,
        this.shortUrl,
        this.links});

  Link.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    description = json['description'];
    showDescription = json['showDescription'];
    price = json['price'];
    weight = json['weight'];
    shipping = json['shipping'] != null
        ? new Shipping.fromJson(json['shipping'])
        : null;
    sku = json['sku'];
    softDescriptor = json['softDescriptor'];
    expirationDate = json['expirationDate'];
    createdDate = json['createdDate'];
    maxNumberOfInstallments = json['maxNumberOfInstallments'];
    quantity = json['quantity'];
    shortUrl = json['shortUrl'];
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['description'] = this.description;
    data['showDescription'] = this.showDescription;
    data['price'] = this.price;
    data['weight'] = this.weight;
    if (this.shipping != null) {
      data['shipping'] = this.shipping.toJson();
    }
    data['sku'] = this.sku;
    data['softDescriptor'] = this.softDescriptor;
    data['expirationDate'] = this.expirationDate;
    data['createdDate'] = this.createdDate;
    data['maxNumberOfInstallments'] = this.maxNumberOfInstallments;
    data['quantity'] = this.quantity;
    data['shortUrl'] = this.shortUrl;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shipping {
  String type;

  Shipping({this.type});

  Shipping.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }
}

class Links {
  String method;
  String rel;
  String href;

  Links({this.method, this.rel, this.href});

  Links.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    rel = json['rel'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['rel'] = this.rel;
    data['href'] = this.href;
    return data;
  }
}