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
      Column({ space: 16 }) {
        Text('注册新用户')
          .fontSize(28)
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 24 })

        TextInput({ placeholder: '姓名（可选）' })
          .fontSize(22)
          .onChange(v => this.name = v)

        TextInput({ placeholder: '手机号' })
          .type(InputType.Number)
          .maxLength(11)
          .fontSize(22)
          .onChange(v => this.phone = v)

        TextInput({ placeholder: '设置密码' })
          .type(InputType.Password)
          .fontSize(22)
          .onChange(v => this.password = v)

        if (this.error) {
          Text(this.error)
            .fontColor('#D32F2F')
            .fontSize(18)
        }

        Button('完成注册并登录')
          .fontSize(22)
          .backgroundColor('#2E7D32')
          .height(56)
          .onClick(() => this.doRegister())

        Button('返回登录')
          .fontSize(20)
          .backgroundColor('#1565C0')
          .height(48)
          .onClick(() => router.replaceUrl({ url: 'pages/Login' }))
      }
      .padding(24)
    }
    .height('100%')
    .width('100%')
  }
}