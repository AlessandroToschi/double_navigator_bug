import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final methodChannel = const MethodChannel('log')
  ..setMethodCallHandler(
    (call) async {
      switch (call.method) {
        case "log":
          print(call.arguments.toString());
      }
    },
  );

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  methodChannel;
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: Builder(builder: (context) {
        return Scaffold(
            body: Center(
                child: TextButton(
          child: const Text('Press me'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const _Widget(),
              ),
            );
          },
        )));
      }),
    );
  }
}

class _Widget extends StatefulWidget {
  const _Widget({Key? key}) : super(key: key);

  @override
  State<_Widget> createState() => _WidgetState();
}

enum PageType { opaque, transparent, none }

class _WidgetState extends State<_Widget> {
  PageType _showSecondPage = PageType.none;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (_, __) => false,
      pages: [
        MaterialPage(
          child: SizedBox.expand(
            child: Column(
              children: [
                const Expanded(
                  child: _UIViewWidget(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text('Push Opaque Route'),
                        onPressed: () {
                          setState(() {
                            _showSecondPage = PageType.opaque;
                          });
                        },
                      ),
                      TextButton(
                        child: const Text('Push Transparent Route'),
                        onPressed: () {
                          setState(() {
                            _showSecondPage = PageType.transparent;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (_showSecondPage != PageType.none)
          () {
            final widget = Builder(builder: (context) {
              return Scaffold(
                body: Center(
                  child: TextButton(
                    child: const Text('Dismiss'),
                    onPressed: () {
                      navigatorKey.currentState!.pop();
                    },
                  ),
                ),
              );
            });
            switch (_showSecondPage) {
              case PageType.opaque:
                return MaterialPage(child: widget);
              case PageType.transparent:
                return _TransparentMaterialPage(child: widget);
              case PageType.none:
                throw '';
            }
          }(),
      ],
    );
  }
}

class _UIViewWidget extends StatefulWidget {
  const _UIViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_UIViewWidget> createState() => _UIViewWidgetState();
}

class _UIViewWidgetState extends State<_UIViewWidget> {
  @override
  void dispose() {
    print('Widget disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const UiKitView(
      viewType: 'test view',
    );
  }
}

class _PageBasedMaterialPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  _PageBasedMaterialPageRoute({
    required _TransparentMaterialPage<T> page,
  })  : assert(page != null),
        super(settings: page);

  _TransparentMaterialPage<T> get _page => settings as _TransparentMaterialPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get opaque => false;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

class _TransparentMaterialPage<T> extends Page<T> {
  /// Creates a material page.
  const _TransparentMaterialPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  })  : assert(child != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(key: key, name: name, arguments: arguments, restorationId: restorationId);

  /// The content to be shown in the [Route] created by this page.
  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedMaterialPageRoute<T>(page: this);
  }
}
