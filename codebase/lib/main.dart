import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentCalculationSTR = "0";
  num currentCalculation = 0; //I am using nums as I need to switch back and
  //forth between decimals and integers.
  num prevCalc = 0; //Same thing here
  bool calcState =
      false; // This determines the calculation state, I forget the function
  bool curCalcChange = false; // used to determine when user inputs a new value
  //to change the current calculation.
  bool decimalStillLastDigit = true;
  String clear = "AC";
  String prevFunction = "";
  bool visualMode = true;
  bool buttonPressed = false;

  void _ac() {
    //Adjusts the AC button to clear and vice versa as inputs are entered
    if (clear == "C") {
      prevCalc = 0;
      setState(() {
        currentCalculationSTR = "0";
      });
      currentCalculation = 0;
      clear = "AC";
    } else {
      prevCalc = 0;
      setState(() {
        currentCalculationSTR = "0";
      });
      currentCalculation = 0;
    }
    buttonPressed = false;
  }

  void _percentage() {
    currentCalculation = currentCalculation / 100;
    setState(() {
      currentCalculationSTR = currentCalculation.toString();
    });
    curCalcChange = false;
  }

  void _addNumber(String num) {
    // adds a number to the current value
    clear = "C";
    curCalcChange = true;
    if (calcState) {
      currentCalculationSTR = "";
      setState(() {
        currentCalculationSTR += num;
      });
      try {
        currentCalculation = int.parse(currentCalculationSTR);
      } catch (e) {
        currentCalculation = double.parse(currentCalculationSTR);
      }
      calcState = false;
    } else {
      if (currentCalculationSTR == "0") {
        currentCalculationSTR = "";
      }
      setState(() {
        currentCalculationSTR += num;
      });

      try {
        currentCalculation = int.parse(currentCalculationSTR);
      } catch (e) {
        currentCalculation = double.parse(currentCalculationSTR);
      }
      if (currentCalculation is double && currentCalculation % 1 == 0) {
        currentCalculation.toInt();
      }
    }
    buttonPressed = false;
  }

  void _addDecimal() {
    //adds a decimal to the display but not the actual value yet.
    setState(() {
      currentCalculationSTR += ".";
    });
  }

  void _performCalc(String desiredFunction) {
    /*An issue with calculation occurs when you use the app as the it often
    *confuses the previous and current calculations when you enter a value 
    *and press button it performs a calculation when you do not want to
    *perform one.*/
    if (desiredFunction == "+") {
      //addition function that adds the previous to the current calc
      if (prevCalc == 0) {
        prevCalc = currentCalculation;
      } else {
        if (curCalcChange) {
          _performEquals();
          if (buttonPressed) {
            prevCalc += currentCalculation;
            setState(() {
              currentCalculationSTR = prevCalc.toString();
            });
          }
        }
      }
      buttonPressed = true;
      calcState = true;
      curCalcChange = false;
      prevFunction = "+";
    } else if (desiredFunction == "-") {
      //subtraction function that adds the previous to the current calc
      if (prevCalc == 0) {
        prevCalc = currentCalculation;
      } else {
        if (curCalcChange) {
          _performEquals();
          if (buttonPressed) {
            prevCalc -= currentCalculation;
            setState(() {
              currentCalculationSTR = prevCalc.toString();
            });
          }
        }
      }
      buttonPressed = true;
      calcState = true;
      curCalcChange = false;
      prevFunction = "-";
    } else if (desiredFunction == "x") {
      //multiplication function that multiplies the previous to the current calc
      if (prevCalc == 0) {
        prevCalc = currentCalculation;
      } else {
        if (currentCalculation == 0 && prevCalc != 0) {
          return;
        } else {
          if (curCalcChange) {
            _performEquals();
            if (buttonPressed) {
              prevCalc *= currentCalculation;
              setState(() {
                currentCalculationSTR = prevCalc.toString();
              });
            }
          }
        }
      }
      buttonPressed = true;
      calcState = true;
      curCalcChange = false;
      prevFunction = "x";
    } else if (desiredFunction == "÷") {
      //division isn't handled properly needs to be fixed
      if (prevCalc == 0) {
        prevCalc = currentCalculation;
      } else {
        if (curCalcChange) {
          _performEquals();
          if (buttonPressed) {
            if (currentCalculation == 0) {
              setState(() {
                currentCalculationSTR = "Error";
              });
            } else {
              prevCalc /= currentCalculation;
              setState(() {
                currentCalculationSTR = prevCalc.toString();
              });
            }
          }
        }
      }
      buttonPressed = true;
      calcState = true;
      curCalcChange = false;
      prevFunction = "÷";
    } else if (desiredFunction == "=") {
      _performEquals();
      curCalcChange = false;
    }
  }

  void _performEquals() {
//equals to fucntion this does the does function that was previously
    //done
    if (prevFunction == "+") {
      prevCalc += currentCalculation;
      setState(() {
        currentCalculationSTR = prevCalc.toString();
      });
      calcState = true;
      prevFunction = "+";
    } else if (prevFunction == "-") {
      prevCalc -= currentCalculation;
      setState(() {
        currentCalculationSTR = prevCalc.toString();
      });
      calcState = true;
      prevFunction = "-";
    } else if (prevFunction == "x") {
      prevCalc *= currentCalculation;
      setState(() {
        currentCalculationSTR = prevCalc.toString();
      });
      calcState = true;
      prevFunction = "x";
    } else if (prevFunction == "÷") {
      if (currentCalculation == 0) {
        setState(() {
          currentCalculationSTR = "Error";
        });
      } else {
        prevCalc /= currentCalculation;
        setState(() {
          currentCalculationSTR = prevCalc.toString();
        });
        calcState = true;
        prevFunction = "÷";
      }
    }
    buttonPressed = false;
  }

  void _undo() {
    if (currentCalculationSTR.isNotEmpty) {
      setState(() {
        currentCalculationSTR = currentCalculationSTR.substring(
            0, currentCalculationSTR.length - 1);
      });
      if (currentCalculationSTR.isEmpty) {
        setState(() {
          currentCalculationSTR = "0";
        });
      }
    } else {
      currentCalculationSTR;
    }
    try {
      currentCalculation = int.parse(currentCalculationSTR);
    } catch (e) {
      currentCalculation = double.parse(currentCalculationSTR);
    }
    if (currentCalculation is double && currentCalculation % 1 == 0) {
      currentCalculation.toInt();
    }
  }

  void _plusMinus() {
    if (curCalcChange) {
      if (currentCalculation != 0) {
        currentCalculation *= -1;
        setState(() {
          currentCalculationSTR = currentCalculation.toString();
        });
      }
    } else {
      if (prevCalc != 0) {
        prevCalc *= -1;
        setState(() {
          currentCalculationSTR = prevCalc.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; //screen height
    final desiredTop = screenHeight * 0.3; //63 percent of the screen
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          //position the top container above the bottom one so they
          //align properly
          left: 0,
          right: 0,
          top: 0,
          child: Container(
              //top container to house results display
              width: MediaQuery.of(context).size.width,
              height: screenHeight * 0.35,
              color: visualMode
                  ? const Color.fromARGB(255, 35, 37, 45)
                  : const Color.fromARGB(255, 255, 255, 255),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 55),
                    child: Text(
                      currentCalculationSTR,
                      style: TextStyle(
                        color: visualMode ? Colors.white : Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ))),
        ),
        Positioned(
            left: 0,
            right: 0,
            top: desiredTop,
            child: Container(
              //Lower contianer to house calculator buttons
              //use elevated buttons to make them more noticeable
              //try to play around to get the make the buttons respective
              //of each other and the container
              width: MediaQuery.of(context).size.width,
              height: screenHeight / 0.7,
              decoration: BoxDecoration(
                  color: visualMode
                      ? const Color.fromARGB(255, 42, 45, 53)
                      : const Color.fromARGB(255, 249, 249, 249),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  //row 1 begin
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _ac();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              clear,
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 110, 234, 188)
                                    : const Color.fromARGB(255, 100, 210, 178),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            //add function to +/-
                            onPressed: () {
                              _plusMinus();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '+/-',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 110, 234, 188)
                                    : const Color.fromARGB(255, 100, 210, 178),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            //add function to %
                            onPressed: () {
                              _percentage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '%',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 110, 234, 188)
                                    : const Color.fromARGB(255, 100, 210, 178),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _performCalc("÷");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '÷',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 190, 110, 110)
                                    : const Color.fromARGB(255, 255, 100, 100),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //row 1 end

                  //row 2 begin
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("7");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '7',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("8");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '8',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("9");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '9',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _performCalc("x");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'x',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 190, 110, 110)
                                    : const Color.fromARGB(255, 255, 100, 100),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //row 2 end

                  //row 3 begin
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("4");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '4',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("5");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '5',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("6");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '6',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _performCalc("-");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '-',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 190, 110, 110)
                                    : const Color.fromARGB(255, 255, 100, 100),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //row 3 end

                  //row 4 begin
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("1");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("2");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("3");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _performCalc("+");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '+',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 190, 110, 110)
                                    : const Color.fromARGB(255, 255, 100, 100),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //row 4 end

                  //row 5 begin
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          //add function to the undo
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _undo();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Icon(
                              Icons.undo,
                              color: visualMode ? Colors.white : Colors.black,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addNumber("0");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '0',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _addDecimal();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '.',
                              style: TextStyle(
                                color: visualMode ? Colors.white : Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              _performCalc("=");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: visualMode
                                  ? const Color.fromARGB(255, 40, 43, 51)
                                  : const Color.fromARGB(255, 247, 247, 247),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Adjust border radius as needed
                              ),
                              minimumSize: const Size(60, 60),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              '=',
                              style: TextStyle(
                                color: visualMode
                                    ? const Color.fromARGB(255, 190, 110, 110)
                                    : const Color.fromARGB(255, 255, 100, 100),
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //row 5 end
                ],
              ),
            )),
        Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2.7,
            right: MediaQuery.of(context).size.width / 2.7,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: visualMode
                    ? const Color.fromARGB(255, 42, 45, 53)
                    : const Color.fromARGB(255, 249, 249, 249),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.wb_sunny),
                    onPressed: () {
                      setState(() {
                        visualMode = false;
                      });
                    },
                    color: visualMode ? Colors.grey : Colors.black,
                  ),
                  IconButton(
                    icon: const Icon(Icons.mode_night),
                    onPressed: () {
                      setState(() {
                        visualMode = true;
                      });
                    },
                    color: visualMode ? Colors.white : Colors.grey,
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}
