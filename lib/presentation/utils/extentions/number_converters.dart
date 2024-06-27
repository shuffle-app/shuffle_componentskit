
extension NumberConverters on double {
  String get nanOrTwoTrailingZeros {
    //identify if the number has numbers after the decimal point
    // if it does, then add 2 trailing zeros
    // if it doesn't, then just return the number
    if (toString().contains('.') && int.parse(toString().split('.').last) != 0) {
      return toStringAsFixed(2);
    } else {
      return toString().split('.').first;
    }
  }
}
