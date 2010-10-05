//
//  ConfigViewController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 30.09.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountViewController : UIViewController {
}

-(IBAction)linkButtonPressed:(id)sender;
-(void)linkStatusUIUpdate;

@property (nonatomic, retain) IBOutlet UIButton* linkButton;
@property (nonatomic, retain) IBOutlet UILabel* userIdLabel;

@end
