//
//  UserInfoViewController.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/28.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AdressManagerViewController.h"
#import "LocationViewController.h"
#import "AddAdressViewController.h"
#import "MyKeyChainHelper.h"
#import "UserInfoTool.h"
#import "ChanceUserInfoViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (_listView) {
        [self getUserInfo];
    }
}
//更新list的内容信息
-(void)updataContentArr
{
    titleArr=[NSMutableArray arrayWithArray:@[@"我的头像",@"用户名/昵称",@"绑定手机号",@"性别",@"会员等级",@"修改密码",@"收货地址"]];
    contentArr = self.userInfoModel ?[NSMutableArray arrayWithArray:@[@"",self.userInfoModel.name,self.userInfoModel.mobile,self.userInfoModel.sex_name,@"V0初级会员",@"",@""]] :[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@""]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航view
    CustomNavigationView * setNavigationView  =[[CustomNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [setNavigationView initViewWithTitle:@"个人资料" andBack:@"icon_back.png" andRightName:@""];
    __WEAK_SELF_YLSLIDE
    setNavigationView.CustomNavigationLeftImageBlock=^{
        //返回
        [weakSelf.lcNavigationController popViewController];
    };
    [self.view addSubview:setNavigationView];
    
    [self getUserInfo];
    
   
    // Do any additional setup after loading the view.
}
-(void)initView
{
    [self updataContentArr];
    if (!_listView) {
         [self.view addSubview:self.listView];
    }
    else
    {
        [self.listView reloadData];
    }
}
-(void)getUserInfo
{
    [UserInfoTool userInfo:@"/user/info" params:nil success:^(id obj) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:obj];
        [dict setObject:[obj objectForKey:@"user_name"] forKey:@"name"];
        
         self.userInfoModel =[UserInfoModel mj_objectWithKeyValues:dict];
        //更新本地用户信息
        NSMutableData* data = [[NSMutableData alloc]init];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:dict forKey:@"userInfoModel"];
        [archiver finishEncoding];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"userInfoModel"];
        [self initView];
    } failure:^(id obj) {
        HUDSHOW(@"网络貌似挂了！");
//        [MyKeyChainHelper deleteSession:KeyChain_SessionKey];
//         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoModel"];
//        self.userInfoModel = nil;
        
        [self initView];
    }];
}

-(UITableView *)listView
{
    if(!_listView)
    {
        _listView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 370) style:UITableViewStylePlain];
        _listView.delegate =self;
        _listView.dataSource =self;
        if([_listView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_listView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_listView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_listView setLayoutMargins:UIEdgeInsetsZero];
        }
        _listView.scrollEnabled =NO;
    }
    return _listView;
}
-(UIImageView *)portraitImageView
{
    if(!_portraitImageView)
    {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-80,8,44,44)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}
#pragma mark ---tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
    }
    cell.textLabel.text =titleArr[indexPath.row];
    cell.textLabel.textColor= FontColor_gary;
    cell.textLabel.font = DefaultFontSize(15);
    
    cell.detailTextLabel.text= contentArr[indexPath.row];
    cell.detailTextLabel.textColor= FontColor_lightGary;
    cell.detailTextLabel.font = DefaultFontSize(15);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if(indexPath.row==0)
    {
        [cell.contentView addSubview:self.portraitImageView];
        if ([self.userInfoModel.avatar hasPrefix:@"http://"]) {
            [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.avatar]];
        }
        else
            _portraitImageView.image = [UIImage imageNamed:@"userInfo_portrait_icon.jpg"];

    }
    return cell;
}
-(void)buttonClick:(UIButton*)button
{
    if(button.selected)
        button.selected=NO;
    else
        button.selected =YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return 70;
    else
        return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    
    ChanceUserInfoViewController * chanceUserInfoView =[[ChanceUserInfoViewController alloc] init];
    chanceUserInfoView.userInfoModel =self.userInfoModel;
    switch (indexPath.row) {
        case 0:
            //头像
        {
            [self editPortrait];
        }
            
            break;
    
        case 1:
            //昵称
        {
            chanceUserInfoView.titleString=@"修改用户名";
            [self.lcNavigationController pushViewController:chanceUserInfoView];
        }
            break;
        case 2:
            //手机号
        {
            if ([contentArr[2] isEqualToString:@""]) {
                    chanceUserInfoView.titleString=@"绑定手机号";
            }
            else
                chanceUserInfoView.titleString=@"修改绑定手机号";
            [self.lcNavigationController pushViewController:chanceUserInfoView];
        }
            break;
        case 3:
            //性别
        {
            chanceUserInfoView.titleString=@"修改性别";
            [self.lcNavigationController pushViewController:chanceUserInfoView];
        }
            break;
        case 4:
            //会员等级
            break;
        case 5:
            //修改密码
        {
            chanceUserInfoView.titleString=@"修改密码";
            [self.lcNavigationController pushViewController:chanceUserInfoView];
        }
            break;
        case 6:
            //收货地址
              [self.lcNavigationController pushViewController:[[AdressManagerViewController alloc] init]];
            break;
            
        default:
            break;
    }
}
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
-(void)editPortrait
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
  
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        

        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        tailorImageViewController *imgEditorVC = [[tailorImageViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(tailorImageViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //改变头像
    
    //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
    NSData *dataObj = UIImageJPEGRepresentation(editedImage,0.2);
    //   NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if([dataObj length]>0){
        NSString * baseStr = [dataObj base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        __block  MBProgressHUD * hud =[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.color  =[UIColor clearColor];
        hud.mode= MBProgressHUDModeCustomView;
        hud.customView = [[LoadGIF_M alloc] init];
        [hud show:YES];
    
        [UserInfoTool userInfo:@"/user/modify" params:@{@"action":@"avatar",@"avatar":baseStr} success:^(id obj) {
            [hud hide:YES];
       
            //设置本地的头像的数据
            
            [self getUserInfo];
            HUDSHOW(@"上传成功");
            
        } failure:^(id obj) {
             [hud hide:YES];
            HUDSHOW(@"上传失败");
        }];
    }
    
    //
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
   
        

    }];
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
- (void)imageCropperDidCancel:(tailorImageViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
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
