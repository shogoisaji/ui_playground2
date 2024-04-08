import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

const kDefaultArcheryTriggerOffset = 100.0;

class RivePullToRefreshPage extends StatefulWidget {
  const RivePullToRefreshPage({super.key});

  @override
  State<RivePullToRefreshPage> createState() => _RivePullToRefreshPageState();
}

class _RivePullToRefreshPageState extends State<RivePullToRefreshPage> {
  late EasyRefreshController _controller;
  int _count = 3;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      body: SafeArea(
        child: EasyRefresh(
          controller: _controller,
          header: const ArcheryHeader(
            position: IndicatorPosition.locator,
            processedDuration: Duration(seconds: 1),
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            if (!mounted) {
              return;
            }
            setState(() {
              _count = 30;
            });
            _controller.finishRefresh();
            _controller.resetFooter();
          },
          child: CustomScrollView(
            slivers: [
              // SliverAppBar(
              //   backgroundColor: Colors.blueGrey.shade500,
              //   pinned: true,
              // ),
              const HeaderLocator.sliver(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Card(
                        child: ListTile(
                      title: Text('title $index'),
                      subtitle: const Text('subtitle'),
                      leading: const Icon(Icons.account_circle),
                      trailing: const Icon(Icons.push_pin),
                    ));
                  },
                  childCount: _count,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArcheryHeader extends Header {
  const ArcheryHeader({
    super.clamping = false,
    super.triggerOffset = kDefaultArcheryTriggerOffset,
    super.position = IndicatorPosition.above,
    super.processedDuration = Duration.zero,
    super.springRebound = false,
    super.hapticFeedback = false,
    super.safeArea = false,
    super.spring,
    super.readySpringBuilder,
    super.frictionFactor,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _ArcheryIndicator(
      state: state,
      reverse: state.reverse,
    );
  }
}

class _ArcheryIndicator extends StatefulWidget {
  /// Indicator properties and state.
  final IndicatorState state;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  const _ArcheryIndicator({
    super.key,
    required this.state,
    required this.reverse,
  });

  @override
  State<_ArcheryIndicator> createState() => _ArcheryIndicatorState();
}

class _ArcheryIndicatorState extends State<_ArcheryIndicator> {
  double get _offset => widget.state.offset;
  IndicatorMode get _mode => widget.state.mode;
  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  SMINumber? pull;
  SMITrigger? trigger;
  StateMachineController? controller;

  @override
  void initState() {
    super.initState();
    widget.state.notifier.addModeChangeListener(_onModeChange);
    // _loadRiveFile();
  }

  @override
  void dispose() {
    widget.state.notifier.removeModeChangeListener(_onModeChange);
    controller?.dispose();
    // _riveFile = null;
    super.dispose();
  }

  /// Mode change listener.
  void _onModeChange(IndicatorMode mode, double offset) {
    // print(mode);
    switch (mode) {
      case IndicatorMode.drag:
        controller?.isActive = true;
      case IndicatorMode.ready:
        trigger?.fire();
      case IndicatorMode.processed:
        trigger?.fire();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == IndicatorMode.drag || _mode == IndicatorMode.armed) {
      final percentage = (_offset / _actualTriggerOffset).clamp(0.0, 1.1) * 100;
      pull?.value = percentage;
    }
    return SizedBox(
      width: double.infinity,
      height: _offset > 150 ? 150 : _offset,
      child: (_offset > 0)
          ? Container(
              width: double.infinity,
              color: const Color(0xFF312D48),
              child: RiveAnimation.asset(
                'assets/rive/pull_refresh.riv',
                fit: BoxFit.contain,
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
                  controller?.isActive = false;
                  if (controller == null) {
                    throw Exception('Unable to initialize state machine controller');
                  }
                  artboard.addController(controller!);
                  pull = controller!.findInput<double>('pull') as SMINumber;
                  trigger = controller!.findInput<bool>('trigger') as SMITrigger;
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
