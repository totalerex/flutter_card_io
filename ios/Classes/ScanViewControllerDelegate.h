#import <Foundation/Foundation.h>
#import <PayCardsRecognizer/PayCardsRecognizer.h>

@class ScanViewController;


@protocol ScanViewControllerDelegate<NSObject>

@required

- (void)userDidCancelScanViewController:(ScanViewController *)scanViewController;

- (void)userDidProvideScanCreditCardInfo:(PayCardsRecognizerResult *)scanResult inScanViewController:(ScanViewController *)scanViewController;

@end
