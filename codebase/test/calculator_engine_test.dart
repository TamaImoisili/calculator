import 'package:calculator_app/calculator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats whole-number results without .0', () {
    final engine = CalculatorEngine();
    engine.addNumber("1");
    engine.addDecimal();
    engine.addNumber("5");
    engine.performCalc("+");
    engine.addNumber("2");
    engine.addDecimal();
    engine.addNumber("5");
    engine.performCalc("=");
    expect(engine.display, "4");
  });

  test('repeated equals repeats the last operation', () {
    final engine = CalculatorEngine();
    engine.addNumber("5");
    engine.performCalc("+");
    engine.addNumber("2");
    engine.performCalc("=");
    expect(engine.display, "7");
    engine.performCalc("=");
    expect(engine.display, "9");
  });

  test('division by zero shows error and clears on next input', () {
    final engine = CalculatorEngine();
    engine.addNumber("8");
    engine.performCalc("÷");
    engine.addNumber("0");
    engine.performCalc("=");
    expect(engine.display, "Error");
    engine.addNumber("7");
    expect(engine.display, "7");
  });

  test('undo removes digits and returns to zero', () {
    final engine = CalculatorEngine();
    engine.addNumber("1");
    engine.addNumber("2");
    engine.undo();
    expect(engine.display, "1");
    engine.undo();
    expect(engine.display, "0");
  });

  test('percentage divides the current value by 100', () {
    final engine = CalculatorEngine();
    engine.addNumber("5");
    engine.addNumber("0");
    engine.percentage();
    expect(engine.display, "0.5");
  });
}
