//
//  HourglassAppDelegate.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 29.09.10.
//  Copyright (c) 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "HourglassAppDelegate.h"
#import "SettingsTableViewController.h"


@implementation HourglassAppDelegate


@synthesize window;
@synthesize tabBarController;
@synthesize navController;
@synthesize taskViewController;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize restClient;
@synthesize storePath;
@synthesize bgTask;


#pragma mark -
#pragma mark Workers
#pragma mark -


-(NSString *)loadFile:(NSString *)fileName {
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
  NSLog(@"Loading file into: %@", path);
  [[self restClient] loadFile:[@"/" stringByAppendingPathComponent:fileName] intoPath:path];
  return path;
}


-(void)saveFile {
  NSLog(@"Saving file %@...", self.storePath);
  bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
  }];
  
  [[self restClient] uploadFile:@"Test2.sqlite" toPath:@"/" fromPath:self.storePath];
}


- (DBRestClient*)restClient {
  if (!restClient) {
    restClient = 
    [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
  }
  return restClient;
}


#pragma mark -
#pragma mark Application Lifecycle
#pragma mark -


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  DBSession* session = [[[DBSession alloc] initWithConsumerKey:@"5ok44aa1gyt0fz6" 
                                                consumerSecret:@"o56xnltj8jglls3"] 
                        autorelease];
  session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
  [DBSession setSharedSession:session];
  
  // load DB file
  NSString *fileName = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
  if (fileName != nil) {
    if ([[DBSession sharedSession] isLinked]) {
      [self loadFile:fileName];
    }
  } else {
    if ([[DBSession sharedSession] isLinked]) {
      // show file list on DB
    } else {
      // go to link account
    }
  }
  
  // set up controller maze
  self.tabBarController = [[[UITabBarController alloc] init] autorelease];
  self.taskViewController = [[[TaskViewController alloc] init] autorelease];
  self.taskViewController.tabBarItem.image = [UIImage imageNamed:@"tasks.png"];
  self.taskViewController.title = NSLocalizedString(@"Tasks", @"Task tab bar item title");
  self.navController = [[[UINavigationController alloc] initWithRootViewController:self.taskViewController] autorelease];
  
  SettingsTableViewController *tv = [[[SettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
  UINavigationController *settingsController = [[[UINavigationController alloc] initWithRootViewController:tv] autorelease];
  settingsController.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
  settingsController.title = NSLocalizedString(@"Settings", @"Settings tab bar item title");
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:navController, settingsController, nil];
  
  [window addSubview:self.tabBarController.view];
  
  [window makeKeyAndVisible];
  return YES;
}


-(void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"applicationDidEnterBackground");

  if ([[DBSession sharedSession] isLinked]) {
    [self saveFile];
  }
}


- (void)applicationWillTerminate:(UIApplication *)application {
  
  // Saves changes in the application's managed object context before the application terminates.
  NSError *error = nil;
  if (managedObjectContext) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}


- (void)dealloc {
  self.taskViewController = nil;
  self.managedObjectContext = nil;
  self.managedObjectModel = nil;
  self.persistentStoreCoordinator = nil;
  self.restClient = nil;
  self.storePath = nil;
  self.window = nil;
  self.tabBarController = nil;
  self.navController = nil;
  
  [super dealloc];
}


#pragma mark -
#pragma mark Core Data Methods
#pragma mark -


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext) {
    return managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator) {
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (managedObjectModel) {
    return managedObjectModel;
  }
  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
  return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (persistentStoreCoordinator) {
    return persistentStoreCoordinator;
  }
  
  //NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Hourglass.sqlite"];
  NSURL *storeUrl = [NSURL fileURLWithPath:self.storePath];
  
  NSError *error = nil;
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible
     * The schema for the persistent store is incompatible with current managed object model
     Check the error message to determine what the actual problem was.
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory
#pragma mark -


/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark DB delegate methods
#pragma mark -


// load

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath {
  //NSLog(@"Loaded file: %@", destPath);
  self.storePath = destPath;
  self.taskViewController.managedObjectContext = [self managedObjectContext];
  [self.taskViewController fetchEntities];
}


- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath {
  //NSLog(@"Load progress: %.2f", progress);
}


- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
  NSLog(@"Error loading file: %@", [error userInfo]);
}


// save

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath {
  NSLog(@"Uploaded file: %@", destPath);
  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
  bgTask = UIBackgroundTaskInvalid;
}


- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress 
           forFile:(NSString*)destPath from:(NSString*)srcPath {
  NSLog(@"Upload progress: %.2f", progress);
}


- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
  NSLog(@"Error saving file: %@", [error userInfo]);  
  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
  bgTask = UIBackgroundTaskInvalid;
}


// session

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
  DBLoginController* loginController = [[DBLoginController new] autorelease];
  [loginController presentFromController:self.tabBarController];
}


@end
