//
//  ContactViewController.m
//  UserApp
//
//  Created by prefect on 16/6/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () <UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation ContactViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"联系我们";
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: _webView];

    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"contact" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:html baseURL:baseURL];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
