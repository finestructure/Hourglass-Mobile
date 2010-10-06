//
//  StatusBarController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 06.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusBarController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UILabel* statusLabel;
@property (nonatomic, retain) IBOutlet UIView* statusButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* progressView;

@end
