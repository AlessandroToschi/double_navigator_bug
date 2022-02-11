import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      let registrar = self.registrar(forPlugin: "test_plugin")!
      let messenger = registrar.messenger()
      registrar.register(TestViewFactory(messenger: messenger, methodChannel: FlutterMethodChannel(name: "log", binaryMessenger: messenger)), withId: "test view")
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


class TestViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    private var methodChannel: FlutterMethodChannel
    
    init(messenger: FlutterBinaryMessenger, methodChannel: FlutterMethodChannel) {
        self.messenger = messenger
        self.methodChannel = methodChannel
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return TestView(viewID: viewId, methodChannel: self.methodChannel)
    }
}

class TestView: NSObject, FlutterPlatformView {
    
    private var methodChannel: FlutterMethodChannel
    private var viewID: Int64
    
    init(viewID: Int64, methodChannel: FlutterMethodChannel) {
        self.viewID = viewID
        self.methodChannel = methodChannel
        super.init()
        methodChannel.invokeMethod("log", arguments: "TEST VIEW INIT ID \(self.viewID)")
    }
    
    func view() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.green
        return view
    }
    
    deinit {
        methodChannel.invokeMethod("log", arguments: "TEST VIEW DEINIT ID \(self.viewID)")
    }
    
}
