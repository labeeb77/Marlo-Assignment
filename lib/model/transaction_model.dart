class TransactionRes {
  String? errorFlag;
  String? message;
  List<Datum>? data;

  TransactionRes({
    this.errorFlag,
    this.message,
    this.data,
  });

  factory TransactionRes.fromJson(Map<String, dynamic> json) => TransactionRes(
        errorFlag: json["error_flag"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error_flag": errorFlag,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? amount;
  String? status;
  String? sourceId;
  String? sourceType;
  String? transactionType;
  String? currency;
  String? createdAt;
  String? fee;
  String? description;
  String? settledAt;
  String? estimatedSettledAt;
  String? currency1;

  Datum({
    this.id,
    this.amount,
    this.status,
    this.sourceId,
    this.sourceType,
    this.transactionType,
    this.currency,
    this.createdAt,
    this.fee,
    this.description,
    this.settledAt,
    this.estimatedSettledAt,
    this.currency1,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        amount: json["amount"],
        status: json["status"],
        sourceId: json["sourceId"],
        sourceType: json["sourceType"],
        transactionType: json["transactionType"],
        currency: json["currency"],
        createdAt: json["createdAt"],
        fee: json["fee"],
        description: json["description"],
        settledAt: json["settledAt"],
        estimatedSettledAt: json["estimatedSettledAt"],
        currency1: json["currency1"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "status": status,
        "sourceId": sourceId,
        "sourceType": sourceType,
        "transactionType": transactionType,
        "currency": currency,
        "createdAt": createdAt,
        "fee": fee,
        "description": description,
        "settledAt": settledAt,
        "estimatedSettledAt": estimatedSettledAt,
        "currency1": currency1,
      };
}