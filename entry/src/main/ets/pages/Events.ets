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

  private events: EventItem[] = [
    {
      id: '1',
      title: '秋季养生讲座',
      organizer: '附近社区医院',
      time: '2025-11-20 09:30',
      address: '朝阳社区医院报告厅',
      recommended: true,
      distance: '800m'
    },
    {
      id: '2',
      title: '慢病管理课堂',
      organizer: '邻里健康中心',
      time: '2025-11-25 14:00',
      address: '邻里健康中心二楼',
      distance: '1.5km'
    }
  ];

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
  }

  build() {
    List() {
      // 修复1：移除List下的if判断，通过数据过滤控制渲染
      ForEach(
        this.userLoggedIn ? this.events : [], // 未登录时渲染空列表
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
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}

export default Events;