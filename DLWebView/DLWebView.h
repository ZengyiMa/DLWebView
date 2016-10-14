//
//  DLWebView.h
//  DLWebView
//
//  Created by famulei on 14/10/2016.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol DLWebViewDelegate <NSObject>

@optional

// 跳转
// 在加载前时候继续加载
- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType navigationAction:(WKNavigationAction *)navigationAction;
// 收到回应之后是否应该继续加载
- (BOOL)webView:(WKWebView *)webView shouldLoadWhenReceivedResponse:(WKNavigationResponse *)navigationResponse;
// 跳转失败
- (void)webview:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation error:(NSError *)error;
// 重定向
- (void)webView:(WKWebView *)webView didReceiveServerRedirectWithNavigation:(WKNavigation *)navigation;
// 加载的回调
- (void)webView:(WKWebView *)webView didStartLoadWithNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didReceivedContentWithNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishLoadWithNavigation:(WKNavigation *)navigation;
// 读取内容失败
- (void)webview:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation error:(NSError *)error;

// 3D Touch 预览元素
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0));
// 轻按 peek 操作的 UIViewController （如果返回 nil，用，Safari 默认）
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0));
// 重按 pop 弹出的 UIViewController
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0));
@end


@interface DLWebView : WKWebView<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, weak) id <DLWebViewDelegate> delegate;

//允许预览元素(如果不实现代理则使用此字段) 默认为 YES
@property (nonatomic, assign) BOOL shouldPreviewElement API_AVAILABLE(ios(10.0));

//允许 webView 自动处理 target="_blank" 的打开处理 默认是 YES
@property (nonatomic, assign) BOOL allowsOpenTargetIsBlank;

//是否自动检测 openURL 功能 默认是 YES  (需要加入白名单)
@property (nonatomic, assign) BOOL allowsOpenURL;







- (WKNavigation *)loadURL:(NSURL *)url;

@end


NS_ASSUME_NONNULL_END

