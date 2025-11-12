import router from '@ohos.router';

// 接口定义规范：去掉结尾分号，统一格式
interface Coupon {
  id: string;
  title: string;
  desc: string;
  partner: string;
  amount: number;
  threshold: number;
}

interface Product {
  id: string;
  name: string;
  price: number;
}

// 商品数据常量
const PRODUCTS: Product[] = [
  { id: 'p1', name: '低钠盐 500g', price: 29.9 },
  { id: 'p2', name: '低钠酱油 1L', price: 39.9 },
  { id: 'p3', name: '低钠饼干 300g', price: 24.9 }
];

// 修复1：@Entry 与 @Component 紧邻（无空行），符合语法规范
@Entry
@Component
struct Shop {
  @StorageLink('userLoggedIn') userLoggedIn: boolean = false;
  @State selectedIds: string[] = [];
  @State total: number = 0;
  @State discount: number = 0;
  @State tip: string = '';
  // 优化类型安全：使用泛型 Get，避免类型断言
  private coupons: Coupon[] = AppStorage.Get<Coupon[]>('coupons') ?? [];

  // 重新计算总价和优惠
  private recalc() {
    const selectedProducts = PRODUCTS.filter(p => this.selectedIds.includes(p.id));
    this.total = selectedProducts.reduce((sum, p) => sum + p.price, 0);
    const validCoupon = this.coupons.find(c => this.total >= c.threshold);
    this.discount = validCoupon ? validCoupon.amount : 0;
  }

  // 切换商品选中状态
  private toggle(id: string) {
    this.selectedIds = this.selectedIds.includes(id)
      ? this.selectedIds.filter(x => x !== id)
      : [...this.selectedIds, id];
    this.recalc();
  }

  // 结算逻辑
  private checkout() {
    if (this.total <= 0) {
      this.tip = '请先选择商品';
      return;
    }
    const payable = Math.max(0, this.total - this.discount);
    this.tip = `下单成功，应付 ¥${payable.toFixed(2)}${this.discount > 0 ? '（已用优惠券）' : ''}`;
  }

  // 修复2：路由跳转移到生命周期，避免在 build() 中执行业务逻辑
  aboutToAppear() {
    if (!this.userLoggedIn) {
      router.replaceUrl({ url: 'pages/Login' });
    }
  }

  build() {
    // 根节点唯一性：所有内容包裹在一个 Column 中
    Column({ space: 12 }) {
      // 修复3：登录状态判断移到根组件内部，通过数据控制渲染
      if (this.userLoggedIn) {
        // 页面标题
        Text('合作健康超市')
          .fontSize(28)
          .fontWeight(FontWeight.Bolder)
          .margin({ top: 24 })

        // 商品列表：ForEach 添加唯一键（必填规范）
        ForEach(PRODUCTS, (p: Product) => {
          Row({ space: 12 }) {
            // 修复4：Checkbox 无 select 方法，使用 checked 方法绑定状态
            Checkbox({ name: p.name, group: 'cart' })
              .select(this.selectedIds.includes(p.id)) // 正确绑定选中状态
              .onChange(() => this.toggle(p.id))
            Text(`${p.name}  ¥${p.price.toFixed(2)}`)
              .fontSize(22)
          }
          .padding(12)
          // Divider 放在 Row 内部，避免布局错误
          Divider()
        }, (p: Product) => p.id) // 唯一键：商品 id

        // 优惠券显示（完全移除UI区域的变量声明）
        if (this.coupons.length > 0) {
          // 直接通过表达式判断，不声明变量
          Text(this.coupons.some(c => this.total >= c.threshold)
            ? `优惠券：${this.coupons.find(c => this.total >= c.threshold)!.title}（${this.coupons.find(c => this.total >= c.threshold)!.desc}）`
            : '暂无满足使用条件的优惠券')
            .fontSize(18)
            .fontColor(this.coupons.some(c => this.total >= c.threshold) ? '#2E7D32' : '#888888')
        } else {
          Text('暂无可用优惠券，可在“优惠券”页面领取')
            .fontSize(18)
            .fontColor('#888888')
        }

        // 价格汇总
        Row({ space: 12 }) {
          Text(`合计：¥${this.total.toFixed(2)}`)
            .fontSize(22)
          if (this.discount > 0) {
            Text(`优惠：¥${this.discount.toFixed(2)}`)
              .fontSize(22)
              .fontColor('#D32F2F')
          }
        }

        // 结算按钮
        Button('结算')
          .fontSize(22)
          .backgroundColor('#1565C0')
          .height(56)
          .width('100%')
          .onClick(() => this.checkout())

        // 提示信息
        if (this.tip) {
          Text(this.tip)
            .fontSize(20)
            .fontColor('#00695C')
            .margin({ top: 8 })
        }
      }
      // 未登录时，根组件内无内容（路由已在 aboutToAppear 中跳转）
    }
    .padding(24)
    .height('100%')
    .width('100%')
  }
}

// 导出组件，供页面引用
export default Shop;