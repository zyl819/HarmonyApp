import router from '@ohos.router';

@Component
export struct User {
  @StorageLink('userName') userPhone: string = '';

  build() {
    Column() {
      // 顶部浅灰条：显示手机号（左对齐）
      Column() {
        Text(this.userPhone || '未登录')
          .fontSize(20)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16, top: 18, bottom: 18 })
      }
      .width('100%')
      .backgroundColor('#F5F5F5')

      // 列表（左对齐，项间分隔）
      Column({ space: 8 }) {
        this.item('我的等级')
        this.item('健康数据')
        this.item('提醒设置')
        this.item('隐私设置')

        // 退出登录按钮 居中显示，不贴底
        Column() {
          Button('退出登录')
            .width(160)
            .height(44)
            .backgroundColor('#D32F2F')
            .fontColor('#FFFFFF')
            .borderRadius(8)
            .onClick(() => {
              AppStorage.SetOrCreate('userLoggedIn', false)
              router.replaceUrl({ url: 'pages/Login' })
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 8, bottom: 40 }) // 留出底部 Tab 空间
      }
      .margin({ top: 12 })
      .padding({ left: 0, right: 0 })
    }
    .width('100%')
    .height('100%')

  }

  @Builder
  item(title: string) {
    Row() {
      Text(title)
        .fontSize(18)
        .fontColor('#333')

    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 14, bottom: 14 })
    .justifyContent(FlexAlign.Start)   // 让内容从左开始
    .alignItems(VerticalAlign.Center)  // 垂直居中
    .backgroundColor('#FFFFFF')
  }
}
