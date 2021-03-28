//
//  ViewController.m
//  IMSDKDEMO
//
//  Created by edz on 2021/3/16.
//

#import "ViewController.h"
#import <V2TIMManager.h>
#import <TIMComm.h>
#import "GenerateTestUserSig.h"
#import <V2TIMManager+Message.h>
#import <V2TIMManager+Conversation.h>
#import <ImSDK/ImSDK.h>
#import <ImSDK/TIMMessage.h>

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<V2TIMAdvancedMsgListener,V2TIMSDKListener,TIMMessageListener>

@property (nonatomic, strong) V2TIMMessage *message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc]init];
    config.logLevel = V2TIM_LOG_NONE;
    [[V2TIMManager sharedInstance]initSDK:SDKAPPID config:config listener:self];
    
    [[V2TIMManager sharedInstance]addAdvancedMsgListener:self];

    [[TIMManager sharedInstance]addMessageListener:self];
}

- (void)onNewMessage:(NSArray*)msgs
{
    
}

/// SDK 正在连接到腾讯云服务器
- (void)onConnecting
{
    NSLog(@"%s正在连接到腾讯云服务器",__func__);
}

/// SDK 已经成功连接到腾讯云服务器
- (void)onConnectSuccess
{
    NSLog(@"%s已经成功连接到腾讯云服务器",__func__);
}

/// SDK 连接腾讯云服务器失败
- (void)onConnectFailed:(int)code err:(NSString*)err
{
    NSLog(@"%s连接腾讯云服务器失败",__func__);
}

- (void)onRecvNewMessage:(V2TIMMessage *)msg
{
    NSLog(@"-->>%@",msg);
}
- (IBAction)login:(id)sender {
    
    TIMLoginParam *parm = [[TIMLoginParam alloc]init];
    parm.identifier = @"77";
   
    parm.userSig = [GenerateTestUserSig genTestUserSig:parm.identifier];
    
    [[V2TIMManager sharedInstance]login:parm.identifier userSig:parm.userSig succ:^{
          NSLog(@"登录成功");
  
          V2TIMUserFullInfo *info = [[V2TIMUserFullInfo alloc] init];
          info.allowType = V2TIM_FRIEND_NEED_CONFIRM;
  
          [[V2TIMManager sharedInstance] setSelfInfo:info succ:^{
              NSLog(@"设置成功");
          } fail:^(int code, NSString *desc) {
              NSLog(@"设置失败");
          }];
  
        [self getMessage];
        
    } fail:^(int code, NSString *desc) {
          NSLog(@"登录失败--->>%@",desc);
    }];
}

-(void)getMessage{
    
    V2TIMMessageListGetOption *getinfo = [[V2TIMMessageListGetOption alloc]init];
    getinfo.getType = V2TIM_GET_CLOUD_OLDER_MSG;
    getinfo.userID = @"66";
    getinfo.count = 10;
    getinfo.lastMsg = nil;
    
    [[V2TIMManager sharedInstance]getHistoryMessageList:getinfo succ:^(NSArray<V2TIMMessage *> *msgs) {
        for (int i = 0; i < msgs.count; i++) {
            if (i == 0) {
                self.message = [msgs objectAtIndex:i];
            }
            V2TIMMessage *mg = [msgs objectAtIndex:i];
            [self readData:mg];
        }
    } fail:^(int code, NSString *desc) {
            NSLog(@"---%d---message-->%@",code,desc);
    }];
    
}

-(void)readData:(V2TIMMessage *)msg
{
    /*
     V2TIM_MSG_STATUS_SENDING                  = 1,  ///< 消息发送中
     V2TIM_MSG_STATUS_SEND_SUCC                = 2,  ///< 消息发送成功
     V2TIM_MSG_STATUS_SEND_FAIL                = 3,  ///< 消息发送失败
     V2TIM_MSG_STATUS_HAS_DELETED              = 4,  ///< 消息被删除
     V2TIM_MSG_STATUS_LOCAL_REVOKED            = 6,  ///< 被撤销的消息
     */
    
    if (msg.elemType == V2TIM_ELEM_TYPE_NONE) {
        NSLog(@"未知消息-->%@",msg.textElem.text);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_TEXT){
        NSLog(@"文本消-->%@----state---%ld",msg.textElem.text,(long)msg.status);
        //status 跟据这个状态 来判断是否撤回
    }else if (msg.elemType == V2TIM_ELEM_TYPE_CUSTOM){
        NSString * str  =[[NSString alloc] initWithData:msg.customElem.data encoding:NSUTF8StringEncoding];
        NSLog(@"自定义消息--->>%@",str);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_IMAGE){
        NSLog(@"图片消息%@",msg.imageElem.imageList);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_VIDEO){
        NSLog(@"视频消息--->>%@",msg.videoElem.videoPath);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_FILE){
        NSLog(@"文件消息---->>%@",msg.fileElem.path);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_LOCATION){
        NSLog(@"地理位置消息---->>%@",msg.locationElem.desc);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_FACE){
        NSLog(@"表情消息---->>%d",msg.faceElem.index);
    }else if (msg.elemType == V2TIM_ELEM_TYPE_GROUP_TIPS){
        NSLog(@"msg----%@",msg.groupTipsElem.groupID);
    }
    
}

- (IBAction)remokeMeaage:(id)sender {
    [[V2TIMManager sharedInstance]revokeMessage:self.message succ:^{
        NSLog(@"消息撤回成功");
        } fail:^(int code, NSString *desc) {
            NSLog(@"--%d--mesg--%@",code,desc);
        }];
}

- (IBAction)sendMessage:(id)sender {
//    [[V2TIMManager sharedInstance]sendC2CTextMessage:@"测试0" to:@"66" succ:^{
//        NSLog(@"消息文本发送成功");
//    } fail:^(int code, NSString *desc) {
//        NSLog(@"文本消息发送失败---->%@",desc);
//    }];

    V2TIMMessage  *msg= [[V2TIMManager sharedInstance] createTextMessage:@"999"];

    [[V2TIMManager sharedInstance]sendMessage:msg receiver:@"66" groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:Nil progress:nil succ:^{
            NSLog(@"消息文本发送成功");

    } fail:^(int code, NSString *desc) {
            NSLog(@"文本消息发送失败---->%@",desc);

    }] ;
}
- (IBAction)getMessage:(id)sender {
    [self getMessage];
}

@end
