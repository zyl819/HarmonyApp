import router from '@ohos.router';

interface EventItem {
  id: string;
  title: string;
  organizer: string;
  time: string;
  address: string;
  recommended?: boolean;
  distance?: string;
}

@Entry
@Component
struct Events {
  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;
  @State registeredIds: string[] = AppStorage.Get<string[]>('registeredEvents') ?? [];

  @State events: EventItem[] = [];
  @State loading: boolean = false;
  @State error: string = '';

  private fetchEvents() {
    this.loading = true;
    this.error = '';
    this.events = [];
    this.loading = false;
  }

  private register(id: string) {
    if (!this.registeredIds.some(item => item === id)) {
      const updatedIds = [...this.registeredIds, id];
      this.registeredIds = updatedIds;
      AppStorage.SetOrCreate('registeredEvents', updatedIds);
    }
  }

  aboutToAppear() {
    if (!this.userLoggedIn) {
      router.replaceUrl({ url: 'pages/Login' });
    }
    if (this.userLoggedIn) {
      this.fetchEvents();
    }
  }

  build() {
    List() {
      // 修复1：移除List下的if判断，通过数据过滤控制渲染
      ForEach(
        this.userLoggedIn ? this.events : [],
        (ev: EventItem) => {
          ListItem() {
            Column({ space: 10 }) {
              Row({ space: 10 }) {
                Text(ev.title)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bolder)
                if (ev.recommended) {
                  Text('推荐')
                    .fontSize(16)
                    .fontColor('#D32F2F')
                    .backgroundColor('#FFEBEE')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius(4)
                }
              }

              Text(`${ev.organizer} · ${ev.address}`)
                .fontSize(20)
                .fontColor('#555555')

              Text(`${ev.time}${ev.distance ? ' · 距离 ' + ev.distance : ''}`)
                .fontSize(20)
                .fontColor('#777777')

              Button(this.registeredIds.includes(ev.id) ? '已报名' : '报名参加')
                .enabled(!this.registeredIds.includes(ev.id))
                .fontSize(20)
                .backgroundColor('#00695C')
                .height(48)
                .width('100%')
                .onClick(() => this.register(ev.id))

              // 修复2：Divider移入ListItem内部，作为列表项的一部分
              Divider()
                .margin({ top: 10 })
            }
            .padding(16)
          }
        },
        (ev: EventItem) => ev.id
      )
      if (this.loading) {
        ListItem() {
          Text('加载中…')
            .fontSize(18)
            .fontColor('#777777')
        }
      }
      if (this.error) {
        ListItem() {
          Text(this.error)
            .fontSize(18)
            .fontColor('#D32F2F')
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}

export default Events;