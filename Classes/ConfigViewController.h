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
  UILabel *userIdLabel;
  UIButton *loadFileButton;
  DBRestClient* restClient;
}

-(IBAction)linkButtonPressed:(id)sender;
-(IBAction)loadFilePressed:(id)sender;
-(void)linkStatusUIUpdate;
- (DBRestClient*)restClient;


@property (nonatomic, retain) IBOutlet UIButton* linkButton;
@property (nonatomic, retain) IBOutlet UILabel* userIdLabel;
@property (nonatomic, retain) IBOutlet UIButton* loadFileButton;

@end
