import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '0';
  bool calculateOk = false;

  Widget calcButton(String btntxt, Color btnColor, Color txtColor) {
    return Container(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          _handleButtonClick(btntxt);
        },
        child: Text(
          btntxt,
          style: TextStyle(fontSize: 35, color: txtColor),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
            backgroundColor: btnColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _expression.isEmpty ? '0' : _expression,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 100),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton("AC", Colors.grey, Colors.black),
                calcButton("+/-", Colors.grey, Colors.black),
                calcButton("%", Colors.grey, Colors.black),
                calcButton("/", Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton("7", Colors.grey.shade800, Colors.white),
                calcButton("8", Colors.grey.shade800, Colors.white),
                calcButton("9", Colors.grey.shade800, Colors.white),
                calcButton("*", Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton(
                    "4", const Color.fromARGB(255, 100, 94, 94), Colors.white),
                calcButton("5", Colors.grey.shade800, Colors.white),
                calcButton("6", Colors.grey.shade800, Colors.white),
                calcButton("-", Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton("1", Colors.grey.shade800, Colors.white),
                calcButton("2", Colors.grey.shade800, Colors.white),
                calcButton("3", Colors.grey.shade800, Colors.white),
                calcButton("+", Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(34, 20, 120, 20),
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.grey.shade800),
                  child: const Text(
                    "0",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                ),
                calcButton(".", Colors.grey.shade800, Colors.white),
                calcButton("=", Colors.amber.shade700, Colors.white),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _updateExpression(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _calculate() {
    setState(() {
      try {
        _result = _evalExpression(_expression).toString();
      } catch (e) {
        _result = 'Error';
      }
    });
  }

  void _handleButtonClick(String buttonText) {
    if (buttonText == 'AC') {
      _clear();
    } else if (buttonText == '+/-') {
      //implement negation
    } else if (buttonText == '%') {
      //yüzde alma
    } else if (buttonText == '=') {
      _calculate();
    } else {
      _updateExpression(buttonText);
    }
    print(_result);
    print(_expression);
  }

  double _evalExpression(String expression) {
    Parser p = Parser();
    ContextModel cm = ContextModel();
    Expression exp = p.parse(expression);
    return exp.evaluate(EvaluationType.REAL, cm);
  }
}
