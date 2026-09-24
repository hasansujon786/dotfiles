List<int> mergeSort(List<int> list) {
  if (list.length <= 1) {
    return list;
  }

  int middle = list.length ~/ 2;

  List<int> leftHalf = mergeSort(list.sublist(0, middle));
  List<int> rightHalf = mergeSort(list.sublist(middle));

  return merge(leftHalf, rightHalf);
}

List<int> merge(List<int> left, List<int> right) {
  final List<int> list = [];
  var lIndex = 0, rIndex = 0;

  while (lIndex < left.length && rIndex < right.length) {
    if (left[lIndex] <= right[rIndex]) {
      list.add(left[lIndex]);
      lIndex++;
    } else {
      list.add(right[rIndex]);
      rIndex++;
    }
  }

  while (lIndex < left.length) {
    list.add(left[lIndex]);
    lIndex++;
  }

  while (rIndex < right.length) {
    list.add(right[rIndex]);
    rIndex++;
  }

  return list;
}

void main() {
  List<int> numbers = [38, 27, 43, 3, 9, 82, 10];
  print('Unsorted List: $numbers');

  List<int> sortedNumbers = mergeSort(numbers);
  print('Sorted List:   $sortedNumbers');
}
