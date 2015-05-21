//
//  AppDelegate+notification.m
//  HelloWorld
//
//  Created by SongFong on 5/20/15.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate+notification.h"

#import "MainViewController.h"

#import <Cordova/CDVPlugin.h>
#import <Parse/Parse.h>

@implementation AppDelegate (notification)

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // *********
    // *** Copied from original copy didFinishLaunchingWithOptions - from Cordova
    // *********
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
#if __has_feature(objc_arc)
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;
    
#if __has_feature(objc_arc)
    self.viewController = [[MainViewController alloc] init];
#else
    self.viewController = [[[MainViewController alloc] init] autorelease];
#endif
    
    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"index.html";
    
    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    
    // *********
    // *** Start parse things:
    // *********
    [Parse setApplicationId:@"<your id>"
                  clientKey:@"<your key>"];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void) application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSLog(@"current device token desc: %@", deviceToken.description);
    NSLog(@"current device token: %@", deviceToken);
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
