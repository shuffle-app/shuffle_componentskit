abstract class Range {
  List get asList;
}

class IntegerRange extends Range {
  final int start;
  final int end;

  @override
  List<int> get asList => [start, end];

  IntegerRange({
    required this.start,
    required this.end,
  });
}
