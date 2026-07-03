import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color,
    this.size,
  });
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? const Color.fromARGB(255, 37, 48, 255),
      size: size ?? 50,
    );
  }
}
