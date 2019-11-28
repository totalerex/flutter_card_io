#import "ScanViewController.h"
#import <PayCardsRecognizer/PayCardsRecognizer.h>
#import <UIKit/UIKit.h>

@interface ScanViewController ()<PayCardsRecognizerPlatformDelegate>
@end

@implementation ScanViewController 
    PayCardsRecognizer *recognizer;
    PayCardsRecognizerResult *_recognizerResult;
    BOOL torchON;
    UIColor *torchColor;
    UIBarButtonItem *_goItem;
    UIBarButtonItem *_cancelItem;
    

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
     NSLog(@"viewWillLayoutSubviews");
    if (_goItem == nil) {
        UINavigationBar *_bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
           [self.view addSubview:_bar];
           
           NSString *_cancelTitleTMP = self.cancelTitle ? self.cancelTitle : @"Cancel";
           NSString *_doneTitleTMP = self.doneTitle ? self.doneTitle : @"Done";
           
           UINavigationItem *_title = [[UINavigationItem alloc] initWithTitle:@""];
           _cancelItem = [[UIBarButtonItem alloc] initWithTitle:_cancelTitleTMP style:UIBarButtonItemStylePlain target:self action:@selector(cancelScan:)];
           
           [_title setLeftBarButtonItem:_cancelItem];
        
           _goItem = [[UIBarButtonItem alloc] initWithTitle:_doneTitleTMP style:UIBarButtonItemStylePlain target:self action:@selector(go:)];
           [_goItem setEnabled:NO];
        
        [_cancelItem setTintColor:self.titlesColor];
        [_goItem setTintColor:self.titlesColor];
           
           [_title setRightBarButtonItem:_goItem];
           
           [_bar setItems:@[_title]];
    }
    
   
}

-(void) cancelScan:(UIButton*)sender{
    [self.scanDelegate userDidCancelScanViewController:self];
}

-(void) go:(UIButton*)sender{
    [self.scanDelegate userDidProvideScanCreditCardInfo:_recognizerResult inScanViewController:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    UIView *cardView = [[UIView alloc] initWithFrame:self.view.bounds];
    cardView.backgroundColor=[UIColor blackColor];
    [self.view addSubview: cardView];
    
    recognizer = [[PayCardsRecognizer alloc] initWithDelegate:self resultMode:PayCardsRecognizerResultModeAsync container:cardView frameColor:UIColor.greenColor];
    
    torchColor = self.iconColor ? self.iconColor : UIColor.whiteColor;
    
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *urlBundle = [podBundle URLForResource:@"ScanAssets" withExtension:@"bundle"];
    NSBundle *assetsBundle = [NSBundle bundleWithURL:urlBundle];
    
    UIImage *icon = [[UIImage imageNamed:@"flash_on" inBundle:assetsBundle compatibleWithTraitCollection:nil ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(torchClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:icon forState:UIControlStateNormal];
    [button setTintColor:torchColor];
    button.frame = CGRectMake(self.view.bounds.size.width/2 - 40, self.view.bounds.size.height - 80 - 60, 80, 70);
    [self.view addSubview:button];
}

-(void) torchClicked:(UIButton*)sender
 {
     torchON = !torchON;
     [recognizer turnTorchOn:torchON withValue:0.5];
     
     NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
     NSURL *urlBundle = [podBundle URLForResource:@"ScanAssets" withExtension:@"bundle"];
     NSBundle *assetsBundle = [NSBundle bundleWithURL:urlBundle];
     
     UIImage *icon;
     if (torchON) {
        icon = [[UIImage imageNamed:@"flash_on" inBundle:assetsBundle compatibleWithTraitCollection:nil ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     }else{
        icon = [[UIImage imageNamed:@"flash_off" inBundle:assetsBundle compatibleWithTraitCollection:nil ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     }
     [sender setImage:icon  forState:UIControlStateNormal];
     [sender setTintColor:torchColor];
     
     [recognizer pauseRecognizer];
     [recognizer resumeRecognizer];
     
 }

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [recognizer startCamera];
    torchON = YES;
    [recognizer turnTorchOn:YES withValue:1];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [recognizer turnTorchOn:NO withValue:1];
    [recognizer stopCamera];
}


- (void)payCardsRecognizer:(PayCardsRecognizer * _Nonnull)payCardsRecognizer didRecognize:(PayCardsRecognizerResult * _Nonnull)result {
    NSLog(@"payCardsRecognizer");
    NSLog(@"%@", result.recognizedHolderName);
    NSLog(@"%@", result.recognizedNumber);
    NSLog(@"%@", result.recognizedExpireDateYear);
    NSLog(@"%@", result.recognizedExpireDateMonth);

    _recognizerResult = result;
    [_goItem setEnabled:YES];
}

@end
