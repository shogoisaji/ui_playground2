import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

import 'text_run_view_model.dart';

class TextRunPage extends StackedView<TextRunViewModel> {
  TextRunPage({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget builder(
    BuildContext context,
    TextRunViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 500,
              height: 500,
              child: RiveAnimation.asset(
                'assets/rive/text_run.riv',
                // artboard: 'counter',
                fit: BoxFit.contain,
                onInit: (Artboard artboard) {
                  final controller = StateMachineController.fromArtboard(
                    artboard,
                    'State Machine 1',
                  );

                  controller?.addEventListener(viewModel.onRiveEvent);
                  artboard.addController(controller!);

                  final counterState = artboard.textRun('text1')!;
                  viewModel.setTextState(counterState);
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controller,
                onChanged: (s) {
                  viewModel.updateText(s);
                },
              ),
            ),
            const SizedBox(height: 12),
            // ElevatedButton(
            //   onPressed: () {
            //     viewModel.updateText(_controller.text);
            //   },
            //   child: const Text('Change Text'),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  TextRunViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TextRunViewModel();
}

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}
