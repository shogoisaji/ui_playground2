import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class TextRunViewModel extends BaseViewModel {
  late TextValueRun _titleText;
  late TextValueRun _subTitleText;

  // final String _titleTextRun = '';
  // final String _subTitleTextRun = '';

  // void setTitleState(TextValueRun t) {
  //   _titleTextRun.text = t;
  // }
  void setTitleTextState(TextValueRun t) {
    _titleText = t;
  }

  void setSubTitleTextState(TextValueRun t) {
    _subTitleText = t;
  }

  void onRiveEvent(RiveEvent event) {
    // _text.text = _textRun;
  }

  void updateTitleText(String s) {
    _titleText.text = s;
  }

  void updateSubTitleText(String s) {
    _subTitleText.text = s;
  }
  // void updateText(String s) {
  //   _textRun = s;
  // }
}
