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

static DropboxController *sharedInstance = nil; 

+ (void)initialize {
  if (sharedInstance == nil)
    sharedInstance = [[self alloc] init];
}

+ (id)sharedDropboxController {
  //Already set by +initialize.
  return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone {
  //Usually already set by +initialize.
  if (sharedInstance) {
    //The caller expects to receive a new object, so implicitly retain it
    //to balance out the eventual release message.
    return [sharedInstance retain];
  } else {
    //When not already set, +initialize is our caller.
    //It's creating the shared instance, let this go through.
    return [super allocWithZone:zone];
  }
}

- (id)init {
  //If sharedInstance is nil, +initialize is our caller, so initialize the instance.
  //If it is not nil, simply return the instance without re-initializing it.
  if (sharedInstance == nil) {
    self = [super init];
    if (self) {
      if ([[DBSession sharedSession] isLinked]) {
        [[self restClient] loadAccountInfo];
      }
    }
  }
  return self;
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


- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
  self.userId = info.displayName;
}


- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
  //  for (DBMetadata* child in metadata.contents) {
  //    NSLog(child.path);
  //    NSString* extension = [[child.path pathExtension] lowercaseString];
  //    if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
  //      [newPhotoPaths addObject:child.path];
  //    }
  //  }
}


- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
  NSLog(@"Metadata unchanged!");
}


- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
  NSLog(@"Error loading metadata: %@", error);
}


- (void)loginControllerDidLogin:(DBLoginController*)controller {
  [[self restClient] loadAccountInfo];
}


- (void)loginControllerDidCancel:(DBLoginController*)controller {  
}


@end
