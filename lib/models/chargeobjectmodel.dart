class Charge_object {
  String email;
  String amount;
  Metadata metadata;
  CardObject card;
//  String pin;

//  Charge_object({this.email, this.amount, this.metadata, this.card, this.pin});
  Charge_object({this.email, this.amount, this.metadata, this.card});

  Charge_object.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    amount = json['amount'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    card = json['card'] != null ? new CardObject.fromJson(json['card']) : null;
//    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['amount'] = this.amount;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
//    data['pin'] = this.pin;
    return data;
  }
}

class Metadata {
  List<CustomFields> customFields;

  Metadata({this.customFields});

  Metadata.fromJson(Map<String, dynamic> json) {
    if (json['custom_fields'] != null) {
      customFields = new List<CustomFields>();
      json['custom_fields'].forEach((v) {
        customFields.add(new CustomFields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customFields != null) {
      data['custom_fields'] = this.customFields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomFields {
  String value;
  String displayName;
  String variableName;

  CustomFields({this.value, this.displayName, this.variableName});

  CustomFields.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    displayName = json['display_name'];
    variableName = json['variable_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['display_name'] = this.displayName;
    data['variable_name'] = this.variableName;
    return data;
  }
}

class CardObject {
  String cvv;
  String number;
  String expiryMonth;
  String expiryYear;

  CardObject({this.cvv, this.number, this.expiryMonth, this.expiryYear});

  CardObject.fromJson(Map<String, dynamic> json) {
    cvv = json['cvv'];
    number = json['number'];
    expiryMonth = json['expiry_month'];
    expiryYear = json['expiry_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cvv'] = this.cvv;
    data['number'] = this.number;
    data['expiry_month'] = this.expiryMonth;
    data['expiry_year'] = this.expiryYear;
    return data;
  }
}
