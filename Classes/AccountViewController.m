//
//  ConfigViewController.m
//  Hourglass
//
//  Created by Sven A. Schmidt on 30.09.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AccountViewController.h"
#import "DropboxController.h"
#import "DropboxSDK.h"


@implementation AccountViewController

@synthesize linkButton;
@synthesize userIdLabel;


#pragma mark -
#pragma mark Workers
#pragma mark -


-(IBAction)linkButtonPressed:(id)sender {
  if (![[DBSession sharedSession] isLinked]) {
    DBLoginController* controller = [[DBLoginController new] autorelease];
    controller.delegate = [DropboxController sharedInstance];
    [controller presentFromController:self];
  } else {
    [[DropboxController sharedInstance] unlink];
    [[[[UIAlertView alloc] 
       initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
    [self linkStatusUIUpdate];
  }
}


- (void)linkStatusUIUpdate {
  self.userIdLabel.text = [[DropboxController sharedInstance] userId];
  if ([[DBSession sharedSession] isLinked]) {
    [linkButton setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
  } else {
    [linkButton setTitle:@"Link Dropbox" forState:UIControlStateNormal];
  }
}  


-(void)accountInfoLoaded:(NSNotification *)notification {
  [self linkStatusUIUpdate];
}


#pragma mark -
#pragma mark Lifecycle
#pragma mark -


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(accountInfoLoaded:)
                                               name:kAccountInfoLoaded object:nil];
  self.userIdLabel.text = [[DropboxController sharedInstance] userId];
  
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


@end
