import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  Color red = Color(0xFFF46262);
  Color white = Color(0xFFFFFFFF);

  TextEditingController _topController = TextEditingController();
  TextEditingController _bottomController = TextEditingController();

  @override
  void initState() {
    _api.getExchangeRate('GBP', 'AUD').then((double val) => setState(() {
          _topToBottomRate = val;
          _topController.text = "1";
          _bottomController.text =
              (1 * _topToBottomRate)
                  .toStringAsFixed(2);
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: _buildMainPage(context)),
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
              color: Colors.white,
              border: Border.all(color: red, width: 10)),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          child: Icon(
              _isTopToBottom ? Icons.arrow_downward : Icons.arrow_upward,
              size: MediaQuery.of(context).size.width / 4,
              color: red),
        ),
      ],
    );
  }

  Widget _buildTopHalf(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: red),
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
                color: white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: TextField(
              cursorColor: red,
              keyboardType: TextInputType.number,
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(hintText: ""),
              controller: _topController,
              onChanged: (String val) => _onTopTextChanged(val),
              style: TextStyle(
                fontSize: 100,
                color: white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30),
            child: Text(
              'Pound Sterling',
              style: TextStyle(
                color: white,
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
        color: white,
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
                color: red,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            alignment: Alignment.center,
            child: TextField(
              keyboardType: TextInputType.number,
              cursorColor: white,
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(hintText: ""),
              controller: _bottomController,
              onChanged: (String val) => _onBottomTextChanged(val),
              style: TextStyle(
                fontSize: 100,
                color: red,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Australian Dollar',
              style: TextStyle(
                color: red,
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
      _bottomController.text = (double.parse(val) *
              _topToBottomRate)
          .toStringAsFixed(2);
      _isTopToBottom = true;
    });
  }

  void _onBottomTextChanged(String val) {
    setState(() {
      _topController.text = (double.parse(val) *
              (1 / _topToBottomRate)).toStringAsFixed(2);
      _isTopToBottom = false;
    });
  }
}
