import router from '@ohos.router';
@Entry
@Component
struct Login {
  @State phone: string = '';
  @State password: string = '';
  @State error: string = '';

  private doLogin() {
    if (!this.phone || !this.password) {
      this.error = '请输入手机号和密码';
      return;
    }
    AppStorage.SetOrCreate('userLoggedIn', true);
    AppStorage.SetOrCreate('userName', this.phone);
    router.replaceUrl({ url: 'pages/Index' });
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('账号登录')
          .fontSize(28)
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 24 })

        TextInput({ placeholder: '请输入手机号' })
          .type(InputType.Number)
          .maxLength(11)
          .fontSize(22)
          .onChange(v => this.phone = v)

        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)
          .fontSize(22)
          .onChange(v => this.password = v)

        if (this.error) {
          Text(this.error)
            .fontColor('#D32F2F')
            .fontSize(18)
        }

        Button('登录')
          .fontSize(22)
          .backgroundColor('#2E7D32')
          .height(56)
          .onClick(() => this.doLogin())

        Button('没有账号？去注册')
          .fontSize(20)
          .backgroundColor('#1565C0')
          .height(48)
          .onClick(() => router.pushUrl({ url: 'pages/Register' }))
      }
      .padding(24)
    }
    .height('100%')
    .width('100%')
  }
}