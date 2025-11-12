import router from '@ohos.router';

@Entry
@Component
struct Index {
  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;

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
            .onClick(() => router.pushUrl({ url: 'pages/Login' }))

          Button('注册')
            .fontSize(22)
            .backgroundColor('#2E7D32')
            .height(56)
            .onClick(() => router.pushUrl({ url: 'pages/Register' }))
        } else {
          Text('欢迎，您已登录。请选择要使用的功能：')
            .fontSize(20)
            .fontColor('#555555')

          Button('附近社区线下活动')
            .fontSize(22)
            .backgroundColor('#00695C')
            .height(56)
            .onClick(() => router.pushUrl({ url: 'pages/Events' }))

          Button('优惠券与健康超市')
            .fontSize(22)
            .backgroundColor('#8E24AA')
            .height(56)
            .onClick(() => router.pushUrl({ url: 'pages/Coupons' }))
        }
      }
      .padding(24)
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}