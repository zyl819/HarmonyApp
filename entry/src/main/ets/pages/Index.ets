import router from '@ohos.router';

@Entry
@Component
struct Index {
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
    Scroll() {
      Column({ space: 24 }) {
        Text('健康生活平台')
          .fontSize(28)
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 24 })

        if (!this.userLoggedIn) {
          Text('请先登录或注册后使用其他功能')
            .fontSize(20)
            .fontColor('#555555')

          Button('登录')
            .fontSize(22)
            .backgroundColor('#1565C0')
            .height(56)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Login' });
            })

          Button('注册')
            .fontSize(22)
            .backgroundColor('#2E7D32')
            .height(56)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Register' });
            })
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

          Button('附近社区线下活动')
            .fontSize(22)
            .backgroundColor('#00695C')
            .height(56)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Events' });
            })

          Button('优惠券与健康超市')
            .fontSize(22)
            .backgroundColor('#8E24AA')
            .height(56)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Coupons' });
            })

          Button('体质监管')
            .fontSize(22)
            .backgroundColor('#1565C0')
            .height(56)
            .onClick(() => {
              router.pushUrl({ url: 'pages/HealthMetrics' });
            })
        }
      }
      .padding(24)
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}

export default Index;