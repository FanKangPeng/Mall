//
//  AddAdressViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "AddressModel.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "DistrictModel.h"

@interface AddAdressViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray * titleArr;
    NSMutableDictionary * contentDict;
    
    ProvinceModel * defaultProvince;
    CityModel *defaultCity;
    DistrictModel * defaultDistrict;
    
}
@property (nonatomic ,copy) NSString *saveTxt;
@property (nonatomic,strong)UITableView * addAdressList;
@property (nonatomic,strong)UIButton * addButton;
@property (nonatomic ,strong) NSString * CityString;
@property (nonatomic ,strong) NSString * addressString;
@property (nonatomic ,strong) AddressModel * addressModel;
@property(nonatomic,strong) UIPickerView * mypickerView;
@property(nonatomic,strong) UIView * pickBackView;
@property(nonatomic,strong) UIView * pickView;
@property(nonatomic,copy)NSString * titleStr;

@property (nonatomic ,copy)void (^addAdressBlock)(NSString * adressID);

@end
