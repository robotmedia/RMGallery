//
//  RMAppDelegate.m
//  RMGalleryDemo
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMDemoOriginViewController.h"

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RMDemoOriginViewController *rootViewController = [RMDemoOriginViewController new];
    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
