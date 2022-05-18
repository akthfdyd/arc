#import "ArcPlugin.h"
#if __has_include(<arc/arc-Swift.h>)
#import <arc/arc-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "arc-Swift.h"
#endif

@implementation ArcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftArcPlugin registerWithRegistrar:registrar];
}
@end
