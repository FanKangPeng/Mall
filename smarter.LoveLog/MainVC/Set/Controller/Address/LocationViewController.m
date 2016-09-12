//
//  LocationViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "LocationViewController.h"
#import "CCLocationManager.h"
#import "AddAdressViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:@"定位" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    
    [self.view addSubview:NavigationView];
    self.cityStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"addressString"];
    
    self.mapView =[[MKMapView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)];
    self.mapView.delegate =self;
    self.mapView.mapType =MKMapTypeStandard;
    [self.view addSubview:self.mapView];
    [self.mapView setBackgroundColor:MJRandomColor];

    if([CLLocationManager locationServicesEnabled])
    {
        
        [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            weakSelf.locationCorrrdinate = locationCorrrdinate;
            [weakSelf.mapView setRegion:MKCoordinateRegionMakeWithDistance(locationCorrrdinate, 400,400) animated:YES];
            
        } withAddress:^(NSString *addressString) {
            
            self.cityStr = [addressString substringFromIndex:2];
            //把地址保存到本地
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addressString"];
            [[NSUserDefaults standardUserDefaults] setObject:self.cityStr forKey:@"addressString"];
            Annotation * annotation = [[Annotation alloc] init];
            annotation.coordinate = weakSelf.locationCorrrdinate;
            annotation.title = addressString;
            
            //把标注点MapLocation 对象添加到地图视图上，一旦该方法被调用，地图视图委托方法mapView：ViewForAnnotation:就会被回调
            [weakSelf.mapView addAnnotation:annotation];
            [weakSelf.mapView selectAnnotation:annotation animated:YES];
            
        }];
    }

    UIButton *  button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"+添加地址" forState:UIControlStateNormal];
    button .frame = CGRectMake(10, kScreenHeight-kNavigationHeight, kScreenWidth-20, kBottomBarHeight);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:NavigationBackgroundColor];
    button.titleLabel.font = DefaultBoldFontSize(20);
    button.layer.cornerRadius=5;
    button.layer.masksToBounds=YES;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}

-(void)buttonClick:(UIButton*)button
{
    if(!self.cityStr)
        self.cityStr=@"";
   if([self.lcNavigationController.childViewControllers[self.lcNavigationController.childViewControllers.count-2] isKindOfClass:[AddAdressViewController class]])
   {
      
       _addAddressVCBlock(self.cityStr);
       [self.lcNavigationController popViewController];
   }
    else
    {
        AddAdressViewController * addressVC =[[AddAdressViewController alloc] init];
        addressVC.CityString = self.cityStr;
        [self.lcNavigationController pushViewController:addressVC];
    }
  
}

- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    // 获得地图标注对象
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    // 设置大头针标注视图为紫色
    annotationView.pinColor = MKPinAnnotationColorRed ;
    // 标注地图时 是否以动画的效果形式显示在地图上
    annotationView.animatesDrop = YES ;
    // 用于标注点上的一些附加信息
    annotationView.canShowCallout = YES ;
    
    return annotationView;
    
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
}
*/

@end
