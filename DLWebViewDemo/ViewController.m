//
//  ViewController.m
//  DLWebViewDemo
//
//  Created by famulei on 14/10/2016.
//
//

#import "ViewController.h"
#import "DLWebView.h"

@interface ViewController ()<DLWebViewDelegate>
@property (nonatomic, strong) DLWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [[DLWebView alloc]initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    [self.webView loadURL:[NSURL URLWithString:@"https://www.baidu.com"]];

    [self.webView callScriptWithName:@"alert" data:@{@"1":@"2"} completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"error = %@", error);
    }];
    
}


- (BOOL)webView:(WKWebView *)webView shouldLoadWhenReceivedResponse:(WKNavigationResponse *)navigationResponse
{
    return YES;
}

- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType navigationAction:(WKNavigationAction *)navigationAction
{
    return YES;
}


- (void)webView:(WKWebView *)webView didStartLoadWithNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStartLoadWithNavigation");
}

- (void)webView:(WKWebView *)webView didReceivedContentWithNavigation:(WKNavigation *)navigation
{
    NSLog(@"didReceivedContentWithNavigation");

}

- (void)webView:(WKWebView *)webView didFinishLoadWithNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinishLoadWithNavigation");
}


- (void)webview:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation error:(NSError *)error
{
    NSLog(@"didFailNavigation = %@", error);
}

- (void)webview:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation error:(NSError *)error
{
    NSLog(@"didFailProvisionalNavigation = %@", error);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectWithNavigation:(WKNavigation *)navigation
{
    NSLog(@"重定向");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

