//
//  AppDelegate.h
//  LovesLOG
//
//  Created by 樊康鹏 on 15/11/23.
//  Copyright © 2015年 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RongIMKit/RongIMKit.h>
#import "ViewController.h"

static NSString *appKey = @"bca5cfe58563164f68af3a93";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMConnectionStatusDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ViewController *mainViewController;
@property(nonatomic,assign)RCConnectionStatus status;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

