class successresponse {
  bool status;
  String message;
  Data data;

  successresponse({this.status, this.message, this.data});

  successresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String domain;
  String status;
  String reference;
  int amount;
  Null message;
  String gatewayResponse;
  String paidAt;
  String createdAt;
  String channel;
  String currency;
  String ipAddress;
  Metadata metadata;
  Null log;
  int fees;
  Null feesSplit;
  Authorization authorization;
  Customer customer;
  Null plan;
  Null orderId;
  String paidAt2;
  String createdAt2;
  int requestedAmount;
  String transactionDate;
  PlanObject planObject;
  PlanObject subaccount;

  Data(
      {this.id,
      this.domain,
      this.status,
      this.reference,
      this.amount,
      this.message,
      this.gatewayResponse,
      this.paidAt,
      this.createdAt,
      this.channel,
      this.currency,
      this.ipAddress,
      this.metadata,
      this.log,
      this.fees,
      this.feesSplit,
      this.authorization,
      this.customer,
      this.plan,
      this.orderId,
      this.paidAt2,
      this.createdAt2,
      this.requestedAmount,
      this.transactionDate,
      this.planObject,
      this.subaccount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    domain = json['domain'];
    status = json['status'];
    reference = json['reference'];
    amount = json['amount'];
    message = json['message'];
    gatewayResponse = json['gateway_response'];
    paidAt = json['paid_at'];
    createdAt = json['created_at'];
    channel = json['channel'];
    currency = json['currency'];
    ipAddress = json['ip_address'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    log = json['log'];
    fees = json['fees'];
    feesSplit = json['fees_split'];
    authorization = json['authorization'] != null
        ? new Authorization.fromJson(json['authorization'])
        : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    plan = json['plan'];
    orderId = json['order_id'];
    paidAt2 = json['paidAt2'];
    createdAt2 = json['createdAt2'];
    requestedAmount = json['requested_amount'];
    transactionDate = json['transaction_date'];
    planObject = json['plan_object'] != null
        ? new PlanObject.fromJson(json['plan_object'])
        : null;
    subaccount = json['subaccount'] != null
        ? new PlanObject.fromJson(json['subaccount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['domain'] = this.domain;
    data['status'] = this.status;
    data['reference'] = this.reference;
    data['amount'] = this.amount;
    data['message'] = this.message;
    data['gateway_response'] = this.gatewayResponse;
    data['paid_at'] = this.paidAt;
    data['created_at'] = this.createdAt;
    data['channel'] = this.channel;
    data['currency'] = this.currency;
    data['ip_address'] = this.ipAddress;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['log'] = this.log;
    data['fees'] = this.fees;
    data['fees_split'] = this.feesSplit;
    if (this.authorization != null) {
      data['authorization'] = this.authorization.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['plan'] = this.plan;
    data['order_id'] = this.orderId;
    data['paidAt2'] = this.paidAt2;
    data['createdAt2'] = this.createdAt2;
    data['requested_amount'] = this.requestedAmount;
    data['transaction_date'] = this.transactionDate;
    if (this.planObject != null) {
      data['plan_object'] = this.planObject.toJson();
    }
    if (this.subaccount != null) {
      data['subaccount'] = this.subaccount.toJson();
    }
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

class Authorization {
  String authorizationCode;
  String bin;
  String last4;
  String expMonth;
  String expYear;
  String channel;
  String cardType;
  String bank;
  String countryCode;
  String brand;
  bool reusable;
  String signature;
  Null accountName;
  Null receiverBankAccountNumber;
  Null receiverBank;

  Authorization(
      {this.authorizationCode,
      this.bin,
      this.last4,
      this.expMonth,
      this.expYear,
      this.channel,
      this.cardType,
      this.bank,
      this.countryCode,
      this.brand,
      this.reusable,
      this.signature,
      this.accountName,
      this.receiverBankAccountNumber,
      this.receiverBank});

  Authorization.fromJson(Map<String, dynamic> json) {
    authorizationCode = json['authorization_code'];
    bin = json['bin'];
    last4 = json['last4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    channel = json['channel'];
    cardType = json['card_type'];
    bank = json['bank'];
    countryCode = json['country_code'];
    brand = json['brand'];
    reusable = json['reusable'];
    signature = json['signature'];
    accountName = json['account_name'];
    receiverBankAccountNumber = json['receiver_bank_account_number'];
    receiverBank = json['receiver_bank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorization_code'] = this.authorizationCode;
    data['bin'] = this.bin;
    data['last4'] = this.last4;
    data['exp_month'] = this.expMonth;
    data['exp_year'] = this.expYear;
    data['channel'] = this.channel;
    data['card_type'] = this.cardType;
    data['bank'] = this.bank;
    data['country_code'] = this.countryCode;
    data['brand'] = this.brand;
    data['reusable'] = this.reusable;
    data['signature'] = this.signature;
    data['account_name'] = this.accountName;
    data['receiver_bank_account_number'] = this.receiverBankAccountNumber;
    data['receiver_bank'] = this.receiverBank;
    return data;
  }
}

class Customer {
  int id;
  Null firstName;
  Null lastName;
  String email;
  String customerCode;
  Null phone;
  Null metadata;
  String riskAction;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.customerCode,
      this.phone,
      this.metadata,
      this.riskAction});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    customerCode = json['customer_code'];
    phone = json['phone'];
    metadata = json['metadata'];
    riskAction = json['risk_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['customer_code'] = this.customerCode;
    data['phone'] = this.phone;
    data['metadata'] = this.metadata;
    data['risk_action'] = this.riskAction;
    return data;
  }
}

class PlanObject {
  String param;
  PlanObject({this.param});

  PlanObject.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

//class Data {
//  int id;
//  String domain;
//  String status;
//  String reference;
//  int amount;
//  Null message;
//  String gatewayResponse;
//  String paidAt;
//  String createdAt;
//  String channel;
//  String currency;
//  String ipAddress;
//  Metadata metadata;
//  Null log;
//  int fees;
//  Null feesSplit;
//  Authorization authorization;
//  Customer customer;
//  Null plan;
//  Null orderId;
//  String paidAt2;
//  String createdAt2;
//  int requestedAmount;
//  String transactionDate;
//  PlanObject planObject;
//  PlanObject subaccount;
//
//  Data({this.id, this.domain, this.status, this.reference, this.amount, this.message, this.gatewayResponse, this.paidAt, this.createdAt, this.channel, this.currency, this.ipAddress, this.metadata, this.log, this.fees, this.feesSplit, this.authorization, this.customer, this.plan, this.orderId, this.paidAt2, this.createdAt2, this.requestedAmount, this.transactionDate, this.planObject, this.subaccount});
//
//  Data.fromJson(Map<String, dynamic> json) {
//    id = json['id'];
//    domain = json['domain'];
//    status = json['status'];
//    reference = json['reference'];
//    amount = json['amount'];
//    message = json['message'];
//    gatewayResponse = json['gateway_response'];
//    paidAt = json['paid_at'];
//    createdAt = json['created_at'];
//    channel = json['channel'];
//    currency = json['currency'];
//    ipAddress = json['ip_address'];
//    metadata = json['metadata'] != null ? new Metadata.fromJson(json['metadata']) : null;
//    log = json['log'];
//    fees = json['fees'];
//    feesSplit = json['fees_split'];
//    authorization = json['authorization'] != null ? new Authorization.fromJson(json['authorization']) : null;
//    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
//    plan = json['plan'];
//    orderId = json['order_id'];
//    paidAt2 = json['paidAt2'];
//    createdAt2 = json['createdAt2'];
//    requestedAmount = json['requested_amount'];
//    transactionDate = json['transaction_date'];
//    planObject = json['plan_object'] != null ? new PlanObject.fromJson(json['plan_object']) : null;
//    subaccount = json['subaccount'] != null ? new PlanObject.fromJson(json['subaccount']) : null;
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['id'] = this.id;
//    data['domain'] = this.domain;
//    data['status'] = this.status;
//    data['reference'] = this.reference;
//    data['amount'] = this.amount;
//    data['message'] = this.message;
//    data['gateway_response'] = this.gatewayResponse;
//    data['paid_at'] = this.paidAt;
//    data['created_at'] = this.createdAt;
//    data['channel'] = this.channel;
//    data['currency'] = this.currency;
//    data['ip_address'] = this.ipAddress;
//    if (this.metadata != null) {
//      data['metadata'] = this.metadata.toJson();
//    }
//    data['log'] = this.log;
//    data['fees'] = this.fees;
//    data['fees_split'] = this.feesSplit;
//    if (this.authorization != null) {
//      data['authorization'] = this.authorization.toJson();
//    }
//    if (this.customer != null) {
//      data['customer'] = this.customer.toJson();
//    }
//    data['plan'] = this.plan;
//    data['order_id'] = this.orderId;
//    data['paidAt2'] = this.paidAt2;
//    data['createdAt2'] = this.createdAt2;
//    data['requested_amount'] = this.requestedAmount;
//    data['transaction_date'] = this.transactionDate;
//    if (this.planObject != null) {
//      data['plan_object'] = this.planObject.toJson();
//    }
//    if (this.subaccount != null) {
//      data['subaccount'] = this.subaccount.toJson();
//    }
//    return data;
//  }
//}
