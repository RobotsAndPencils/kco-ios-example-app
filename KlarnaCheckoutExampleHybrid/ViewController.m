//
//  ViewController.m
//  KlarnaCheckoutExampleHybrid

#import "ViewController.h"
#import "KlarnaCheckout/KlarnaCheckout.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) KCOKlarnaCheckout *checkout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkout = [[KCOKlarnaCheckout alloc] initWithViewController:self redirectURI:[NSURL URLWithString:@"http://www.google.ca"]];
    
    NSURL *checkoutURL = [NSURL URLWithString:@"https://www.klarnacheckout.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:checkoutURL]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:KCOSignalNotification object:nil];
}

- (void)handleNotification:(NSNotification *)notification {
    NSString *name = notification.userInfo[KCOSignalNameKey];
    NSDictionary *data = notification.userInfo[KCOSignalDataKey];
    
    if ([name isEqualToString:@"complete"]) {
        NSString *uri = [data objectForKey:@"uri"];
        if (uri && [uri isKindOfClass:[NSString class]] && uri.length > 0) {
            NSURL *confirmationURL = [NSURL URLWithString:uri];
            [self.webView loadRequest:[NSURLRequest requestWithURL:confirmationURL]];
        }
    }
}

@end
