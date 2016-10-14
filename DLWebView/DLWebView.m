//
//  DLWebView.m
//  DLWebView
//
//  Created by famulei on 14/10/2016.
//
//

#import "DLWebView.h"

@implementation DLWebView


- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    WKWebViewConfiguration *webViewConfiguration = configuration;
    
    if (!webViewConfiguration) {
        webViewConfiguration = [WKWebViewConfiguration new];
    }
    
    webViewConfiguration.userContentController = [WKUserContentController new];
    
    
    self = [super initWithFrame:frame configuration:webViewConfiguration];
    if (self) {
        
        
        
        
        self.UIDelegate = self;
        self.navigationDelegate = self;
        self.shouldPreviewElement = YES;
        self.allowsOpenTargetIsBlank = YES;
        self.allowsOpenURL = YES;
    }
    return self;
}


- (WKNavigation *)loadURL:(NSURL *)url
{
   return [self loadRequest:[NSURLRequest requestWithURL:url]];
}



- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark - NavigationDelegate
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:navigationAction:)]) {
        BOOL allow = [self.delegate webView:webView shouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType navigationAction:navigationAction];
        if (!allow) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    NSURL *url = navigationAction.request.URL;
    if (!self.allowsOpenURL || [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application canOpenURL:url]) {
        // 可以打开的连接
#ifdef __IPHONE_10_0
        [application openURL:url options:@{} completionHandler:nil];
#else
        [application openURL:url]
#endif
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}




// 在收到回应之后时候是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if ([self.delegate respondsToSelector:@selector(webView:shouldLoadWhenReceivedResponse:)]) {
        BOOL allow = [self.delegate webView:webView shouldLoadWhenReceivedResponse:navigationResponse];
        if (!allow) {
            decisionHandler(WKNavigationResponsePolicyCancel);
            return;
        }
    }
    
    NSURL *url = navigationResponse.response.URL;
    if (!self.allowsOpenURL || [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
        return;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:url]) {
        // 可以打开的连接
#ifdef __IPHONE_10_0
        [application openURL:url options:@{} completionHandler:nil];
#else
        [application openURL:url]
#endif
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}



////鉴定权限
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
//{
//    
//}
//
//// webview 处理内容被中断
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
//{
//    
//}
//
//
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didStartLoadWithNavigation:)]) {
        [self.delegate webView:self didStartLoadWithNavigation:navigation];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didReceivedContentWithNavigation:)]) {
        [self.delegate webView:self didReceivedContentWithNavigation:navigation];
    }
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didFinishLoadWithNavigation:)]) {
        [self.delegate webView:self didFinishLoadWithNavigation:navigation];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webview:didFailProvisionalNavigation:error:)]) {
        [self.delegate webview:self didFailProvisionalNavigation:navigation error:error];
    }
}

// 跳转出错
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webview:didFailNavigation:error:)]) {
        [self.delegate webview:self didFailNavigation:navigation error:error];
    }
}

// 处理重跳转
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webView:didReceiveServerRedirectWithNavigation:)]) {
        [self.delegate webView:self didReceiveServerRedirectWithNavigation:navigation];
    }
}


#pragma mark - UIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [[self viewController] presentViewController:alertController animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [[self viewController] presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [[self viewController] presentViewController:alertController animated:YES completion:^{}];
}



- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (self.allowsOpenTargetIsBlank) {
        if (!navigationAction.targetFrame.isMainFrame) {
            [webView loadRequest:navigationAction.request];
        }
        return nil;
    }
    return nil;
}


- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    
}

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0))
{
    if([self.delegate respondsToSelector:@selector(webView:shouldPreviewElement:)])
    {
        BOOL preview = [self.delegate webView:self shouldPreviewElement:elementInfo];
        return preview;
    }
    else
    {
        return self.shouldPreviewElement;
    }
    
    return YES;
}

- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0))
{
    if([self.delegate respondsToSelector:@selector(webView:previewingViewControllerForElement:defaultActions:)])
    {
       return [self.delegate webView:self previewingViewControllerForElement:elementInfo defaultActions:previewActions];
    }
    return nil;
}


- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0));
{
    if([self.delegate respondsToSelector:@selector(webView:commitPreviewingViewController:)])
    {
        [self.delegate webView:self commitPreviewingViewController:previewingViewController];
    }
}


@end
