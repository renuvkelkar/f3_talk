class TranscribResult {
  List<Results>? results;

  TranscribResult({this.results});

  TranscribResult.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  List<Alternatives>? alternatives;
  String? languageCode;
  String? resultEndTime;

  Results({this.alternatives, this.languageCode, this.resultEndTime});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['alternatives'] != null) {
      alternatives = <Alternatives>[];
      json['alternatives'].forEach((v) {
        alternatives!.add(new Alternatives.fromJson(v));
      });
    }
    languageCode = json['languageCode'];
    resultEndTime = json['resultEndTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alternatives != null) {
      data['alternatives'] = this.alternatives!.map((v) => v.toJson()).toList();
    }
    data['languageCode'] = this.languageCode;
    data['resultEndTime'] = this.resultEndTime;
    return data;
  }
}

class Alternatives {
  double? confidence;
  String? transcript;

  Alternatives({this.confidence, this.transcript});

  Alternatives.fromJson(Map<String, dynamic> json) {
    confidence = json['confidence'];
    transcript = json['transcript'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confidence'] = this.confidence;
    data['transcript'] = this.transcript;
    return data;
  }
}
