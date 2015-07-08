//
//  LandmarkViewController.m
//  LandMarker
//
//  Created by David Lathrop on 4/28/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import "LandmarkViewController.h"

#import "LM_TypeSelect_CollectionViewController.h"

@interface LandmarkViewController ()

@end

@implementation LandmarkViewController

@synthesize gpsAccuracyLabel, gpsAltitudeLabel, gpsCoordsLabel, gpsSpeedCourseLabel, nameField;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(locationUpdateNotif:)name:@"LOCATION_UPDATED_NOTIF"  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    // LM_TypeSelect_TableViewController
}
*/


-(void) locationUpdateNotif:(NSNotification*) notif {
    
    lastLocation = (CLLocation *) notif.object;
    
    NSLog(@"%@", lastLocation.description);
    
    CLLocationCoordinate2D coordinate = lastLocation.coordinate;
    CLLocationAccuracy horizontalAccuracy = lastLocation.horizontalAccuracy;
    CLLocationAccuracy verticalAccuracy = lastLocation.verticalAccuracy;
    NSDate* timestamp = lastLocation.timestamp;
    CLLocationSpeed speed = lastLocation.speed;
    CLLocationDirection course = lastLocation.course;
    CLLocationDistance altitude = lastLocation.altitude;
    
    CLLocationDegrees latitude = coordinate.latitude;
    CLLocationDegrees longitude = coordinate.longitude;
    
    NSNumber * latitudeN = [NSNumber numberWithDouble: latitude];
    NSNumber * longitudeN = [NSNumber numberWithDouble: longitude];
    NSNumber * horizontalAccuracyN = [NSNumber numberWithDouble: horizontalAccuracy];
    NSNumber * verticalAccuracyN = [NSNumber numberWithDouble: verticalAccuracy];
    NSNumber * speedN = [NSNumber numberWithDouble: speed];
    NSNumber * courseN = [NSNumber numberWithDouble: course];
    NSNumber * altitudeN = [NSNumber numberWithDouble: altitude];
    
    gpsCoordsLabel.text = [NSString stringWithFormat:@"latitude = %4.6f - longitude = %4.6f", latitudeN.floatValue, longitudeN.floatValue];
    gpsAccuracyLabel.text = [NSString stringWithFormat:@"h Acc = %4.6f - v Acc = %4.6f", horizontalAccuracyN.floatValue, verticalAccuracyN.floatValue];
    gpsAltitudeLabel.text = [NSString stringWithFormat:@"altitude = %4.6f", altitudeN.floatValue];
    gpsSpeedCourseLabel.text = [NSString stringWithFormat:@"speed = %4.6f - course = %4.6f", speedN.floatValue, courseN.floatValue];
    
}

-(IBAction) setLandmarkAction:(id)sender {
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithObject:[nameField text] forKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddLandmarkNotification" object:lastLocation userInfo:dictionary];
    
}

@end
