//
//  NetRequest.h
//  HuaxiaDotor
//
//  Created by kock on 16/3/17.
//  Copyright © 2016年 kock. All rights reserved.
//  网络地址请求地址文件

#import <Foundation/Foundation.h>

//外网地址
//#define NET_URLSTRING @"http://liookun.imwork.net:90"

//内网地址
//#define NET_URLSTRING @"https://test92.yanketong.com"

//医院地址
#define NET_URLSTRING @"http://www.yanketong.com:90"
//576ce017e0f55a220b001e48
#define UMENGAPPKEY @"577c5c2fe0f55a6e1e004439"

//#define NET_URLSTRING [[NSUserDefaults standardUserDefaults]objectForKey:@"ChangeURL"]

//登录地址
#define LOGIN_URLSTRING [NSString stringWithFormat:@"%@/api/Doctor/DoctorLogin",NET_URLSTRING]

//新增患者
#define ADD_PATIENT [NSString stringWithFormat:@"%@/api/Doctor/AddPatient",NET_URLSTRING]

//获取患者分组
#define GET_PATIENT_GROUP [NSString stringWithFormat:@"%@/api/Doctor/GetGroupByDoc",NET_URLSTRING]

//获取患者分组名字
#define GET_PATIENTS_GROUND [NSString stringWithFormat:@"%@/api/Doctor/GetGroupByDoc",NET_URLSTRING]

//获取患者分组的分组信息
#define GET_PATIENTS_GROUND_CELLDATA [NSString stringWithFormat:@"%@/api/Doctor/GetPatientByGroup",NET_URLSTRING]

//获取验证码
#define GET_USERCODE_MASSAGE [NSString stringWithFormat:@"%@/api/Doctor/GetVerificationCode",NET_URLSTRING]

//注册
#define REGISTER_USER [NSString stringWithFormat:@"%@/api/Doctor/DoctorRegister",NET_URLSTRING]

//门诊记录
#define OUTPATIENTS [NSString stringWithFormat:@"%@/api/Linet/PatientAppointment",NET_URLSTRING]

//医生新增加号设置
#define DOCTOR_ADD_PATIENTS [NSString stringWithFormat:@"%@/api/Share/XtrAppointmentAdd",NET_URLSTRING]

//医生更新加号设置
#define DOCTOR_ADD_UPDATE [NSString stringWithFormat:@"%@/api/Share/XtrAppointmentUpdate",NET_URLSTRING]

//获取加号设置列表
#define DOCTOR_SETTING_LIST [NSString stringWithFormat:@"%@/api/Share/GetXtrAppointment",NET_URLSTRING]

//加号设置的删除
#define DOCTOR_SETTING_REMOVE [NSString stringWithFormat:@"%@/api/Share/XtrAppointmentRemove",NET_URLSTRING]

//加号预约管理列表
#define DOCTOR_BESPEAK_LIST [NSString stringWithFormat:@"%@/api/Share/GetXtrAppointmentList",NET_URLSTRING]

//加号信息预约修改
#define TOOL_EYEREVIEW_LIST_UPDATE [NSString stringWithFormat:@"%@/api/Share/XtrAppointmentListUpdate",NET_URLSTRING]

//获取眼科检查列表
#define TOOL_EYEREVIEW_LIST [NSString stringWithFormat:@"%@/api/Doctor/GetEyeCheckList",NET_URLSTRING]

//眼科常用正常值
#define TOOL_EYEVALUE [NSString stringWithFormat:@"%@/api/Doctor/GetEyeNVAList",NET_URLSTRING]

//人工晶体
#define ARTIFICAL_CRYSTAL [NSString stringWithFormat:@"%@/api/Doctor/GetCrystalParamList",NET_URLSTRING]

//常用药物分组
#define COMMONLY_USED_DRUGS [NSString stringWithFormat:@"%@/api/Doctor/GetEyeDrugChannel",NET_URLSTRING]

//常用药物信息
#define COMMONLY_USED_DRUGS_GOUND [NSString stringWithFormat:@"%@/api/Doctor/GetEyeDrugList",NET_URLSTRING]

//常用英文
#define COMMONLY_USED_ENGLISH [NSString stringWithFormat:@"%@/api/Doctor/GetEyeWordList",NET_URLSTRING]

//发布话题(无图片)接口
#define SENDTOPICRELEASENOPIC [NSString stringWithFormat:@"%@/api/Circle/TopicReleaseNoPic",NET_URLSTRING]

//发布接口(有图)
#define SENDTOPICRELEASENOPICWITHIMAGE [NSString stringWithFormat:@"%@/api/Circle/TopicRelease",NET_URLSTRING]

//病例列表接口
#define CASE_TABLEVIEW_DATA [NSString stringWithFormat:@"%@/api/Circle/TopicListFind",NET_URLSTRING]

//眼科圈详情页接口
#define CIRCLEVIEWFINFO_DATA [NSString stringWithFormat:@"%@/api/Circle/TopicDetailFind",NET_URLSTRING]

//眼科圈发表评论接口
#define CIRCLEVIEWFINFO_COMMENTS [NSString stringWithFormat:@"%@/api/Circle/CommentAdd",NET_URLSTRING]

//查看医生好友列表接口
#define CHEACK_FRIEND_LIST [NSString stringWithFormat:@"%@/api/Circle/CircleFriendListFind",NET_URLSTRING]

//查看好友验证列表接口
#define CIRELE_CIRELE_FRIENDINFO [NSString stringWithFormat:@"%@/api/Circle/CircleFriendInfo",NET_URLSTRING]

//好友验证通过/拒绝接口
#define CIRCLEFRIENDVALIDATE [NSString stringWithFormat:@"%@/api/Circle/CircleFriendValidate",NET_URLSTRING]

//查询医生接口
#define SEACHFRIENDDATA [NSString stringWithFormat:@"%@/api/Circle/CircleFriendFind",NET_URLSTRING]

//添加好友申请接口
#define ADDFRIENDSDATA [NSString stringWithFormat:@"%@/api/Circle/CircleFriendAdd",NET_URLSTRING]

//医生获取患者好友列表
#define GETPARIENDTSLISTDADA [NSString stringWithFormat:@"%@/api/Share/GetPDFriendList",NET_URLSTRING]

//发布停诊通知
#define STOPNOTICE [NSString stringWithFormat:@"%@/api/Share/StopNotice",NET_URLSTRING]

//医生获取站内消息
#define GETSTACEMESSAGEBYDOC [NSString stringWithFormat:@"%@/api/Share/GetStateMessageByDoc",NET_URLSTRING]

//医生发布群发通知
#define MASSNOTICE [NSString stringWithFormat:@"%@/api/Share/MassNotice",NET_URLSTRING]

//医生获取群发通知
#define GETMASSNOTIFY [NSString stringWithFormat:@"%@/api/Share/GetMassNotice",NET_URLSTRING]

//医生重置密码
#define REPASSWORD [NSString stringWithFormat:@"%@/api/Share/PasswordReset",NET_URLSTRING]

//修改医生资料接口
#define DOCTORSETTINGDATAFORSELF [NSString stringWithFormat:@"%@/api/Doctor/DoctorInfoUpdate",NET_URLSTRING]

//修改头像接口
#define SETTINGHEADIMAGE [NSString stringWithFormat:@"%@/api/Doctor/SetDoctorHead",NET_URLSTRING]

//医生认证信息修改
#define DOCTORAPPROVEPOST [NSString stringWithFormat:@"%@/api/Doctor/UploadPictures",NET_URLSTRING]

//获取医院花名册接口
#define GETLICENTSEINFO [NSString stringWithFormat:@"%@/api/Doctor/GetLicenseInfo",NET_URLSTRING]

//支付宝账号绑定
#define ZHIFUBAOACCONUNT [NSString stringWithFormat:@"%@/api/Share/PayAccountAdd",NET_URLSTRING]

//支付宝绑定信息
#define GETPayAccount [NSString stringWithFormat:@"%@/api/Share/GetPayAccount",NET_URLSTRING]

//取消支付宝绑定
#define PAYACCOUNTCANTCEL [NSString stringWithFormat:@"%@/api/Share/PayAccountCancel",NET_URLSTRING]

//发布会诊接口 有图片
#define NETCONSULTATIONADD [NSString stringWithFormat:@"%@/api/Doctor/NetConsultationAdd",NET_URLSTRING]

//发布会诊接口 无图片
#define NETCONSULTATIONADDNOIMAGE [NSString stringWithFormat:@"%@/api/Doctor/NetConsultationAddNoPic",NET_URLSTRING]

//我参与的会诊
#define NETCONSULTATIONJOINLISTFIND [NSString stringWithFormat:@"%@/api/Doctor/NetConsultationJoinListFind",NET_URLSTRING]

//会诊列表接口
#define NETCONSULTATIONLISTFIND [NSString stringWithFormat:@"%@/api/Doctor/NetConsultationListFind",NET_URLSTRING]

//会诊详情接口
#define NETCONSULTATIONDETAILFIND [NSString stringWithFormat:@"%@/api/Doctor/NetConsultationDetailFind",NET_URLSTRING]

//医生收藏文章
#define COLLECTIONADD [NSString stringWithFormat:@"%@/api/Share/CollectionAdd",NET_URLSTRING]

//取消收藏接口
#define COLLECTIONCANCEL [NSString stringWithFormat:@"%@/api/Doctor/CollectionCancel",NET_URLSTRING]

//取消收藏(收藏列表取消)
#define COLLECTIONREMOVE [NSString stringWithFormat:@"%@/api/Share/CollectionRemove",NET_URLSTRING]

//发表评论接口
#define COMMENTADD [NSString stringWithFormat:@"%@/api/Doctor/CommentAdd",NET_URLSTRING]

//删除点赞的接口
#define DELEGATE_ZAN [NSString stringWithFormat:@"%@/api/Doctor/CommentDelete",NET_URLSTRING]

//眼科圈删除点赞或评论
#define DELEGATE_CIRCLE_COMMENT [NSString stringWithFormat:@"%@/api/Circle/CommentDelete",NET_URLSTRING]

//获取学术前沿
#define GETEYEFRONTIERLIST [NSString stringWithFormat:@"%@/api/Hospital/GetNews",NET_URLSTRING]

//判断是否已收藏
#define ISCOLLECTION [NSString stringWithFormat:@"%@/api/Doctor/IsCollection",NET_URLSTRING]

//医生获取收藏列表
#define GETCOLLECTIONLIST [NSString stringWithFormat:@"%@/api/Share/GetCollectionList",NET_URLSTRING]

//忘记密码
#define RESETPASSWORD [NSString stringWithFormat:@"%@/api/Doctor/ResetPassword",NET_URLSTRING]

//删除会诊接口 互联网会诊
#define NET_CONSULTATIONDELETE [NSString stringWithFormat:@"%@/api/Doctor/NetConsultationDelete",NET_URLSTRING]

//删除话题接口 眼科圈
#define TOPICDELETE [NSString stringWithFormat:@"%@/api/Circle/TopicDelete",NET_URLSTRING]

//患者上传图片
#define PICTUREUPLOAD [NSString stringWithFormat:@"%@/api/Share/PictureUpload",NET_URLSTRING]

@interface NetRequest : NSObject

@end
