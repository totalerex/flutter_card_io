#import <UIKit/UIKit.h>
#import "ScanViewControllerDelegate.h"

@interface ScanViewController : UIViewController

/// Access to the delegate.
@property(nonatomic, weak, readwrite) id<ScanViewControllerDelegate> scanDelegate;

@property(nonatomic, retain) NSString *cancelTitle;
@property(nonatomic, retain) NSString *doneTitle;
@property(nonatomic, retain) UIColor *iconColor;
@property(nonatomic, retain) UIColor *titlesColor;

@end
