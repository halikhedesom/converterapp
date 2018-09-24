// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';
import 'package:converter_app/unit.dart';
import 'package:converter_app/conveter_route.dart';

/// A custom [Category] widget.
///
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class Category extends StatelessWidget {
  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  // TODO: You'll need the name, color, and iconLocation from main.dart

  final String name;
  final IconData icon;
  final ColorSwatch highlightColor;
  final List<Unit> units;

  const Category({Key key,@required this.name,
                  @required this.icon, @required this.highlightColor,@required this.units}):super(key:key);

  /// Navigates to the [ConverterRouteState].
  void _navigateToConverter(BuildContext context) {
    // TODO: Using the Navigator, navigate to the [ConverterRoute]
    Navigator.of(context).push(
      //context,
      MaterialPageRoute(
        builder:(context){
        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text(
              name,
              style: Theme.of(context).textTheme.display1,
            ),
            centerTitle: true,
            backgroundColor: highlightColor,
          ),
          body: ConverterRoute(
            units: units,
            color: highlightColor,
            name: name,
          ),
          resizeToAvoidBottomPadding: false,
        );

        },),
    );
  }

  /// Builds a custom widget that shows [Category] information.
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    // TODO: Build the custom widget here, referring to the Specs.
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 100.0,
        //padding:EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius:BorderRadius.all(Radius.circular(50.0)),
          highlightColor: highlightColor,
          onTap: (){
            print('I am tapped');
            _navigateToConverter(context);
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.only(right: 16.0),
                  child: Icon(icon, size: 60.0,),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                      color: Colors.grey[700],
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}