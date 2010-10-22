//
//  StatusBarController.h
//  Hourglass
//
//  Created by Sven A. Schmidt on 06.10.10.
//  Copyright 2010 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusBarController : NSObject {

}

@property (nonatomic, retain) NSArray *toolbarItems;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) UIActivityIndicatorView *progressView;

@end
