import Flutter
import UIKit
import CoreBluetooth

public class SwiftBluetoothEnablePlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var lastKnownState: CBManagerState!
    var flutterResult: FlutterResult!
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        lastKnownState = central.state;
        print("central.state is " + _getStateString(state: lastKnownState));
        
        if (lastKnownState == .poweredOn){
            flutterResult("true")
        } else {
            flutterResult("false")
        }
    }
    
    private func _getStateString(state: CBManagerState) -> String {
        switch (state) {
        case .unknown:
            return ".unknown";
        case .resetting:
            return ".resetting";
        case .unsupported:
            return ".unsupported";
        case .unauthorized:
            return ".unauthorized";
        case .poweredOff:
            return ".poweredOff";
        case .poweredOn:
            return ".poweredOn";
        @unknown default:
            return "";
        }
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bluetooth_enable", binaryMessenger: registrar.messenger())
    let instance = SwiftBluetoothEnablePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method) {
      case "enableBluetooth":
          if(centralManager == nil) {
              centralManager = CBCentralManager(delegate: self, queue: nil)
          }
          if (flutterResult != nil && lastKnownState == .poweredOn) {
              result("true")
          } else if (lastKnownState != .poweredOn) {
              result("false")
          }
          break;
      default:
          print("Unsupported method: " + call.method)
          break;
      }
      
      flutterResult = result;
  }
}
