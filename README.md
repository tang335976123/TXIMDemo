# TIMSDKDEMO


## Example

代码下载后设置 SDKAPPID和密钥 可以直接运行
## Requirements

## Author

https://www.jianshu.com/u/9d3ddb989614

https://www.rtcgeek.com/?/column/details/4

## License

TIMSDKDEMO is available under the MIT license. See the LICENSE file for more info.

# TIMSDKDEMO 功能介绍

#### 本DEMO 调用的IM V2的全新接口

##### 功能点有：1、登录 、获取历史消息 、消息撤回、发送消息、 发送信令消息、 离线功能设置（声音、推送消息标题、声音、内容展示）

#### DEMO 只需要 GenerateTestUserSig 在这个文件中设置 SDKAPPID和 SECRETKEY 这两个参数就行了

###### 使用这个文件GenerateTestUserSig 注意 事项：
*  Function: 用于生成测试用的 UserSig，UserSig 是腾讯云为其云服务设计的一种安全保护签名。
*           其计算方法是对 SDKAppID、UserID 和 EXPIRETIME 进行加密，加密算法为 HMAC-SHA256。
*
* Attention: 请不要将如下代码发布到您的线上正式版本的 App 中，原因如下：
*
*            本文件中的代码虽然能够正确计算出 UserSig，但仅适合快速调通 SDK 的基本功能，不适合线上产品，
*            这是因为客户端代码中的 SECRETKEY 很容易被反编译逆向破解，尤其是 Web 端的代码被破解的难度几乎为零。
*            一旦您的密钥泄露，攻击者就可以计算出正确的 UserSig 来盗用您的腾讯云流量。
*
*            正确的做法是将 UserSig 的计算代码和加密密钥放在您的业务服务器上，然后由 App 按需向您的服务器获取实时算出的 UserSig。
*            由于破解服务器的成本要高于破解客户端 App，所以服务器计算的方案能够更好地保护您的加密密钥。


#### 介绍发送各种消息使用方法

发送图片：
   
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:@"66"];
    
    TIMMessage * msg = [[TIMMessage alloc] init];
    
    TIMImageElem * image_elem = [[TIMImageElem alloc] init];
    
    //放在自定义bundle中的图片
    image_elem.path  = @"/Users/edz/TXIMDemo/IMSDKDEMO/IMSDKDEMO/Debug/22.png";
    
    [msg addElem:image_elem];
    
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsg Succ");
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
    
发送文件：
    
    V2TIMMessage *msg = [[V2TIMManager sharedInstance]createFileMessage:@"" fileName:@""];
    V2TIMOfflinePushInfo *info = [[V2TIMOfflinePushInfo alloc]init];
    [[V2TIMManager sharedInstance]sendMessage:msg receiver:@"" groupID:@"" priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:info progress:^(uint32_t progress) {
        
    } succ:^{
        
    } fail:^(int code, NSString *desc) {
        
    }];
    
    
     }];
    }];
发送群消息：

    [[V2TIMManager sharedInstance]sendGroupTextMessage:@"腾讯测试" to:@"2" priority:V2TIM_PRIORITY_DEFAULT succ:^{
        NSLog(@"群消息发送成功");
    } fail:^(int code, NSString *desc) {
        NSLog(@"--error-->%@",desc);
    }];

获取指定用户资料

    [[TIMFriendshipManager sharedInstance]getUsersProfile:@[@"66890909"] forceUpdate:YES succ:^(NSArray<TIMUserProfile *> *profiles) {
        NSLog(@"--pofiles--%@",profiles);
    } fail:^(int code, NSString *msg) {
            
    }];

获取成员列表

    [[V2TIMManager sharedInstance]getGroupMemberList:@"66666" filter:V2TIM_GROUP_MEMBER_FILTER_ALL nextSeq:30 succ:^(uint64_t nextSeq, NSArray<V2TIMGroupMemberFullInfo *> *memberList) {
        NSLog(@"---->>%@",memberList);
    } fail:^(int code, NSString *desc) {
        NSLog(@"error--->%@",desc);
    }];
    
 *转让群给新群主*
  
    [[TIMGroupManager sharedInstance]modifyGroupOwner:@"7787" user:@"55" succ:^{
        NSLog(@"群转让转成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"群转让失败---%@",msg);
    }];
    
退出群组
   
    [[V2TIMManager sharedInstance]quitGroup:@"66666" succ:^{
        NSLog(@"退出成功");
    } fail:^(int code, NSString *desc) {
        NSLog(@"--code--%d----->>%@",code,desc);
    }];
 
 发送视频文件
 
    V2TIMMessage *mage = [[V2TIMManager sharedInstance]createVideoMessage:@"/Users/edz/videoDemo/TLIMDemo/TLIMDemo/Debug/ttyy.mp4" type:@"mp4" duration:44 snapshotPath:@"/Users/edz/videoDemo/TLIMDemo/TLIMDemo/Debug/22.png"];
    V2TIMOfflinePushInfo *info = [[V2TIMOfflinePushInfo alloc]init];
    
    [[V2TIMManager sharedInstance]sendMessage:mage receiver:@"55" groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:info progress:^(uint32_t progress) {
        NSLog(@"----%d",progress);
        } succ:^{
            NSLog(@"发送成功");
        } fail:^(int code, NSString *desc) {
            NSLog(@"--errcode--%d---erromsg--%@",code,desc);
    }];
    
 添加好友

    V2TIMFriendAddApplication *addfriend = [[V2TIMFriendAddApplication alloc]init];
    addfriend.userID = @"55";
    addfriend.friendRemark = @"测试";
    addfriend.addType = V2TIM_FRIEND_TYPE_BOTH;
    
    [[V2TIMManager sharedInstance]addFriend:addfriend succ:^(V2TIMFriendOperationResult *result) {
        NSLog(@"ok");
    } fail:^(int code, NSString *desc) {
        NSLog(@"code-->>%d--->>%@",code,desc);
    }];
    
添加群：

    [[V2TIMManager sharedInstance]joinGroup:@"8989888" msg:@"腾讯云的" succ:^{
        NSLog(@"进群成功");
    } fail:^(int code, NSString *desc) {
        NSLog(@"进群失败----- >%@",desc);
    }];
    
创建群：
    
    [[V2TIMManager sharedInstance]createGroup:@"AVChatRoom" groupID:@"8989888" groupName:@"测试0012" succ:^(NSString *groupID) {
        NSLog(@"grouid-->>%@",groupID);
    } fail:^(int code, NSString *desc) {
        NSLog(@"error--->%@",desc);
    }];
推送注意点：
  
    V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
            confg.businessID = sdkBusiId;
            confg.token = self.deviceToken;
     [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
                 NSLog(@"-----> 设置 APNS 成功");
     } fail:^(int code, NSString *msg) {
             NSLog(@"-----> 设置 APNS 失败");
     }];
            
 离线推送设置
 主要是在这个V2TIMOfflinePushInfo类中设置。
####               苹果 APNS 离线推送
 填入 sound 字段表示接收时不会播放声音
extern NSString * const kIOSOfflinePushNoSound;

 自定义消息 push。
@interface V2TIMOfflinePushInfo : NSObject

离线推送展示的标题。
@property(nonatomic,strong) NSString * title;
 离线推送展示的内容。
@property(nonatomic,strong) NSString * desc;


然后设置以下方法的 offlinePushInfo 就可以了

- (NSString *)sendMessage:(V2TIMMessage *)message
                 receiver:(NSString *)receiver
                  groupID:(NSString *)groupID
                 priority:(V2TIMMessagePriority)priority
           onlineUserOnly:(BOOL)onlineUserOnly
          offlinePushInfo:(V2TIMOfflinePushInfo *)offlinePushInfo
                 progress:(V2TIMProgress)progress
                     succ:(V2TIMSucc)succ
                     fail:(V2TIMFail)fail;
 
            
