//
//  ConfigViewController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 30.09.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ConfigViewController.h"


@implementation ConfigViewController

@synthesize linkButton;
@synthesize userIdLabel;
@synthesize loadFileButton;

#pragma mark -
#pragma mark Workers
#pragma mark -


-(IBAction)linkButtonPressed:(id)sender {
  if (![[DBSession sharedSession] isLinked]) {
    DBLoginController* controller = [[DBLoginController new] autorelease];
    controller.delegate = self;
    [controller presentFromController:self];
  } else {
    [[DBSession sharedSession] unlink];
    [[[[UIAlertView alloc] 
       initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
    [self linkStatusUIUpdate];
  }
}


-(IBAction)loadFilePressed:(id)sender {
  //[[self restClient] loadMetadata:@"/"];
  NSString *fileName = @"Test.hglass";
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
  [[self restClient] loadFile:[@"/" stringByAppendingPathComponent:fileName] intoPath:path];
}


- (void)linkStatusUIUpdate {
  if ([[DBSession sharedSession] isLinked]) {
    [linkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
    self.loadFileButton.enabled = YES;
  } else {
    [linkButton setTitle:@"Link Dropbox" forState:UIControlStateNormal];
    self.loadFileButton.enabled = NO;
  }
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
#pragma mark Lifecycle
#pragma mark -


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.userIdLabel.text = @"";
  
  if ([[DBSession sharedSession] isLinked]) {
    [[self restClient] loadAccountInfo];
  }
  
  [self linkStatusUIUpdate];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark DBLoginControllerDelegate methods
#pragma mark -


- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
  self.userIdLabel.text = [NSString stringWithFormat:@"Linked to %@", [info displayName]];
}


- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
  for (DBMetadata* child in metadata.contents) {
    NSLog(child.path);
//    NSString* extension = [[child.path pathExtension] lowercaseString];
//    if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
//      [newPhotoPaths addObject:child.path];
//    }
  }
}


- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
  NSLog(@"Metadata unchanged!");
}


- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
  NSLog(@"Error loading metadata: %@", error);
}


- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath {
  NSLog(@"Loaded file: %@", destPath);
}


- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
  NSLog(@"Error loading file: %@", [error userInfo]);
}


#pragma mark -
#pragma mark DBLoginControllerDelegate methods
#pragma mark -


- (void)loginControllerDidLogin:(DBLoginController*)controller {
  [self linkStatusUIUpdate];
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {  
}

@end
