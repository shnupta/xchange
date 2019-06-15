import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;

import 'package:xchange/exchange_rates/exchange_rates.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  double _topToBottomRate = 0;
  ExchangeRatesAPI _api = ExchangeRatesAPI();

  bool _isTopToBottom = true;

  static List<Color> colors = [
    Color(0xFF456990),
    Color(0xFFCEB992),
    Color(0xFF797A9E),
    Color(0xFFF48B8B),
    Color(0xFF92BDA3)
  ];

  Color primary = colors[math.Random().nextInt(5)]; // The accent type color
  Color secondary = Color(0xFFFFFFFF); // Probably white

  TextEditingController _topController = TextEditingController();
  TextEditingController _bottomController = TextEditingController();

  @override
  void initState() {
    _api.getExchangeRate('GBP', 'AUD').then((double val) => setState(() {
          _topToBottomRate = val;
          _topController.text = "1";
          _bottomController.text = (1 * _topToBottomRate).toStringAsFixed(2);
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SingleChildScrollView(
          child: _buildMainPage(context),
        ),
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      ),
    );
  }

  Widget _buildMainPage(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                child: _buildTopHalf(context),
                height: MediaQuery.of(context).size.height / 2),
            Container(
                child: _buildBottomHalf(context),
                height: MediaQuery.of(context).size.height / 2),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: secondary,
              border: Border.all(color: primary, width: 10)),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          child: IconButton(
            onPressed: () => _switchDirection(),
            icon: Icon(
                _isTopToBottom ? Icons.arrow_downward : Icons.arrow_upward,
                size: MediaQuery.of(context).size.width / 4,
                color: primary),
          ),
        ),
      ],
    );
  }

  Widget _buildTopHalf(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: primary),
      child: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                bottom: 30 + MediaQuery.of(context).size.width / 6),
            child: Text(
              'GBP',
              style: TextStyle(
                fontSize: 32,
                color: secondary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: TextField(
              cursorColor: primary,
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(hintText: ""),
              controller: _topController,
              onTap: () => _clearControllers(),
              onChanged: (String val) => _onTopTextChanged(val),
              style: TextStyle(
                fontSize: 100,
                color: secondary,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30),
            child: Text(
              'Pound Sterling',
              style: TextStyle(
                color: secondary,
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHalf(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: 30 + MediaQuery.of(context).size.width / 6),
            child: Text(
              'AUD',
              style: TextStyle(
                fontSize: 32,
                color: primary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            alignment: Alignment.center,
            child: TextField(
              keyboardType: TextInputType.number,
              cursorColor: secondary,
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(hintText: ""),
              controller: _bottomController,
              onTap: () => _clearControllers(),
              onChanged: (String val) => _onBottomTextChanged(val),
              style: TextStyle(
                fontSize: 100,
                color: primary,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Australian Dollar',
              style: TextStyle(
                color: primary,
                fontSize: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onTopTextChanged(String val) {
    setState(() {
      if (val.isEmpty) {
        _bottomController.text = "";
      } else {
        _bottomController.text =
            (double.parse(val) * _topToBottomRate).toStringAsFixed(2);
        _isTopToBottom = true;
      }
    });
  }

  void _onBottomTextChanged(String val) {
    setState(() {
      if (val.isEmpty) {
        _topController.text = "";
      } else {
        _topController.text =
            (double.parse(val) * (1 / _topToBottomRate)).toStringAsFixed(2);
        _isTopToBottom = false;
      }
    });
  }

  void _clearControllers() {
    _topController.clear();
    _bottomController.clear();
  }

  void _switchDirection() {
    setState(() {
      String topTemp = _topController.text;
      _topController.text = _bottomController.text;
      _bottomController.text = topTemp;
      _isTopToBottom = !_isTopToBottom;
      if (_isTopToBottom) {
        _onTopTextChanged(_topController.text);
      } else {
        _onBottomTextChanged(_bottomController.text);
      }
    });
  }
}
