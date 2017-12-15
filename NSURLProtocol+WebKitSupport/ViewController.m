//
//  ViewController.m
//  NSURLProtocol+WebKitSupport
//
//  Created by yeatse on 2016/10/11.
//  Copyright © 2016年 Yeatse. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "ReplaceSchemeHandler.h"

@interface ViewController ()<WKNavigationDelegate, UIWebViewDelegate>

@property (nonatomic) __kindof UIView* webView;
@property (nonatomic)WKWebView* wkWebView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadWKWebViewShemeTask];
}

-(void)loadCustomProtocolIntercept {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    NSURLRequest* request163 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.163.com"]];
    NSURLRequest* articleRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.zhihu.com/appview/p/31340026"]];
    NSURLRequest *lzrDemoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.13.52.244:8080"]];
    
    //[(WKWebView *)self.webView loadRequest:lzrDemoRequest];
    NSURLRequest* imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"zhhttp://10.13.52.244:8080/image.jpg"]];
    NSData *data = [NSData dataWithContentsOfURL:lzrDemoRequest.URL];
    [(WKWebView *)self.webView loadData:data MIMEType:nil characterEncodingName:nil baseURL:nil];
}


-(void)loadWKWebViewShemeTask {
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"htm"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    [configuration setURLSchemeHandler:[ReplaceSchemeHandler new] forURLScheme: @"zhhttp"];
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:self.wkWebView];
    
    [self.wkWebView loadData:data MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSSet* types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]]) {
            self.title = result;
        }
    }];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - Getters

- (UIView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if ([_webView respondsToSelector:@selector(setNavigationDelegate:)]) {
            [_webView setNavigationDelegate:self];
        }
        
        if ([_webView respondsToSelector:@selector(setDelegate:)]) {
            [_webView setDelegate:self];
        }
    }
    return _webView;
}


@end
