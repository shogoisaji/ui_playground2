import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

import 'text_run_view_model.dart';

class TextRunPage extends StackedView<TextRunViewModel> {
  TextRunPage({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();

  SMITrigger? _start;

  void _hitBump() => _start?.fire();

  @override
  Widget builder(
    BuildContext context,
    TextRunViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // SizedBox(
              //   width: 500,
              //   height: 300,
              //   child: RiveAnimation.asset(
              //     'assets/rive/text_run.riv',
              //     artboard: 'text_animation',
              //     fit: BoxFit.contain,
              //     onInit: (Artboard artboard) {
              //       final controller = StateMachineController.fromArtboard(
              //         artboard,
              //         'State Machine 1',
              //       );
              //       _start = controller?.findInput<bool>('start') as SMITrigger;
              //       controller?.addEventListener(viewModel.onRiveEvent);
              //       artboard.addController(controller!);

              //       final titleState = artboard.textRun('title')!;
              //       final subTitleState = artboard.textRun('subtitle')!;
              //       viewModel.setTitleTextState(titleState);
              //       viewModel.setSubTitleTextState(subTitleState);
              //     },
              //   ),
              // ),
              // SizedBox(
              //   width: 200,
              //   child: TextField(
              //     controller: _titleController,
              //     onChanged: (s) {
              //       viewModel.updateTitleText(s);
              //     },
              //   ),
              // ),
              // const SizedBox(height: 12),
              // SizedBox(
              //   width: 200,
              //   child: TextField(
              //     controller: _subTitleController,
              //     onChanged: (s) {
              //       viewModel.updateSubTitleText(s);
              //     },
              //   ),
              // ),
              // const SizedBox(height: 12),
              // ElevatedButton(
              //   onPressed: () {
              //     _hitBump();
              //   },
              //   child: const Text('Start'),
              // ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Column(
                    children: [
                      ThreadNumberWidget(),
                    ],
                  )),
            ],
          ),
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

class ThreadNumberWidget extends StatefulWidget {
  const ThreadNumberWidget({super.key});

  @override
  State<ThreadNumberWidget> createState() => _ThreadNumberWidgetState();
}

class _ThreadNumberWidgetState extends State<ThreadNumberWidget> {
  SMITrigger? _start;
  SMIInput<double>? _number;

  void _hitBump() => _start?.fire();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: RiveAnimation.asset(
            'assets/rive/text_run.riv',
            artboard: 'number_thread',
            fit: BoxFit.contain,
            onInit: (Artboard artboard) {
              final controller = StateMachineController.fromArtboard(
                artboard,
                'State Machine 1',
              );
              artboard.addController(controller!);
              _start = controller.findInput<bool>('start') as SMITrigger;
              _number = controller.findInput<double>('number') as SMINumber;
              _number?.value = 7;
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...List.generate(
              10,
              (index) => ElevatedButton(
                onPressed: () {
                  _number?.value = index.toDouble();
                },
                child: Text(index.toString()),
              ),
            )
          ],
        ),
        ElevatedButton(
          onPressed: () {
            _hitBump();
          },
          child: const Text('number start'),
        ),
      ],
    );
  }
}
