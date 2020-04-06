import 'package:flutter_test/flutter_test.dart';
import 'package:superlink/superlink.dart';

void main() {
  test('adds one to input values', () {
    final test = StatusLink(filial: '0101', codOrc: '159753');
    final resp = GerarLink(valorOrc: '0.20',parcelasLink: 1,filial: '0101',codOrc: '159753');
  });
}
