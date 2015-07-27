//
//  LandmarksTableViewController.h
//  LandMarker
//
//  Created by David Lathrop on 4/27/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface LandmarksTableViewController : UITableViewController <PFLogInViewControllerDelegate> {
    
    PFUser * currentUser;
    
    NSArray * landmarks;
    
}

@end
