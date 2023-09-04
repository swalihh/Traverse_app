import 'package:flutter/material.dart';

class RoundedTopSnackBar extends StatefulWidget {
  final String message;
  final Duration duration;
  final Color backgroundColor;
  final double borderRadius;
  final TextStyle textStyle;

  RoundedTopSnackBar({
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.backgroundColor = Colors.red,
    this.borderRadius = 8.0,
    this.textStyle = const TextStyle(color: Colors.white),
  });

  @override
  _RoundedTopSnackBarState createState() => _RoundedTopSnackBarState();
}

class _RoundedTopSnackBarState extends State<RoundedTopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
    Future.delayed(widget.duration, () {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius),
          ),
        ),
        child: Text(
          widget.message,
          style: widget.textStyle,
        ),
      ),
    );
  }
}
