//
//  RMAppDelegate.m
//  RMGalleryDemo
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMDemoGalleryViewController.h"

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RMDemoGalleryViewController *rootViewController = [RMDemoGalleryViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.toolbarHidden = NO;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
