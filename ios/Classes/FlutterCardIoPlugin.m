#import "FlutterCardIoPlugin.h"
#import "ScanViewController.h"
#import "ScanViewControllerDelegate.h"
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

@interface FlutterCardIoPlugin ()<ScanViewControllerDelegate>
@end

@implementation FlutterCardIoPlugin {
    FlutterResult _result;
    NSDictionary *_arguments;
    UIViewController *_viewController;
    ScanViewController *_scanViewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_card_io"
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterCardIoPlugin *instance = [[FlutterCardIoPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    
    if ([@"scanCard" isEqualToString:call.method]) {

        _scanViewController = [[ScanViewController alloc] init];
        
        _result = result;
        _arguments = call.arguments;
        
        NSNumber *iconColorNumber = [_arguments objectForKey:@"iconColor"] ? [_arguments objectForKey:@"iconColor"] : 0;
        UIColor *iconColor = UIColorFromRGB(iconColorNumber.intValue);
        
        NSNumber *titleColorNumber = [_arguments objectForKey:@"titlesColor"] ? [_arguments objectForKey:@"titlesColor"] : 0;
        UIColor *titleColor = UIColorFromRGB(titleColorNumber.intValue);

        _scanViewController.cancelTitle =  [_arguments objectForKey:@"cancelTitle"];
        _scanViewController.doneTitle =  [_arguments objectForKey:@"doneTitle"];
        _scanViewController.iconColor =  [_arguments objectForKey:@"iconColor"] ? iconColor : nil;
        _scanViewController.titlesColor = [_arguments objectForKey:@"titlesColor"] ? titleColor : [UIColor redColor];
        _scanViewController.scanDelegate = self;
        
        [_viewController presentViewController:_scanViewController animated:YES completion:nil];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)userDidCancelScanViewController:(ScanViewController *)scanViewController {
    [_scanViewController dismissViewControllerAnimated:YES completion:nil];
    _result([NSNull null]);
    _result = nil;
    _arguments = nil;
}

- (void)userDidProvideScanCreditCardInfo:(PayCardsRecognizerResult *)scanResult inScanViewController:(ScanViewController *)scanViewController {
    [_scanViewController dismissViewControllerAnimated:YES completion:nil];
    _result(@{
       @"cardholderName": scanResult.recognizedHolderName ? scanResult.recognizedHolderName : @"",
        @"cardNumber": scanResult.recognizedNumber ? scanResult.recognizedNumber : @"",
        @"expiryMonth": scanResult.recognizedExpireDateMonth ? scanResult.recognizedExpireDateMonth : @"",
        @"expiryYear": scanResult.recognizedExpireDateYear ? scanResult.recognizedExpireDateYear : @""
    }); 
    _result = nil;
    _arguments = nil;
}

@end
