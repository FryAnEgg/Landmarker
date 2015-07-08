//
//  LandmarkViewController.h
//  LandMarker
//
//  Created by David Lathrop on 4/28/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>

@interface LandmarkViewController : UIViewController {
   
    CLLocation * lastLocation;
    
}

@property (nonatomic,strong) IBOutlet UILabel * gpsCoordsLabel;
@property (nonatomic,strong) IBOutlet UILabel * gpsAccuracyLabel;
@property (nonatomic,strong) IBOutlet UILabel * gpsAltitudeLabel;
@property (nonatomic,strong) IBOutlet UILabel * gpsSpeedCourseLabel;

@property (nonatomic, strong) IBOutlet UITextField * nameField;


@end
