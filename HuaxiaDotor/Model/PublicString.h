//
//  PublicString.h
//  HuaxiaDotor
//
//  Created by kock on 16/3/21.
//  Copyright © 2016年 kock. All rights reserved.
//  公用字符创文件

#ifndef PublicString_h
#define PublicString_h

/**
 *  response code
 */
#define RESPONSE_CODE_SUCCESS 10000
#define RESPONSE_CODE_FAILURE -10000
#define RESPONSE_CODE_TIMEOUT -10004
#define kItemWidth 78

/**
 *  response URL and KEY
 */
#define RESPONSE_KEY_LOGIN_ID @"loginId"
#define RESPONSE_KEY_LOGIN_PASSWORD @"password"
//返回结果，错误返回空，正确返回结果集
#define RESPONSE_KEY_VALUE @"value"
#define RESPONSE_KEY_CODE @"code"
//身份验证秘钥
#define RESPONSE_KEY_VERIFYCODE @"verifyCode"
#define RESPONSE_KEY_MESSAGE @"message"

#define DICTIONARY_VERIFYCODE @{RESPONSE_KEY_VERIFYCODE: [[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_KEY_VERIFYCODE]}


#define kInsertSqlite @"INSERT INTO %@ (date,advice,eyes,drugUnit,singNum,freqence,firstDayNum,user,totalNum,price,proprety,doctor,state,yzqx,type) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')"
#define kUpdate @"UPDATE %@ set date = '%@', advice = '%@', eyes = '%@', drugUnit = '%@', singNum = '%@', freqence = '%@', firstDayNum = '%@', user = '%@', totalNum = '%@', price = '%@', proprety = '%@', doctor = '%@', state = '%@', yzqx = '%@', type = '%@' WHERE Advice_id = '%@'"

#define kDelete @"delete from %@ where Advice_id = '%ld'"

#define kUser [NSMutableArray arrayWithObjects:@"91,滴眼",@"85,双眼",@"86,右眼",@"87,左眼",@"89,散瞳右眼",@"90,散瞳左眼",@"92,吸氧用",@"74,球后注射（双眼）",@"75,泪道冲洗（双眼）",@"35,表面麻醉",@"36,神经阻滞麻醉",@"37,术中用药",@"1,口服",@"2,舌下含服",@"7,静脉注射",@"8,动脉注射",@"9,肌注",@"51,双眼遮盖",@"11,皮下注射	",@"12,皮内注射",@"13,注射",@"14,静滴",@"15,静注",@"16,静推",@"19,外敷",@"22,冲洗",@"82,滴右眼(OD)",@"3,餐前口服",@"4,餐中口服",@"5,餐后口服",@"31,颞旁注射",@"32,结膜下注射",@"28,涂双眼",@"33,滴鼻",@"34	,局麻",@"39,球周注射(左眼)",@"52,球后注射(右眼)",@"41,静脉接瓶",@"42,术前准备",@"47,颞旁穴位注射",@"48,球后注射(左眼)",@"49,泵入",@"44,静滴(加药)",@"53,出院带药",@"54,球周注射(右眼)",@"55,泪道冲洗",@"56,皮试",@"57,滴左眼",@"58,滴右眼",@"59,涂左眼",@"60,涂右眼",@"61,肛塞",@"62,带入手术室",@"63,局封",@"64,含服",@"65,喷喉",@"66,造影用",@"67,散瞳双眼",@"68,漱口",@"69,稀释用",@"70,置接触镜用",@"71,穴位注射",@"72,头皮注射",@"73,灌肠",@"76,球后注射(双眼)",@"77,球周注射(双眼)",@"83,滴双眼(OU)",@"84,滴左眼(OS)",@"79,外用",@"81,睡前服",@"80,早餐后",@"78,滴双眼",@"88,领药(病区用)", nil]

#define kSystemUpdate @"该功能正在维护，请稍后再试"

#define kDoctorIM [NSString stringWithFormat:@"d%@",[[kUserDefatuel objectForKey:@"DoctorDataDic"] objectForKey:@"loginid"]]

#define CheckStr(str) [PublicTools checkStringIsNill:str]

#define BLUECOLOR_STYLE [UIColor colorWithRed:87/255.0 green:186/255.0 blue:221/255.0 alpha:1.000]

//屏幕高
#define SCREEN_H self.view.frame.size.height
//屏幕宽
#define SCREEN_W self.view.frame.size.width



#endif /* PublicString_h */
