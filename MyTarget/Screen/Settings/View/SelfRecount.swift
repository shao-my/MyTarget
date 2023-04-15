//
//  SelfRecount.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/9.
//

import SwiftUI

struct SelfRecount: View {
    @Environment(\.dismiss) var dismiss
    let customFont = Font.custom("AlimamaDongFangDaKai-Regular", size: 18)
    let customSmallFont = Font.custom("AlimamaDongFangDaKai-Regular", size: 12)
    
    var body: some View {
        NavigationView{
             
                VStack{
                    ScrollView {
                        VStack(alignment: .leading,spacing: 25){
                            infoView()
                             
                            declareView()
                             
                            gratitudeView()
                            
                            contactView()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding([.horizontal,.top])
                       // .border(Color.red)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Text("——")
                        
                        Text("出于兴趣而成为Coder的Json")
                            .font(customSmallFont)
                    }
                    .padding()
                    .push(to: .trailing)
                }
            
            .navigationBarTitle(Text("自述"), displayMode: .automatic)
            .navigationBarItems(trailing:
                Button {
                    dismiss()
                } label: {
                    Text("已阅")
                        .font(.callout.bold())
                        .foregroundColor(Color.accentColor)
                }
                .padding()
            )
            //.edgesIgnoringSafeArea(.bottom)
        }
        .background(.bg2)
    }
    
    @ViewBuilder
    func infoView() -> some View {
        Text("这是一个可以用于定制任务和打卡记录的App，参考了Apple健身圆环设计，包含<坚持>和<戒除>两种类型的目标。" )
            .font(customFont)
            .lineSpacing(10)
        
        HStack(alignment: .top){
            Circle()
                .frame(width: 8,height: 8)
                .foregroundColor(Color.accentColor)
                .padding(.top, 6)
            
            Text("提供每日时间线、统计图、年度贡献日历的统计功能；")
                .font(customFont)
                .lineSpacing(10)
        }
        
        HStack(alignment: .top){
            Circle()
                .frame(width: 8,height: 8)
                .foregroundColor(Color.accentColor)
                .padding(.top, 6)
            
            Text("提供系统基础设定、FaceID解锁、专注模式等功能；")
                .font(customFont)
                .lineSpacing(10)
        }
        
        
        HStack(alignment: .top){
            Circle()
                .frame(width: 8,height: 8)
                .foregroundColor(Color.accentColor)
                .padding(.top, 6)
            
            Text("提供Widget小组件功能，专注模式支持灵动岛计时提醒；")
                .font(customFont)
                .lineSpacing(10)
        }
        
        HStack(alignment: .top){
            Circle()
                .frame(width: 8,height: 8)
                .foregroundColor(Color.accentColor)
                .padding(.top, 6)
            
            Text("后期会上架ICloud备份功能、App评价和打赏功能等。")
                .font(customFont)
                .lineSpacing(10)
        }
    }
    
    @ViewBuilder
    func declareView() -> some View {
        Text("郑重声明：")
            .font(customFont)
            .foregroundColor(Color.accentColor)
            .shimmer(.init(tint: Color.accentColor, highlight: .white,blur: 2))
            .lineSpacing(10)
        
        Text("App所有功能免费开放，不做商用，如侵犯版权，即刻整改，没有任何限制，无需购买使用权和订阅费，也不收集用户的任何信息，所有数据保存在手机本地。")
            .font(customFont)
            .lineSpacing(10)
            .padding(.top, -10)
        
        HStack(spacing: 0){
            Text("可随意")
                .font(customFont)
                .lineSpacing(10)
                .padding(.top, -15)
            
            Text("<打赏>")
                .font(customFont)
                .foregroundColor(Color.accentColor)
                .lineSpacing(10)
                .shimmer(.init(tint: Color.accentColor, highlight: .white,blur: 2))
                .padding(.top, -15)
            
            Text("功能投喂，为爱发电。")
                .font(customFont)
                .lineSpacing(10)
                .padding(.top, -15)
        }
    }
    
    @ViewBuilder
    func gratitudeView() -> some View {
        Text("特别呜谢：")
            .font(customFont)
            .foregroundColor(Color.accentColor)
            .shimmer(.init(tint: Color.accentColor, highlight: .white,blur: 2))
            .lineSpacing(10)
        
        Text("白手起家，面向百度编程，特别感谢：")
            .font(customFont)
            .lineSpacing(10)
            .padding(.top, -10)
        
        Text("ChaoCode Jane")
            .font(customFont)
            .foregroundColor(Color.accentColor)
            .lineSpacing(10)
            .shimmer(.init(tint: Color.accentColor, highlight: .white,blur: 2))
            .padding(.top, -15)
            .push(to: .center)
        
        Text("Kavsoft")
            .font(customFont)
            .foregroundColor(Color.accentColor)
            .lineSpacing(10)
            .shimmer(.init(tint: Color.accentColor, highlight: .white,blur: 2))
            .padding(.top, -15)
            .push(to: .center)
    }
    
    @ViewBuilder
    func contactView() -> some View {
        Text("联系方式：")
            .font(customFont)
            .foregroundColor(Color.accentColor)
            .shimmer(.init(tint: Color.accentColor, highlight: .white,blur: 2))
            .lineSpacing(10)
        
        Text("邮箱地址：286962439@163.com")
            .font(customFont)
            .lineSpacing(10)
            .padding(.top, -10)
    }
}

struct SelfRecount_Previews: PreviewProvider {
    static var previews: some View {
        SelfRecount()
    }
}
