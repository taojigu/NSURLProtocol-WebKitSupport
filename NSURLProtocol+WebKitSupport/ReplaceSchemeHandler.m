//
//  ReplaceSchemeHandler.m
//  NSURLProtocol+WebKitSupport
//
//  Created by GuJitao on 15/12/2017.
//  Copyright © 2017 Yeatse. All rights reserved.
//

#import "ReplaceSchemeHandler.h"


@implementation ReplaceSchemeHandler
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask {
    NSURL* url = [self realTargetURL:urlSchemeTask.request.URL];
    //NSData* data = UIImagePNGRepresentation([UIImage imageNamed:@"image"]);
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL MIMEType:@"image/jpeg" expectedContentLength:data.length textEncodingName:nil];
    [urlSchemeTask didReceiveResponse:response];
    [urlSchemeTask didReceiveData:data];
    [urlSchemeTask didFinish];
    
}

/*! @abstract Notifies your app to stop handling a URL scheme handler task.
 @param webView The web view invoking the method.
 @param urlSchemeTask The task that your app should stop handling.
 @discussion After your app is told to stop loading data for a URL scheme handler task
 it must not perform any callbacks for that task.
 An exception will be thrown if any callbacks are made on the URL scheme handler task
 after your app has been told to stop loading for it.
 */
- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask {
    
}

- (NSURL*)realTargetURL:(NSURL *)url{
    NSURL *targetURL = nil;
    if ([url.scheme isEqualToString:@"zhhttp"]) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        components.scheme = @"http";
        targetURL = components.URL;
    } else {
        targetURL = url;
    }
    return targetURL;
}
@end
