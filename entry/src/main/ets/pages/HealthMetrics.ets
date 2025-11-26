import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

interface MetricEntry {
  date: string;
  weight: number;
  systolic: number;
  diastolic: number;
  heartRate: number;
}

@Builder
export function HealthMetricsBuilder() {
  HealthMetrics();
}

@Entry
@Component
struct HealthMetrics {
  // pathStack: NavPathStack = new NavPathStack()

  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;
  @State entries: MetricEntry[] = AppStorage.Get<MetricEntry[]>('healthMetrics') ?? [];
  @State weight: string = '';
  @State systolic: string = '';
  @State diastolic: string = '';
  @State heartRate: string = '';
  @State metricType: string = 'weight';
  @State trendImageUrl: string = '';
  @State loading: boolean = false;
  @State error: string = '';

  private today(): string {
    const d: Date = new Date();
    const y: number = d.getFullYear();
    const m: string = (d.getMonth() + 1).toString().padStart(2, '0');
    const day: string = d.getDate().toString().padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  private save(): void {
    const entry: MetricEntry = {
      date: this.today(),
      weight: parseFloat(this.weight) || 0,
      systolic: parseFloat(this.systolic) || 0,
      diastolic: parseFloat(this.diastolic) || 0,
      heartRate: parseFloat(this.heartRate) || 0
    };
    const filtered: MetricEntry[] = this.entries.filter((e: MetricEntry) => e.date !== entry.date);
    const updated: MetricEntry[] = [...filtered, entry].sort((a: MetricEntry, b: MetricEntry) => a.date.localeCompare(b.date));
    this.entries = updated;
    AppStorage.SetOrCreate('healthMetrics', updated);
    this.postEntry(entry);
  }

  private fetchEntries(): void {
    this.loading = true;
    this.error = '';
    
    // 模拟历史数据
    const mockData: MetricEntry[] = [
      { date: '2023-11-20', weight: 69.5, systolic: 122, diastolic: 81, heartRate: 72 },
      { date: '2023-11-21', weight: 69.2, systolic: 120, diastolic: 80, heartRate: 70 },
      { date: '2023-11-22', weight: 68.8, systolic: 118, diastolic: 78, heartRate: 68 },
      { date: '2023-11-23', weight: 69.0, systolic: 119, diastolic: 79, heartRate: 71 },
      { date: '2023-11-24', weight: 68.5, systolic: 120, diastolic: 80, heartRate: 70 },
    ];

    // 如果当前没有数据，则加载模拟数据
    if (this.entries.length === 0) {
      this.entries = mockData;
      // 同步到 AppStorage 以便持久化（可选）
      AppStorage.SetOrCreate('healthMetrics', mockData);
    }

    this.loading = false;
  }

  private postEntry(entry: MetricEntry): void {
    this.error = '';
  }

  private fetchTrend(): void {
    this.loading = true;
    this.error = '';
    this.trendImageUrl = '';
    this.loading = false;
  }

  aboutToAppear(): void {
    if (!this.userLoggedIn) {
      router.replaceUrl({ url: 'pages/Login' });
    }
    if (this.userLoggedIn) {
      this.fetchEntries();
    }
  }

  build() {
    // NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          Text('体质监管')
            .fontSize(28)
            .fontWeight(FontWeight.Bolder)
            .margin({ top: 24 })

          if (this.userLoggedIn) {
            Text(`日期：${this.today()}`)
              .fontSize(20)

            Row({ space: 12 }) {
              Text('体重(kg)')
                .fontSize(18)
              TextInput({ placeholder: '如 68.5' })
                .type(InputType.Number)
                .onChange((v: string) => this.weight = v)
                .fontSize(18)
            }

            Row({ space: 12 }) {
              Text('收缩压(mmHg)')
                .fontSize(18)
              TextInput({ placeholder: '如 120' })
                .type(InputType.Number)
                .onChange((v: string) => this.systolic = v)
                .fontSize(18)
            }

            Row({ space: 12 }) {
              Text('舒张压(mmHg)')
                .fontSize(18)
              TextInput({ placeholder: '如 80' })
                .type(InputType.Number)
                .onChange((v: string) => this.diastolic = v)
                .fontSize(18)
            }

            Row({ space: 12 }) {
              Text('心率(bpm)')
                .fontSize(18)
              TextInput({ placeholder: '如 70' })
                .type(InputType.Number)
                .onChange((v: string) => this.heartRate = v)
                .fontSize(18)
            }

            Button('保存当日指标')
              .fontSize(20)
              .backgroundColor('#2E7D32')
              .height(48)
              .onClick(() => this.save())

            Row({ space: 8 }) {
              Button(this.metricType === 'weight' ? '体重✓' : '体重')
                .height(36)
                .onClick(() => this.metricType = 'weight')
              Button(this.metricType === 'systolic' ? '收缩压✓' : '收缩压')
                .height(36)
                .onClick(() => this.metricType = 'systolic')
              Button(this.metricType === 'diastolic' ? '舒张压✓' : '舒张压')
                .height(36)
                .onClick(() => this.metricType = 'diastolic')
              Button(this.metricType === 'heartRate' ? '心率✓' : '心率')
                .height(36)
                .onClick(() => this.metricType = 'heartRate')
            }

            Row({ space: 12 }) {
              Button('获取趋势图')
                .fontSize(20)
                .backgroundColor('#1565C0')
                .height(44)
                .onClick(() => this.fetchTrend())
              if (this.loading) {
                Text('加载中…')
                  .fontSize(18)
                  .fontColor('#777777')
              }
            }

            if (this.error) {
              Text(this.error)
                .fontSize(18)
                .fontColor('#D32F2F')
            }

            if (this.trendImageUrl) {
              Image(this.trendImageUrl)
                .width('100%')
                .height(220)
            } else {
              Text('尚未获取趋势图')
                .fontSize(18)
                .fontColor('#777777')
            }
          }
        }
        .padding(24)
        .width('100%')
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#FFFFFF')
    // }
    // .onReady(((context:NavDestinationContext)=>{
    //   this.pathStack = context.pathStack
    // }))
  }

}

export default HealthMetrics;