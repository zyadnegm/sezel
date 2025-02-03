import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Customloading extends StatelessWidget {
  const Customloading({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
          color: Color(0XFFE65B2F),
          size: 200
      ),
    );
  }
}
