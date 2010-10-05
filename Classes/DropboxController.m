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
      self.userId = @"–";
      if ([[DBSession sharedSession] isLinked]) {
        [[self restClient] loadAccountInfo];
      }
    }
  }
  return self;
}


@end
