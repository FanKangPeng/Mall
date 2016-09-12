//
//  LocationViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface LocationViewController : SecondBaseViewController<MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property(nonatomic,assign)CLLocationCoordinate2D locationCorrrdinate ;
@property (nonatomic,strong)NSString * cityStr;
@property(nonatomic,copy)void(^addAddressVCBlock)(NSString * cityStr);

@end
