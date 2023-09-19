import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  DataModel({
    this.speakerName,
    this.text,
    this.summary,
    this.updateTime,
  });

  late final String? text;
  late final String? speakerName;
  late final String? summary;
  late final Timestamp? updateTime;

  DataModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    speakerName = json['speakerName'];
    summary = json['summary'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    return {

      'text': text,
      'speakerName': speakerName,
      'summary': summary,
      'updateTime': updateTime,

    };
  }
}
