//
//  DropboxController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 05.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxSDK.h"

static NSString *kAccountInfoLoaded __attribute__ ((unused)) = @"AccountInfoLoaded";
static NSString *kFileLoaded __attribute__ ((unused)) = @"FileLoaded";
static NSString *kFileLoadingStarted __attribute__ ((unused)) = @"FileLoadingStarted";
static NSString *kFileLoadProgress __attribute__ ((unused)) = @"FileLoadProgress";

@interface DropboxController : NSObject<DBLoginControllerDelegate, DBRestClientDelegate> {

}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) DBRestClient *restClient;
@property (nonatomic, retain) NSString *localPath;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

+ (id)sharedInstance;
- (void)loadFile:(NSString *)fileName;
- (void)saveFile;
- (void)unlink;

@end
