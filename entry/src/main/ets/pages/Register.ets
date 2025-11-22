import router from '@ohos.router';

@Entry
@Component
struct Register {
  @State name: string = '';
  @State phone: string = '';
  @State password: string = '';
  @State error: string = '';

  private doRegister() {
    if (!this.name || !this.phone || !this.password) {
      this.error = '请完整填写姓名、手机号和密码';
      return;
    }
    AppStorage.SetOrCreate('userLoggedIn', true);
    AppStorage.SetOrCreate('userName', this.name || this.phone);
    router.replaceUrl({ url: 'pages/Index' });
  }

  build() {
    Scroll() {
      Column({ space: 24 }) {

        // 顶部图标 + 标题
        Column() {
          // Image($r('app.media.user_register_icon'))  // 自己替换图标
          //   .width(96)
          //   .height(96)
          //   .margin({ bottom: 12 })

          Text('注册新用户')
            .fontSize(28)
            .fontWeight(FontWeight.Bolder)
            .fontColor('#333333')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 40 })

        // 输入表单区域
        Column({ space: 18 }) {

          /** 姓名 */
          Column() {
            // Text('姓名')
            //   .fontSize(18)
            //   .fontColor('#444444')
            //   .margin({ bottom: 6 })

            TextInput({ placeholder: '请输入姓名' })
              .fontSize(20)
              .height(48)
              .backgroundColor('#F5F5F5')
              .borderRadius(12)
              .padding({ left: 16, right: 16 })
              .onChange(v => this.name = v)
          }

          /** 手机号 */
          Column() {
            // Text('手机号')
            //   .fontSize(18)
            //   .fontColor('#444444')
            //   .margin({ bottom: 6 })

            TextInput({ placeholder: '请输入手机号' })
              .type(InputType.Number)
              .maxLength(11)
              .fontSize(20)
              .height(48)
              .backgroundColor('#F5F5F5')
              .borderRadius(12)
              .padding({ left: 16, right: 16 })
              .onChange(v => this.phone = v)
          }

          /** 密码 */
          Column() {
            // Text('设置密码')
            //   .fontSize(18)
            //   .fontColor('#444444')
            //   .margin({ bottom: 6 })

            TextInput({ placeholder: '请输入密码' })
              .type(InputType.Password)
              .fontSize(20)
              .height(48)
              .backgroundColor('#F5F5F5')
              .borderRadius(12)
              .padding({ left: 16, right: 16 })
              .onChange(v => this.password = v)
          }

          /** 错误提示 */
          if (this.error) {
            Text(this.error)
              .fontColor('#D32F2F')
              .fontSize(16)
          }
        }
        .width('100%')
        .padding({ left: 8, right: 8 })

        // 完成注册按钮（主按钮）
        Button() {
          Text("完成注册并登录")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('100%')
        .height(52)
        .borderRadius(14)
        .backgroundColor('#2E7D32')
        .onClick(() => this.doRegister())

        // 返回登录（次按钮）
        Button() {
          Text("返回登录")
            .fontSize(18)
            .fontColor('#1565C0')
        }
        .width('100%')
        .height(50)
        .borderRadius(12)
        .backgroundColor('#E3F2FD')
        .onClick(() => router.replaceUrl({ url: 'pages/Login' }))

      }
      .padding(24)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#FFFFFF')
  }
}
