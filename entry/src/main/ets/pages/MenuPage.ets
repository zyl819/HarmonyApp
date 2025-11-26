import { it } from '@ohos/hypium';
import router from '@ohos.router';
import UserAuthIcon from '@ohos.userIAM.userAuthIcon';


@Component
export struct MenuPage {
  pathStack: NavPathStack = new NavPathStack()

  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;
  @State registeredIds: string[] = [];
  @State eventTitles: Record<string, string> = {};
  @State loadingTitles: boolean = false;
  private fetchEventTitles(ids: string[]) {
    this.loadingTitles = true;
    this.eventTitles = {};
    this.loadingTitles = false;
  }

  aboutToAppear(): void {
    this.registeredIds = AppStorage.Get<string[]>('registeredEvents') ?? [];
    if (this.registeredIds.length > 0) {
      this.fetchEventTitles(this.registeredIds);
    }
  }

  build() {
    Navigation(this.pathStack) {
      Column({ space: 24 }) {
        Text('健康生活平台')
          .fontSize(28)
          .fontWeight(FontWeight.Bolder)
        //.margin({ top: 24 })

        if (!this.userLoggedIn) {
          Column({ space: 20 }) {

            // 顶部欢迎图标
            Column() {
              // Image($r('app.media.user_login_icon')) // 自己换图标
              //   .width(96)
              //   .height(96)
              //   .margin({ bottom: 12 })

              Text('欢迎使用健康生活平台')
                .fontSize(24)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .padding({ top: 20, bottom: 4 })

            // 次级提示
            // Text('请先登录或注册后继续使用全部功能')
            //   .fontSize(18)
            //   .fontColor('#666666')
            //   .textAlign(TextAlign.Center)
            //   .width('100%')

            // 登录按钮（主按钮）
            Button() {
              Text("登录")
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
            }
            .backgroundColor('#1565C0')
            .width('100%')
            .height(54)
            .borderRadius(12)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Login' })
            })

            // 注册按钮（次按钮）
            Button() {
              Text("注册")
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1565C0')
            }
            .width('100%')
            .height(54)
            .borderRadius(12)
            .backgroundColor('#E3F2FD')
            .onClick(() => {
              router.pushUrl({ url: 'pages/Register' })
            })
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 40 })
        } else {
          Text('欢迎，您已登录。请选择要使用的功能：')
            .fontSize(20)
            .fontColor('#555555')

          if (this.registeredIds.length > 0) {
            Column({ space: 8 }) {
              Row({ space: 8 }) {
                Image($r('app.media.startIcon'))
                  .width(24)
                  .height(24)
                Text(`已报名 ${this.registeredIds.length} 个活动`)
                  .fontSize(18)
                  .fontColor('#00695C')
              }
              Row({ space: 6 }) {
                ForEach(
                  this.registeredIds.slice(0, 3),
                  (id: string) => {
                    Text(this.eventTitles[id] ?? `活动${id}`)
                      .fontSize(14)
                      .fontColor('#555555')
                      .backgroundColor('#E3F2FD')
                      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                      .borderRadius(10)
                  },
                  (id: string) => id
                )
                if (this.loadingTitles) {
                  Text('加载中…')
                    .fontSize(14)
                    .fontColor('#777777')
                }
              }
            }
          }

          Column() {
            this.cardItemBuilde('附近社区线下活动', 'Events')
            this.cardItemBuilde('优惠券与健康超市', 'Coupons')
            this.cardItemBuilde('体质监管', 'HealthMetrics')

          }
          // Button('附近社区线下活动')
          //   .fontSize(22)
          //   .backgroundColor('#00695C')
          //   .height(56)
          //   .onClick(() => {
          //     router.pushUrl({ url: 'pages/Events' });
          //   })
          //
          // Button('优惠券与健康超市')
          //   .fontSize(22)
          //   .backgroundColor('#8E24AA')
          //   .height(56)
          //   .onClick(() => {
          //     router.pushUrl({ url: 'pages/Coupons' });
          //   })
          //
          // Button('体质监管')
          //   .fontSize(22)
          //   .backgroundColor('#1565C0')
          //   .height(56)
          //   .onClick(() => {
          //     router.pushUrl({ url: 'pages/HealthMetrics' });
          //   })
        }
      }
      .padding(24)
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .height('100%')
    .width('100%')

  }

  @Builder
  cardItemBuilde(title:string, pageName:string) {
    Row() {
      Column() {
        Text(title)
          .fontSize(20)
          .fontWeight(500);
      }
      .margin(20)
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start);
    }
    .width('100%')
    .margin(10)
    .borderRadius(10)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#ff558dfd')
    //.linearGradient({ angle: 135, colors: [['#0a59f7', 0.1], ['#FFFFFF', 1 - 0.618], ['#0a59f7', 1]] })
    .onClick(() => {
      //跳功能页面
      this.pathStack.pushPathByName(pageName,null)
      // onClickFun()
    })
  }
}