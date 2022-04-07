import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final List<Widget> items;
  final void Function({int index}) onChanged;
  final int initialIndex;
  final Color backgroundColor;
  const CustomBottomNav({
    @required this.items,
    @required this.onChanged,
    this.initialIndex = 0,
    this.backgroundColor = Colors.blue,
  });
  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

const movement = 75.0;

class _CustomBottomNavState extends State<CustomBottomNav>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _menuBounceIn;
  Animation _menuBounceOut;
  Animation _circleItemAnim;
  Animation _itemMoveInAnim;
  Animation _itemMoveOutAnim;
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _menuBounceIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.4, curve: Curves.decelerate),
      ),
    );
    _menuBounceOut = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.55, 1, curve: Curves.elasticOut),
      ),
    );
    _circleItemAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.5,
        ),
      ),
    );
    _itemMoveInAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.3,
          0.5,
          curve: Curves.decelerate,
        ),
      ),
    );
    _itemMoveOutAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.65,
          1,
          curve: Curves.elasticOut,
        ),
      ),
    );
    _animationController.forward(from: 1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: Center(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final double currentWidth = (size.width) -
                  movement * _menuBounceIn.value +
                  (movement * _menuBounceOut.value);
              final double itemMovement = (-movement * _itemMoveInAnim.value) +
                  ((movement - kBottomNavigationBarHeight / 3) *
                      _itemMoveOutAnim.value);
              return Container(
                width: currentWidth,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    widget.items.length,
                    (index) {
                      final child = widget.items[index];
                      if (currentIndex == index) {
                        return CustomPaint(
                          foregroundPainter: _CircleCustomPaint(
                            progress: _circleItemAnim.value,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, itemMovement),
                            child: CircleAvatar(
                              backgroundColor: widget.backgroundColor,
                              radius: 30,
                              child: child,
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            widget.onChanged(index: index);
                            setState(() {
                              currentIndex = index;
                            });
                            if (_animationController.status ==
                                AnimationStatus.completed) {
                              _animationController.reset();
                            }
                            _animationController.forward(from: 0);
                          },
                          child: child,
                        );
                      }
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class _CircleCustomPaint extends CustomPainter {
  final double progress;
  const _CircleCustomPaint({@required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 1 && progress != 0) {
      final center = Offset(size.width / 2, size.height / 2);
      final radius = 20.0 * progress;
      final strokeWidth = 10.0 * (1 - progress);
      canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = Colors.black
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
