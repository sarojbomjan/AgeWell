import 'package:flutter/material.dart';

class PulsingMic extends StatefulWidget {
  final bool isListening;

  const PulsingMic({Key? key, required this.isListening}) : super(key: key);

  @override
  _PulsingMicState createState() => _PulsingMicState();
}

class _PulsingMicState extends State<PulsingMic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Create a repeating animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Scale the icon based on the animation value
        double scale = widget.isListening ? 1 + (_controller.value * 0.2) : 1.0;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Icon(
        Icons.mic,
        color: widget.isListening ? Colors.green : Colors.white,
      ),
    );
  }
}
