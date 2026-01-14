class CalculatorEngine {
  String _display = "0";
  num _current = 0;
  num _prev = 0;
  bool _calcState = false;
  bool _curCalcChange = false;
  String _clear = "AC";
  String _prevFunction = "";
  bool _justEvaluated = false;
  String _lastFunction = "";
  num _lastOperand = 0;

  String get display => _display;
  String get clear => _clear;

  void ac() {
    _display = "0";
    _current = 0;
    _prev = 0;
    _prevFunction = "";
    _justEvaluated = false;
    _lastFunction = "";
    _lastOperand = 0;
    _clear = "AC";
    _curCalcChange = false;
    _calcState = false;
  }

  void percentage() {
    if (_display == "Error") {
      return;
    }
    _current = _parseDisplay(_display);
    _current = _current / 100;
    _display = _formatNumber(_current);
    _curCalcChange = true;
    _clear = "C";
  }

  void addNumber(String digit) {
    _clear = "C";
    if (_display == "Error") {
      ac();
    }
    if (_calcState || _justEvaluated) {
      _display = "0";
      _justEvaluated = false;
    }
    _curCalcChange = true;
    if (_calcState) {
      _display = "";
      _calcState = false;
    } else if (_display == "0") {
      _display = "";
    }
    _display += digit;
    _current = _parseDisplay(_display);
  }

  void addDecimal() {
    if (_display == "Error") {
      ac();
    }
    if (_calcState || _justEvaluated) {
      _display = "0";
      _calcState = false;
      _justEvaluated = false;
    }
    if (!_display.contains(".")) {
      _display += ".";
    }
    _current = _parseDisplay(_display);
    _clear = "C";
    _curCalcChange = true;
  }

  void performCalc(String desiredFunction) {
    if (_display == "Error") {
      return;
    }
    if (desiredFunction == "=") {
      performEquals();
      _curCalcChange = false;
      return;
    }

    if (_prevFunction.isNotEmpty && _curCalcChange) {
      performEquals();
    } else if (_prevFunction.isEmpty) {
      _prev = _parseDisplay(_display);
    }

    _prevFunction = desiredFunction;
    _calcState = true;
    _curCalcChange = false;
    _justEvaluated = false;
  }

  void performEquals() {
    if (_display == "Error") {
      return;
    }
    _current = _parseDisplay(_display);
    if (_prevFunction.isEmpty && _justEvaluated && _lastFunction.isNotEmpty) {
      _prevFunction = _lastFunction;
      _current = _lastOperand;
    }
    if (_prevFunction.isEmpty) {
      return;
    }

    if (_prevFunction == "+") {
      _prev += _current;
    } else if (_prevFunction == "-") {
      _prev -= _current;
    } else if (_prevFunction == "x") {
      _prev *= _current;
    } else if (_prevFunction == "÷") {
      if (_current == 0) {
        _setError();
        return;
      }
      _prev /= _current;
    }

    _display = _formatNumber(_prev);
    _calcState = true;
    _lastFunction = _prevFunction;
    _lastOperand = _current;
    _current = _prev;
    _prevFunction = "";
    _justEvaluated = true;
  }

  void undo() {
    if (_display == "Error") {
      ac();
      return;
    }
    if (_display.isNotEmpty) {
      _display = _display.substring(0, _display.length - 1);
    }
    if (_display.isEmpty || _display == "-") {
      _display = "0";
    }
    _current = _parseDisplay(_display);
    _curCalcChange = true;
  }

  void plusMinus() {
    if (_display == "Error") {
      return;
    }
    if (_curCalcChange) {
      if (_current != 0) {
        _current *= -1;
        _display = _formatNumber(_current);
      }
    } else {
      if (_prev != 0) {
        _prev *= -1;
        _display = _formatNumber(_prev);
      }
    }
  }

  num _parseDisplay(String value) {
    if (value == "Error") {
      return 0;
    }
    var normalized = value;
    if (normalized.endsWith(".")) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    if (normalized.isEmpty || normalized == "-") {
      return 0;
    }
    return num.parse(normalized);
  }

  String _formatNumber(num value) {
    if (value is int) {
      return value.toString();
    }
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  void _setError() {
    _display = "Error";
    _current = 0;
    _prev = 0;
    _prevFunction = "";
    _lastFunction = "";
    _lastOperand = 0;
    _justEvaluated = false;
    _curCalcChange = false;
    _calcState = false;
    _clear = "AC";
  }
}
