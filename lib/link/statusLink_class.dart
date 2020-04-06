class statusLink {
  String id;
  String productId;
  String createdDate;
  List<Orders> orders;

  statusLink({this.id, this.productId, this.createdDate, this.orders});

  statusLink.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    productId = json['productId'];
    createdDate = json['createdDate'];
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['productId'] = this.productId;
    data['createdDate'] = this.createdDate;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String id;
  String orderNumber;
  String createdDate;
  Payment payment;
  List<Links> links;

  Orders(
      {this.id, this.orderNumber, this.createdDate, this.payment, this.links});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    orderNumber = json['orderNumber'];
    createdDate = json['createdDate'];
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['createdDate'] = this.createdDate;
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  String id;
  int price;
  int numberOfPayments;
  String createdDate;
  String status;

  Payment(
      {this.id,
        this.price,
        this.numberOfPayments,
        this.createdDate,
        this.status});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    price = json['price'];
    numberOfPayments = json['numberOfPayments'];
    createdDate = json['createdDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['price'] = this.price;
    data['numberOfPayments'] = this.numberOfPayments;
    data['createdDate'] = this.createdDate;
    data['status'] = this.status;
    return data;
  }
}

class Links {
  String id;
  String method;
  String rel;
  String href;

  Links({this.id, this.method, this.rel, this.href});

  Links.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    method = json['method'];
    rel = json['rel'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['method'] = this.method;
    data['rel'] = this.rel;
    data['href'] = this.href;
    return data;
  }
}
