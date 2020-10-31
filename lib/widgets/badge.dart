import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const Badge({
    @required this.child,
    @required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(3.0),
            constraints: BoxConstraints(
              minHeight: 16.0,
              minWidth: 16.0,
              maxHeight: 20.0,
              maxWidth: 20.0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color == null ? Theme.of(context).accentColor : color,
            ),
            child: FittedBox(
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
