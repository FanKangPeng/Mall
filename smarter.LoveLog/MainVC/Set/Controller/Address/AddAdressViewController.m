//
//  AddAdressViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/25.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "AddAdressViewController.h"
#import "LocationViewController.h"
#import "AdressManagerViewController.h"
#import "AddressSignle.h"
#import "AddressTool.h"

@interface AddAdressViewController ()
@property(nonatomic,strong)AddressSignle * addressSignle;
@end

@implementation AddAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * NavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [NavigationView initViewWithTitle:self.titleStr andBack:@"icon_back.png" andRightName:_saveTxt];
    __WEAK_SELF_YLSLIDE
    NavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    NavigationView.CustomNavigationCustomRightBtnBlock=^(UIButton *rightBtn){
        //保存
        [weakSelf button5Click];
    };
    [self.view addSubview:NavigationView];
    self.addressSignle = [AddressSignle sharedInstance];
    titleArr =@[@"收货人姓名:",@"手机号码:",@"所在区域:",@"详细地址:",@"邮政编码:"];
    if(self.addressModel)
        contentDict =[NSMutableDictionary dictionaryWithDictionary:@{@"username":self.addressModel.consignee,@"iphone":self.addressModel.mobile,@"city":[NSString stringWithFormat:@"%@,%@,%@",self.addressModel.province_name,self.addressModel.city_name,self.addressModel.district_name],@"address":self.addressModel.address,@"emailnumber":@"",@"isDefault":self.addressModel.is_default}];
    else
           contentDict =[NSMutableDictionary dictionaryWithDictionary:@{@"username":@"",@"iphone":@"",@"city":@"",@"address":@"",@"emailnumber":@"",@"isDefault":@""}];
    [self.view addSubview:self.addAdressList];
    [self.view addSubview:self.addButton];
    [self getAddressAllData];
//    UITapGestureRecognizer * dismissKeyBoardtap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoardtapClick:)];
//    [self.view addGestureRecognizer:dismissKeyBoardtap];
    // Do any additional setup after loading the view.
}
-(void)getAddressAllData
{
    if (self.addressSignle.provinceArray.count<=0) {
        [AddressTool getallAddress:@"/region" params:nil success:^(id obj) {
            //
            self.addressSignle.provinceArray = obj;
            //设置默认的省市区
            ProvinceModel * model =[self.addressSignle.provinceArray firstObject];
            defaultProvince  = model;
            defaultCity = [CityModel mj_objectWithKeyValues:[model.city firstObject]];
            defaultDistrict  =[DistrictModel mj_objectWithKeyValues:[defaultCity.district firstObject]];
        } failure:^(id obj) {
            if (obj) {
                HUDSHOW([obj objectForKey:@"error_desc"]);
            }
            else
            {
                NSError * err = obj;
                HUDSHOW( [err.userInfo objectForKey:@"NSLocalizedDescription"]);
            }
        }];
    }
    else
    {
        //设置默认的省市区
        ProvinceModel * model =[self.addressSignle.provinceArray firstObject];
        defaultProvince  = model;
        defaultCity = [CityModel mj_objectWithKeyValues:[model.city firstObject]];
        defaultDistrict  =[DistrictModel mj_objectWithKeyValues:[defaultCity.district firstObject]];
    }
    
    
}
#pragma mark --- keyboard
-(void)AddObserverForKeyboard
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGFloat curkeyBoardHeight = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    CGFloat keyHeight =curkeyBoardHeight;
    
    if(keyHeight + 350 >kScreenHeight)
    {
        [UIView  animateWithDuration:1 animations:^{
            self.view.frame=CGRectMake(0,-keyHeight, kScreenWidth, kScreenHeight);
        } completion:^(BOOL finished) {
          
        }];
    }
    
  
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:1 animations:^{
        self.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}
- (void)setSaveTxt:(NSString *)saveTxt
{
    _saveTxt = saveTxt;
}
-(UIButton *)addButton
{
    if(!_addButton)
    {
        
        _addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(10, 350, kScreenWidth-20, 44);
        _addButton.layer.cornerRadius =5;
        _addButton.layer.masksToBounds=YES;
        [_addButton setBackgroundColor:NavigationBackgroundColor];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setTitle:_saveTxt forState:UIControlStateNormal];
        _addButton.titleLabel.font =DefaultFontSize(18);
        [_addButton addTarget:self action:@selector(button5Click) forControlEvents:UIControlEventTouchDown];
        
    }
    return _addButton;
}
-(void)button5Click
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponderView = [keyWindow performSelector:@selector(findFirstResponder)];
    [firstResponderView resignFirstResponder];
    //判断内容
    if([self opinionContent])
    {
        __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.color  =[UIColor clearColor];
        hud.mode= MBProgressHUDModeCustomView;
        hud.customView = [[LoadGIF_M alloc] init];
        [hud show:YES];
        
        
        NSString * idStr = self.addressModel.id ? self.addressModel.id: @"";
        NSDictionary * addressDict= [NSDictionary dictionary];
        NSString * url =@"";
        if(self.addressModel)
        {
             addressDict =@{@"address":@{@"id":idStr,@"consignee":[contentDict objectForKey:@"username"],@"mobile":[contentDict objectForKey:@"iphone"],@"email":@"",@"country":@"1",@"province":defaultProvince.id,@"city":defaultCity.id,@"district":defaultDistrict.id,@"address":[contentDict objectForKey:@"address"],@"zipcode":@"",@"tel":@"",@"sign_building":@"",@"best_time":@"",@"is_default":[contentDict objectForKey:@"isDefault"]},@"id":idStr};
            url=@"/address/update";
        }
        else
        {
            addressDict =@{@"address":@{@"id":idStr,@"consignee":[contentDict objectForKey:@"username"],@"mobile":[contentDict objectForKey:@"iphone"],@"email":@"",@"country":@"1",@"province":defaultProvince.id,@"city":defaultCity.id,@"district":defaultDistrict.id,@"address":[contentDict objectForKey:@"address"],@"zipcode":@"",@"tel":@"",@"sign_building":@"",@"best_time":@"",@"is_default":[contentDict objectForKey:@"isDefault"]}};
            url=@"/address/add";
        }
        
        
        
        [AddressTool addAddress:url params:addressDict success:^(id obj) {
            [hud hide:YES];
         
            HUDSHOW(@"添加地址成功");
           
            [self.lcNavigationController popViewControllerCompletion:^{
                self.addAdressBlock([NSString stringWithFormat:@"%@",[obj objectForKey:@"address_id"]]);
            }];
          
        
        } failure:^(id obj) {
            [hud hide:YES];
            HUDSHOW(@"添加失败");
        }];
    }
}
-(UITableView *)addAdressList
{
    if(!_addAdressList)
    {
        _addAdressList =[[UITableView alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 220) style:UITableViewStylePlain];
        _addAdressList.delegate=self;
        _addAdressList.dataSource=self;
        if([_addAdressList respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_addAdressList setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_addAdressList respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_addAdressList setLayoutMargins:UIEdgeInsetsZero];
        }
        _addAdressList.scrollEnabled =NO;
    }
    return _addAdressList;
}
-(UIView *)pickView
{
    if (!_pickView) {
        _pickView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_pickView setBackgroundColor:[UIColor blackColor]];
        _pickView.alpha=0.3;
    }
    return _pickView;
}
-(UIView *)pickBackView
{
    if (!_pickBackView) {
        _pickBackView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_pickBackView setBackgroundColor:[UIColor clearColor]];
      
        [_pickBackView addSubview:self.mypickerView];
        _mypickerView.sd_layout
        .leftSpaceToView(_pickBackView,0)
        .rightSpaceToView(_pickBackView,0)
        .bottomSpaceToView(_pickBackView,0)
        .heightIs(200);
        
        
        UIView * titleView =[UIView new];
        [titleView setBackgroundColor:FontColor_lightGary];
        [_pickBackView addSubview:titleView];
        titleView.sd_layout
        .leftSpaceToView(_pickBackView,0)
        .rightSpaceToView(_pickBackView,0)
        .bottomSpaceToView(_mypickerView,0)
        .heightIs(40);
        
        UIButton * cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchDown];
        [titleView addSubview:cancelButton];
        cancelButton.sd_layout
        .leftSpaceToView(titleView,0)
        .topSpaceToView(titleView,0)
        .heightIs(40)
        .widthIs(70);
        
        
        UIButton * sureButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:NavigationBackgroundColor forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchDown];
        [titleView addSubview:sureButton];
        sureButton.sd_layout
        .rightSpaceToView(titleView,0)
        .topSpaceToView(titleView,0)
        .heightIs(40)
        .widthIs(70);
        
        
     
    }
    return _pickBackView;
}
-(UIPickerView *)mypickerView
{
    if (!_mypickerView) {
        _mypickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 200)];
        _mypickerView .delegate=self;
        _mypickerView.dataSource =self;
        _mypickerView.userInteractionEnabled=YES;
        [_mypickerView setBackgroundColor:[UIColor whiteColor]];
    }
    return _mypickerView;
}
-(void)cancelButtonClick:(UIButton*)button
{
    [_pickView removeFromSuperview];
    [_pickBackView removeFromSuperview];

}
-(void)sureButtonClick:(UIButton*)button
{
      [_pickView removeFromSuperview];
    [_pickBackView removeFromSuperview];

    self.CityString = [NSString stringWithFormat:@"%@,%@,%@",defaultProvince.name,defaultCity.name,defaultDistrict.name];
    [contentDict setObject: self.CityString forKey:@"city"];
    [self.addAdressList reloadData];
    
}
#pragma mark  tableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell   =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.textColor =FontColor_gary;
    cell.textLabel.font =DefaultFontSize(16);
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode =NSLineBreakByCharWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text =titleArr[indexPath.section];
    
    
    UITextField * textField =[[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-110, 44)];
    textField.borderStyle =UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    textField.font = DefaultFontSize(16);
    textField.textColor = FontColor_gary;
    textField.tag =indexPath.section +200;
    textField.delegate =self;
    
    if (indexPath.section!=2) {
        [cell.contentView addSubview:textField];
        
    }
    
    UILabel * label =[[UILabel alloc] initWithFrame:textField.frame];
    label.textColor = FontColor_gary;
    label.font = DefaultFontSize(16);
    label.textAlignment= NSTextAlignmentLeft;
    
    if(indexPath.section ==2)
    {
    [cell.contentView addSubview:label];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.section) {
        case 0:
            textField.text=[contentDict objectForKey:@"username"];
            break;
        case 1:
            textField.text=[contentDict objectForKey:@"iphone"];
            break;
        case 2:
        {
           label.text=[contentDict objectForKey:@"city"];

        }
            break;
        case 3:
            textField.text=[contentDict objectForKey:@"address"];
            break;
        case 4:
            textField.text=[contentDict objectForKey:@"emailnumber"];
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        [(UITextField*)[tableView viewWithTag:201] resignFirstResponder];
        
//        if(indexPath.section==2)
//        {
//            LocationViewController * locationVC =[[LocationViewController alloc] init];
//            [locationVC addAddressVCBlock:^(NSString * cityStr) {
//                //
//                self.CityString = cityStr;
//              
//            
//                [contentDict removeObjectForKey:@"city"];
//                [contentDict setObject:cityStr forKey:@"city"];
//                [self.addAdressList reloadData];
//            }];
//            
//            [self.lcNavigationController pushViewController:locationVC];
//        }
     if(indexPath.section==2)
     {
         [self.view endEditing:YES];
//         if ([self opinionIphoneAndUsername]) {
//           
//         }
         [self.view addSubview:self.pickView];
         [self.view addSubview:self.pickBackView];
     }
    
   
}
//-(BOOL)opinionIphoneAndUsername
//{
//    
//    for (id key in contentDict.allKeys) {
//        
//        if([key isEqualToString:@"iphone"])
//        {
//            if([[contentDict objectForKey:key] isEqualToString:@""])
//            {
//                HUDSHOW(@"请输入手机号码");
//                return NO;
//            }
//            else if (!IS_USERNAME([contentDict objectForKey:key] ))
//            {
//                HUDSHOW(@"手机号码错误");
//            }
//            
//        }
//        
//        if([key isEqualToString:@"username"])
//        {
//            if([[contentDict objectForKey:key] isEqualToString:@""])
//            {
//                
//                HUDSHOW(@"请输入收货人姓名");
//                return NO;
//            }
//        }
//    }
//    
//    
//    return YES;
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark  picker delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    switch (component) {
        case 0:
        {
            count = self.addressSignle.provinceArray.count;
        }
            break;
        case 1:
        {
            count = defaultProvince.city.count;
        }
            break;
        case 2:
        {
            count = defaultCity.district.count;
        }
            break;
            
        default:
            break;
    }
    
    return count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * titleStr ;
    switch (component) {
        case 0:
        {
            ProvinceModel * model =self.addressSignle.provinceArray[row];
  
            titleStr = model.name;
        }
            break;
        case 1:
        {
            CityModel * model =[CityModel mj_objectWithKeyValues:defaultProvince.city[row]];
            titleStr = model.name;
     
     
        }
            break;
        case 2:
        {
            DistrictModel * model  = [DistrictModel mj_objectWithKeyValues: defaultCity.district[row]];
            titleStr = model.name;
    
        }
            break;
            
        default:
            break;
    }
    
    return titleStr;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            ProvinceModel * model =self.addressSignle.provinceArray[row];
            defaultProvince = model;
            defaultCity =[CityModel mj_objectWithKeyValues:[defaultProvince.city firstObject]];
            defaultDistrict  =[DistrictModel mj_objectWithKeyValues:[defaultCity.district firstObject]];
        }
            break;
        case 1:
        {
            CityModel  * model =[CityModel mj_objectWithKeyValues:defaultProvince.city[row]];
            defaultCity = model;
            defaultDistrict  =[DistrictModel mj_objectWithKeyValues:[defaultCity.district firstObject]];
        }
            break;
        case 2:
        {
            defaultDistrict  =[DistrictModel mj_objectWithKeyValues:defaultCity.district[row]];
        }
            break;
            
        default:
            break;
    }

    [_mypickerView reloadAllComponents];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kScreenWidth/3;
}
#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self changeContentDictWithTextField:textField];
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)opinionContent
{

    for (id key in contentDict.allKeys) {
        
        if([key isEqualToString:@"iphone"])
        {
            if([[contentDict objectForKey:key] isEqualToString:@""])
            {
                HUDSHOW(@"请输入手机号码");
                return NO;
            }
            else if (!IS_USERNAME([contentDict objectForKey:key] ))
            {
                HUDSHOW(@"手机号码错误");
                return NO;
            }
          
        }
        
        if([key isEqualToString:@"username"])
        {
            if([[contentDict objectForKey:key] isEqualToString:@""])
            {
          
                HUDSHOW(@"请输入收货人姓名");
                return NO;
            }
        }
        if([key isEqualToString:@"city"])
        {
            if([[contentDict objectForKey:key] isEqualToString:@""])
            {
                
                HUDSHOW(@"请选择地址");
                return NO;
            }
        }
        if([key isEqualToString:@"address"])
        {
            if([[contentDict objectForKey:key] isEqualToString:@""])
            {
                
                HUDSHOW(@"请输入详细地址");
                return NO;
            }
        }
    }
 
 
    return YES;
}
-(void)changeContentDictWithTextField:(UITextField*)textField
{
    switch (textField.tag) {
        case 200:
        {
       
            [contentDict setObject:textField.text forKey:@"username"];
        }
            break;
        case 201:
        {
        
           
              [contentDict setObject:textField.text forKey:@"iphone"];
         
        }
            break;
            
        case 203:
        {
            
            [contentDict setObject:textField.text forKey:@"address"];
        }
            break;
        case 204:
        {
          
            [contentDict setObject:textField.text forKey:@"emailnumber"];
        }
            break;
            
            
        default:
            break;
    }
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
