// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:converter_app/unit.dart';

const _padding = EdgeInsets.all(16.0);

class ConverterRoute extends StatefulWidget {

  /// Units for this [Category].
  final List<Unit> units;
  final String name;
  final Color color;

  ConverterRoute({
    @required this.units, @required this.name,@required this.color
  }) : assert(units != null);


  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {

  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue='';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidateError = false;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  void _createDropdownMenuItems(){
    var newItems = <DropdownMenuItem>[];
    for(var unit in widget.units){
      newItems.add(
        DropdownMenuItem(
          value: unit.name,
          child: Container(
            child: Text(
              unit.name,
              softWrap: true,
            ),
          ),
        )
      );
    }

    setState(() {
      _unitMenuItems = newItems;
    });
    
    print("############# ${_unitMenuItems.length}");
  }

  void _setDefaults(){
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });
  }

  String _format(double conversion){
    var outputNum = conversion.toStringAsPrecision(7);
    if(outputNum.contains('.') && outputNum.endsWith('0')){
      var i = outputNum.length;
      while(outputNum[i] == '0'){
        i = i-1;
      }
      outputNum = outputNum.substring(0,i+1);
    }

    if(outputNum.endsWith('.'))
      return outputNum.substring(0,outputNum.length-1);

    return outputNum;
  }

  void _updateConversion(){
    setState(() {
      _convertedValue = _format(_inputValue * (_toValue.conversion/_fromValue.conversion));
    });
  }

  void _updateInputValue(String input){
    setState(() {
      if(input == null || input.isEmpty)
        _convertedValue = '';
      else{
         try{
           final inputDouble = double.parse(input);
           _showValidateError = false;
           _inputValue = inputDouble;
           _updateConversion();
         }on Exception catch(e){
           print('Error: $e');
           _showValidateError=true;
         }
      }
    });
  }

  Unit _getUnit(String unitName){
    return widget.units.firstWhere(
        (Unit unit){return unit.name == unitName;},
        orElse: null,
    );
  }

  void _updateFromConversion(dynamic unitName){
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if(_inputValue != null){
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName){
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if(_inputValue != null)
      _updateConversion();
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged){ //What is ValueChanged
    print('currentValue - $currentValue');
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[50],
          width: 1.0
        )
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                items: _unitMenuItems,
                value: currentValue,
                onChanged: onChanged,
                style: Theme.of(context).textTheme.title,
              ),
            )
        ),
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    final unitWidgets = widget.units.map((Unit unit) {
      // TODO: Set the color for this Container
      return Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        color: widget.color,
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();
    print("building widget start $_fromValue");
    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              errorText: _showValidateError ? 'Invalid number entered' : null,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0)
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          _createDropdown(_fromValue.name, _updateFromConversion),
        ],
      ),
    );

    final arrow = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0)
              )
            ),
          ),
          _createDropdown(_toValue.name, _updateToConversion)
        ],
      ),
    );


    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        input,
        arrow,
        output
      ],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );
  }
}