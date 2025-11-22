import router from '@ohos.router';
import { User } from './User';
import { MenuPage } from './MenuPage';

interface TabClass {
  text: string
  icon: ResourceStr
}

@Entry
@Component
struct Index {

  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;
  @State currentIndex: number = 0;

  tabData: TabClass[] = [
    { text: '菜单', icon: $r('app.media.menu_icon') },
    { text: '我的', icon: $r('app.media.my_icon') }
  ]

  aboutToAppear() {
    if (!this.userLoggedIn) {
      // 不能在 build 用 if，这里跳转即可
      router.replaceUrl({ url: 'pages/Login' });
    }
  }

  build() {
    Column() {
      //  Tabs 始终在，但根据登录状态显示/隐藏
      Tabs({ barPosition: BarPosition.End }) {

        ForEach(this.tabData, (item: TabClass, index: number) => {
          TabContent() {
            if (index === 0) {
              MenuPage()
            } else {
              User()
            }
          }
          .tabBar(this.tabBuilder(item, index))
        })

      }
      .onChange((index: number) => this.currentIndex = index)
      .visibility(this.userLoggedIn ? Visibility.Visible : Visibility.Hidden)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  tabBuilder(item: TabClass, index: number) {
    Column({ space: 5 }) {
      Image(item.icon)
        .width(24)
        .fillColor(this.currentIndex === index ? '#ff6adde7' : '#ff616567')

      Text(item.text)
        .fontSize(15)
        .fontColor(this.currentIndex === index ? '#ff6adde7' : '#ff616567')
    }
  }
}

export default Index;
