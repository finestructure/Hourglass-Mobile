//
//  ConfigViewController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 30.09.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"


@interface ConfigViewController : UIViewController<DBLoginControllerDelegate, DBRestClientDelegate> {
  UIButton *linkButton;
  DBRestClient* restClient;
}

-(IBAction)linkButtonPressed:(id)sender;
-(void)updateButtons;
- (DBRestClient*)restClient;


@property (nonatomic, retain) IBOutlet UIButton* linkButton;

@end
