//
//  UserInfoViewController.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 15/12/28.
//  Copyright © 2015年 FanKing. All rights reserved.
//

#import "SecondBaseViewController.h"
#import "tailorImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UserInfoModel.h"
@interface UserInfoViewController : SecondBaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,NSCoding>
{
    NSMutableArray * titleArr;
    NSMutableArray * contentArr;
}
@property(nonatomic,strong)UITableView * listView;
@property (nonatomic,strong)UIImageView * portraitImageView;
@property(nonatomic,strong)UserInfoModel * userInfoModel;
@end
