import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class TextRunViewModel extends BaseViewModel {
  late TextValueRun _text;

  final String _textRun = '';

  void setTextState(TextValueRun t) {
    _text = t;
  }

  void onRiveEvent(RiveEvent event) {
    _text.text = _textRun;
  }

  void updateText(String s) {
    _text.text = s;
  }
  // void updateText(String s) {
  //   _textRun = s;
  // }
}
