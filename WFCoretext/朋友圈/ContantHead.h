//
//  ContantHead.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#ifndef WFCoretext_ContantHead_h
#define WFCoretext_ContantHead_h

typedef NS_ENUM(NSInteger, GestureType) {

    TapGesType = 1,
    LongGesType,

};

#define TableHeader 50
#define ShowImage_H 80
#define PlaceHolder @" "
#define offSet_X 20
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"

#define kDistance 20 //说说和图片的间隔
#define kReplyBtnDistance 30 //回复按钮距离
#define kReply_FavourDistance 8 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;

#define kContentText1 @"思想不会流血，不会感到痛苦，思想不会死去"

#define kContentText2 @"这张面具之下，不是肉体，而是一种思想但思想是不怕子弹的"

#define kContentText3 @"Most people are so ungrateful to be alive. But not you. Not anymore. "

#define kContentText4 @"活着本来没有什么意义，但只要活着就会发现很多有趣的13688919929事，就像你发现了花，我又发现你一样[em:03:]。"

#define kContentText5 @"地狱的房间已满，于是，[em:02:][em:02:]死亡爬上了人间如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中"

#define kContentText6 @"如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中"

#define kShuoshuoText1 @"驱魔人 “你可知道邪恶深藏于你心深处，但我会始终在你的[em:02:]左右，握着我的手，我会让你看到神迹，抱紧信仰，除此你一无所有！”"

#define kShuoshuoText2 @"李太啊，我的饺子最好吃，劲道、柔软、不露馅[em:03:]揉面的时候要一直揉到面团表面象剥了壳的鸡蛋，吃起来一包鲜汁"

#define kShuoshuoText3 @"如果晚上月亮升起的时候，月光www.baidu.com照到我的门口，我希望[em:03:]月光www.baidu.com女神能满足我一个愿望，我想要一双人类的手。我想用我的双手把我的爱人紧紧地拥在怀中，哪怕只有一次。如果我从来没有品尝过温暖的感觉，也许我不会这样寒冷；如果我从没有感受过爱情的甜美，我也许就不会这样地痛苦。如果我没有遇到善良的佩格，如果我从来不曾离开过我的房间，我就不会知道我原来是这样的孤独"

#define kShuoshuoText4 @"人有的时候很脆弱，会遇到很多不如意18618881888的事，日积月累就会形成心结，就算想告诉亲戚朋友，他们也未必懂得怎样[em:03:]开解"

#define kShuoshuoText5 @"如果是像金钱这种东西被抢走的话，再抢[em:03:]回来就好了！但如果是人性或温暖的心的话……那就只有遇上心中同样是空虚的人，才有www.baidu.com办法帮你填补起内心的空洞"

#define kShuoshuoText6 @"双目瞪人玛[em:03:]丽肖,傀儡为子常怀抱,汝辈小儿需切记,梦中遇她莫尖叫"



#endif
