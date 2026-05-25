class ParameterModel {
  const ParameterModel({
    required this.parameterName,
    this.parameterValue,
  });

  final String parameterName;
  final String? parameterValue;

  factory ParameterModel.fromJson(Map<String, dynamic> json) => ParameterModel(
        parameterName: json['parameterName'] as String,
        parameterValue: json['parameterValue'] as String?,
      );
}

class TimePeriodModel {
  const TimePeriodModel({
    required this.startTime,
    required this.endTime,
    required this.parameter,
  });

  final String startTime;
  final String endTime;
  final ParameterModel parameter;

  factory TimePeriodModel.fromJson(Map<String, dynamic> json) => TimePeriodModel(
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        parameter: ParameterModel.fromJson(
          json['parameter'] as Map<String, dynamic>,
        ),
      );
}
