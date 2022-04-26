class OrderType {
  final int value;
  final String name;

  OrderType({this.value, this.name});
  
  ///custom comparing function to check if two users are equal
  bool isEqual(OrderType model) {
    return this?.value == model?.value;
  }

  int valueOf() {
    return this.value;
  }

  @override
  String toString() => name;
}