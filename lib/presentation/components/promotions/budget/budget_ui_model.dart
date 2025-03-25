class BudgetUiModel {
  final int? id;
  final int? dailyBudget;
  final double? averageCpc;
  final int? generalBudget;

  const BudgetUiModel({this.id, required this.dailyBudget, required this.averageCpc, required this.generalBudget});

  BudgetUiModel copyWith({
    int? id,
    int? dailyBudget,
    double? averageCpc,
    int? generalBudget,
  }) =>
      BudgetUiModel(
        id: id ?? this.id,
        dailyBudget: dailyBudget ?? this.dailyBudget,
        averageCpc: averageCpc ?? this.averageCpc,
        generalBudget: generalBudget ?? this.generalBudget,
      );
}
