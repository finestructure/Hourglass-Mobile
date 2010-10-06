//
//  DropboxController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 05.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DropboxController.h"


@implementation DropboxController

@synthesize userId;
@synthesize restClient;
@synthesize localPath;
@synthesize bgTask;


#pragma mark -
#pragma mark Workers
#pragma mark -


-(void)saveFile {
  if ([[DBSession sharedSession] isLinked]) {
    NSLog(@"Saving file %@...", self.localPath);
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
      [[UIApplication sharedApplication] endBackgroundTask:bgTask];
      bgTask = UIBackgroundTaskInvalid;
    }];
    
    NSString *fullPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"DropboxFileName"];
    NSString *path = [fullPath stringByDeletingLastPathComponent];
    NSString *filename = [fullPath lastPathComponent];
    NSLog(@"path: %@", path);
    NSLog(@"filename: %@", filename);
    [[self restClient] uploadFile:filename toPath:path fromPath:self.localPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFileSavingStarted object:self];
  }
}


-(void)loadFile:(NSString *)fileName {
  if ([[DBSession sharedSession] isLinked]) {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSLog(@"Loading file into: %@", path);
    [[self restClient] loadFile:[@"/" stringByAppendingPathComponent:fileName] intoPath:path];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFileLoadingStarted object:self];
  }
}


-(void)unlink {
  [[DBSession sharedSession] unlink];
  self.restClient = nil;
  self.userId = NSLocalizedString(@"not linked", @"link status");
  [[NSNotificationCenter defaultCenter] postNotificationName:kAccountInfoLoaded object:self];
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
#pragma mark DB delegate methods
#pragma mark -


// save

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath {
  NSLog(@"Uploaded file: %@", destPath);
  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
  bgTask = UIBackgroundTaskInvalid;
  [[NSNotificationCenter defaultCenter] postNotificationName:kFileSaved object:self];
}


- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress 
           forFile:(NSString*)destPath from:(NSString*)srcPath {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:progress] forKey:@"progress"];
  [[NSNotificationCenter defaultCenter] postNotificationName:kFileSaveProgress object:self userInfo:userInfo];
}


- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
  NSLog(@"Error saving file: %@", [error userInfo]);  
  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
  bgTask = UIBackgroundTaskInvalid;
}


// load

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath {
  NSLog(@"Loaded file: %@", destPath);
  self.localPath = destPath;
  [[NSNotificationCenter defaultCenter] postNotificationName:kFileLoaded object:self];
}


- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:progress] forKey:@"progress"];
  [[NSNotificationCenter defaultCenter] postNotificationName:kFileLoadProgress object:self userInfo:userInfo];
}


- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
  NSLog(@"Error loading file: %@", [error userInfo]);
}


// login

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
  self.userId = info.displayName;
  [[NSNotificationCenter defaultCenter] postNotificationName:kAccountInfoLoaded object:self];
}


- (void)loginControllerDidLogin:(DBLoginController*)controller {
  [[self restClient] loadAccountInfo];
}


- (void)loginControllerDidCancel:(DBLoginController*)controller {  
}


#pragma mark -
#pragma mark Singleton code
#pragma mark -


static DropboxController *sharedInstance = nil; 


+ (void)initialize {
  if (sharedInstance == nil) {
    sharedInstance = [[self alloc] init];
  }
}


+ (id)sharedInstance {
  return sharedInstance;
}


+ (id)allocWithZone:(NSZone*)zone {
  if (sharedInstance) {
    return [sharedInstance retain];
  } else {
    return [super allocWithZone:zone];
  }
}


- (id)init {
  if (sharedInstance == nil) {
    self = [super init];
    if (self) {
      if ([[DBSession sharedSession] isLinked]) {
        self.userId = @"Loading...";
        [[self restClient] loadAccountInfo];
      } else {
        self.userId = @"Not linked";
      }

    }
  }
  return self;
}


@end
