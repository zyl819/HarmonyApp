import router from '@ohos.router';

// 定义优惠券类型接口（修正接口语法，去掉结尾分号）
interface Coupon {
  id: string;
  title: string;
  desc: string;
  partner: string;
  amount: number;
  threshold: number;
}

@Builder
export function CouponsBuilder() {
  Coupons();
}

@Entry
@Component
struct Coupons {
  pathStack: NavPathStack = new NavPathStack()

  // 绑定登录状态（从Storage中获取）
  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;
  // 从AppStorage获取优惠券列表，默认空数组
  @State coupons: Coupon[] = (AppStorage.Get('coupons') as Coupon[]) ?? [];
  @State availableCoupons: Coupon[] = [];
  @State loading: boolean = false;
  @State error: string = '';

  private fetchAvailableCoupons() {
    this.loading = true;
    this.error = '';
    this.availableCoupons = [];
    this.loading = false;
  }

  // 领取优惠券方法
  private claim(coupon: Coupon) {
    // 检查是否已领取，避免重复添加
    const isAlreadyClaimed = this.coupons.some(item => item.id === coupon.id);
    if (!isAlreadyClaimed) {
      // 创建新数组（不可变数据更新）
      const updatedCoupons = [...this.coupons, coupon];
      this.coupons = updatedCoupons;
      // 同步到AppStorage，供其他页面使用
      AppStorage.SetOrCreate('coupons', updatedCoupons);
    }
  }

  // 组件即将显示时执行（生命周期方法）
  aboutToAppear() {
    // 未登录时跳转到登录页
    if (!this.userLoggedIn) {
      router.replaceUrl({ url: 'pages/Login' });
    }
    if (this.userLoggedIn) {
      this.fetchAvailableCoupons();
    }
  }

  build() {
    NavDestination() {
      // 根节点：整个页面使用Column布局
      Column() {
        // 仅当登录状态为true时，渲染优惠券列表
        if (this.userLoggedIn) {
          ForEach(this.availableCoupons, (coupon: Coupon) => {
            Column() {
              // 优惠券标题
              Text(coupon.title)
                .fontSize(24)
                .fontWeight(FontWeight.Bolder)

              // 优惠券详情
              Text(`${coupon.partner} · ${coupon.desc}`)
                .fontSize(20)
                .fontColor('#555555')
                .margin({ top: 4 })

              // 操作按钮区域
              Row({ space: 12 }) {
                // 领取/已领取按钮
                Button(this.coupons.some(item => item.id === coupon.id) ? '已领取' : '领取')
                  .enabled(!this.coupons.some(item => item.id === coupon.id)) // 已领取则禁用
                  .fontSize(20)
                  .backgroundColor('#8E24AA')
                  .height(48)
                  .onClick(() => this.claim(coupon)) // 点击领取优惠券

                // 跳转购物页按钮
                Button('去购买低钠食品')
                  .fontSize(20)
                  .backgroundColor('#3949AB')
                  .height(48)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Shop' }); // 跳转到购物页面
                  })
              }
              .margin({ top: 12 })
            }
            .padding(16)
            .width('100%')

            // 分隔线
            Divider()
              .margin({ left: 16, right: 16 })
          }, (coupon: Coupon) => coupon.id)
          if (this.loading) {
            Text('加载中…')
              .fontSize(18)
              .fontColor('#777777')
          }
          if (this.error) {
            Text(this.error)
              .fontSize(18)
              .fontColor('#D32F2F')
          }
        }
      }
      .height('100%')
      .width('100%')
      .padding(16)
    }
    .onReady(((context:NavDestinationContext)=>{
      this.pathStack = context.pathStack
    }))
  }
}

// 导出组件（供页面入口引用）
export default Coupons;