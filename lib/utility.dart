class Utility {
  static String getFromatCost({required double number}) {
    if (number >= 1000) {
      final k = (number / 1000).toStringAsFixed(2).split(".");
      return "${k[0]}${k[1] == "00" ? "" : ".${k[1]}"} K";
    } else {
      final outNumber = number.toStringAsFixed(2);
      final split = outNumber.split(".");
      return "${split[0]} ${split[1] == "00" ? "" : ".${split[1]}"}";
    }
  }
}
