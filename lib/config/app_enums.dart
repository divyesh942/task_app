import 'package:todo_design/config/app_string.dart';

enum Priorities {
  high(AppString.high),
  medium(AppString.medium),
  low(AppString.low),
  veryLow(AppString.veryLow);

  const Priorities(this.title);
  final String title;
}
