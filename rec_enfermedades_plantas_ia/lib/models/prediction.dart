class Prediction {
  final String className;
  final String confidence;
  final String description;
  final String examplePicture;
  final String prevention;
  final String treatment;
  final String classNameEs;
  final String descriptionEs;
  final String preventionEs;
  final String treatmentEs;

  Prediction({
    required this.className,
    required this.confidence,
    required this.description,
    required this.examplePicture,
    required this.prevention,
    required this.treatment,
    required this.classNameEs,
    required this.descriptionEs,
    required this.preventionEs,
    required this.treatmentEs,
  });


  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'confidence': confidence,
      'description': description,
      'examplePicture': examplePicture,
      'prevention': prevention,
      'treatment': treatment,
      'classNameEs': classNameEs,
      'descriptionEs': descriptionEs,
      'preventionEs': preventionEs,
      'treatmentEs': treatmentEs,
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      className: map['className'] ?? '',
      confidence: map['confidence'] ?? '',
      description: map['description'] ?? '',
      examplePicture: map['examplePicture'] ?? 'N/A',
      prevention: map['prevention'] ?? 'N/A',
      treatment: map['treatment'] ?? 'N/A',
      classNameEs: map['classNameEs'] ?? '',
      descriptionEs: map['descriptionEs'] ?? '',
      preventionEs: map['preventionEs'] ?? '',
      treatmentEs: map['treatmentEs'] ?? '',
    );
  }

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      className: json['class_name'] as String,
      confidence: json['confidence'] as String,
      description: json['description'] as String,
      examplePicture: json['example_picture'] as String? ?? 'N/A',
      prevention: json['prevention'] as String? ?? 'N/A',
      treatment: json['treatment'] == "NaN" ? "No treatment needed" : json['treatment'] as String? ?? 'N/A',
      classNameEs: json['class_name_es'] ?? json['class_name'],
      descriptionEs: json['description_es'] ?? json['description'],
      preventionEs: json['prevention_es'] ?? json['prevention'],
      treatmentEs: json['treatment_es'] ?? json['treatment'],
    );
  }

}

class Predictions {
  final Prediction prediction1;
  final Prediction prediction2;
  final Prediction prediction3;

  Predictions({
    required this.prediction1,
    required this.prediction2,
    required this.prediction3,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      prediction1: Prediction.fromJson(json['prediction_1']),
      prediction2: Prediction.fromJson(json['prediction_2']),
      prediction3: Prediction.fromJson(json['prediction_3']),
    );
  }
}
