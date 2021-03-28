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

##### 功能点有：1、登录 、获取历史消息 、消息撤回、发送消息、 发送信令消息

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

