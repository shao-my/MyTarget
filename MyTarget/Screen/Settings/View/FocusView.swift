//
//  FocusView.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/11.
//

import SwiftUI
import CoreData
import ActivityKit

struct FocusView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var pomodoroModel: PomodoroModel
    @EnvironmentObject var openUrl: OpenUrlModel
    @AppStorage(.isShowIsland) private var isShowIsland: Bool = true
    @Environment(\.self) var env
   

    @FetchRequest(entity: Quartz.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quartz.id, ascending: false)], predicate: NSPredicate(format: "status = %@", "1"), animation: .easeInOut)
    private var quartzList: FetchedResults<Quartz>
    
    // let bgColor: Color = Color(red: 27 / 255, green: 23 / 255, blue: 35 / 255)
    let themeColor: Color =  Color.accentColor
    
    @State var showingSheet: Bool = false
    @State var isBandageQuartz: Bool = false
    @State var quartzs: [Quartz] = []
    @State var selectedQuartz: Quartz = Quartz()
     
    //@AppStorage("active_icon") var activeAppIcon: String = "AppIcon"
    
    var body: some View {
        VStack {
            ZStack{
                Button {
                    //手动退出NavigationLink
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    SFSymbol.arrowLeft
                        .font(.callout.bold())
                   // Text("返回")
                }
                .padding(.leading)
                .push(to: .leading)
                
                HStack{
                    SFSymbol.brain
                    
                    Text("专注模式")
                        .font(.title2.bold())
                }
            }
            .foregroundColor(Color.accentColor)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(.bg2.opacity(0.3))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0,to: pomodoroModel.progress)
                            .stroke(.bg2, lineWidth:  80)
                        
                        Circle()
                            .stroke(themeColor, lineWidth:  5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        Circle()
                            .fill(.bg)
                        
                        Circle()
                            .trim(from: 0,to: pomodoroModel.progress)
                            .stroke(themeColor.opacity(0.7), lineWidth:  10)
                        
                        GeometryReader { porxy in
                            let size = porxy.size
                            
                            Circle()
                                .fill(themeColor)
                                .frame(width: 30,height: 30)
                                .overlay {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                }
                                .frame(width: size.width,height: size.height,alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                        }
                        
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 45,weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroModel.progress)
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                    
                    
                    HStack{
                        Button {
                            if pomodoroModel.isStarted {
                                pomodoroModel.stopTimer()
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                endActivity()
                            }
                        } label: {
                            Image(systemName: "stop.circle")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .frame(width: 80,height: 80)
                                .background {
                                    Circle()
                                        .fill(Color.accentColor)
                                }
                                .shadow(color: Color.accentColor, radius: 8,x: 0,y: 0)
                        }
                        .disabled(!pomodoroModel.isStarted)
                        
                        Spacer()
                        
                        Button {
                            if !pomodoroModel.isStarted {
                                pomodoroModel.addNewTimer = true
                                showingSheet = true
                            }else{
                                pomodoroModel.isPaused.toggle()
                                if(pomodoroModel.isPaused){
                                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                    endActivity()
                                }else{
                                    pomodoroModel.addNotification()
                                    startActivity()
                                }
                            }
                        } label: {
                            Image(systemName: !pomodoroModel.isStarted ? "timer" : ( pomodoroModel.isPaused ? "play.circle" : "pause.circle"))
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .frame(width: 80,height: 80)
                                .background {
                                    Circle()
                                        .fill(Color.accentColor)
                                }
                                .shadow(color: Color.accentColor, radius: 8,x: 0,y: 0)
                        }
                      
                    }
                    .padding(.bottom, 60)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
            }
        }
        .padding()
        .sheet(isPresented: $showingSheet, onDismiss: {
           
        }, content: {
            NewTimerView()
        })
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(Timer.publish(every: 1, on: .current, in: .common).autoconnect()) { _ in
            if pomodoroModel.isStarted && !pomodoroModel.isPaused {
                pomodoroModel.updateTimer(context: env.managedObjectContext)
                /*if isShowIsland {
                    updateActivity()
                    print("pomo" + pomodoroModel.timerStringValue)
                }*/
            }
        }
        .onChange(of: pomodoroModel.isFinished) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                withAnimation(.easeInOut(duration: 0.5)){
                    pomodoroModel.stopTimer()
                    endActivity()
                }
            }
        }
        .onAppear {
            //  quartzs =  quartzModel.fetchQuartzList(context:  env.managedObjectContext)
            quartzs = quartzList.reversed()
            if (quartzs.count > 0 ){
                selectedQuartz = Quartz(context: env.managedObjectContext)
                //selectedQuartz =  quartzs.first!
                //默认一些字段
                selectedQuartz.quartzName = "计时器"
                selectedQuartz.quartzIcon = "hand.thumbsup.circle"
                selectedQuartz.quartzColor = "cyan"
                selectedQuartz.remainderText = "言之无文,行而不远。——《左传》"
            }
        }
        /*.onDisappear {
           // self.presentationMode.wrappedValue.dismiss()
            openUrl.internalLink = ""
        }*/
    }
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    showingSheet = false
                } label: {
                    SFSymbol.xmark
                        .font(.largeTitle.bold())
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    pomodoroModel.startTime()
                    showingSheet = false
                    if isShowIsland {
                        startActivity()
                    } 
                } label: {
                    Text("保存").font(.body.bold())
                }
                .buttonStyle(.bordered)
                .disabled(pomodoroModel.hour == 0 && pomodoroModel.minutes == 0 && pomodoroModel.seconds == 0)
                .opacity(pomodoroModel.hour == 0 && pomodoroModel.minutes == 0 && pomodoroModel.seconds == 0 ? 0.5 : 1)
            }
            .overlay {
                Text("编辑专注模式")
                    .font(.title3.bold())
                    .overlay(
                        Rectangle().frame(height: 2).offset(y: 4)
                        , alignment: .bottom
                    )
                    .push(to: .center)
            }
            .padding([.horizontal,.top])
            
            VStack(spacing: 0) {
                VStack(spacing: 15) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: UIScreen.main.bounds.size.width - 68, height: 32)
                            .foregroundColor(Color.accentColor.opacity(0.8))
                        
                        HStack{
                            Picker("小时", selection: $pomodoroModel.hour) {
                                ForEach(0...23,id: \.self){ value in
                                    Text("\(value)")}
                            }
                            .pickerStyle(.wheel)
                            .padding(.top,0)
                            .padding(.bottom,0)
                            
                            
                            Text("小时")
                                .font(.callout.bold())
                                .push(to: .leading)
                            
                            Picker("分钟", selection: $pomodoroModel.minutes) {
                                ForEach(0...59,id: \.self){ value in
                                    Text("\(value)")
                                        .frame(width: 200)
                                }
                            }
                            .pickerStyle(.wheel)
                            
                            Text("分钟")
                                .font(.callout.bold())
                                .push(to: .leading)
                            
                            Picker("秒", selection: $pomodoroModel.seconds) {
                                ForEach(0...59,id: \.self){ value in
                                    Text("\(value)")
                                        .frame(width: 200)
                                }
                            }
                            .pickerStyle(.wheel)
                            
                            Text("秒")
                                .font(.callout.bold())
                                .push(to: .leading)
                        }
                        .padding(.horizontal)
                        .offset(x: 10)
                        .animation(.mySpring, value: pomodoroModel.hour)
                        .animation(.mySpring, value: pomodoroModel.minutes)
                        .animation(.mySpring, value: pomodoroModel.seconds)
                    }
                }
                
                Form {
                    Section {
                        Toggle(isOn: $isShowIsland){
                            Label("灵动岛", systemImage: .bear)
                        }
                        .toggleStyle(.switch)
                        
                        if quartzs.count > 0 {
                            LabeledContent {
                                Button {
                                    withAnimation(.mySpring) {
                                        isBandageQuartz.toggle()
                                        if isBandageQuartz {
                                            selectedQuartz =  quartzs.first!
                                            pomodoroModel.quartzId = selectedQuartz.id!
                                            //自动装载任务时长
                                            let hms = getHMSTimeDifference(time1: selectedQuartz.startTime!, time2: selectedQuartz.endTime!)
                                            pomodoroModel.hour = hms[0]
                                            pomodoroModel.minutes = hms[1]
                                            pomodoroModel.seconds = hms[2]
                                        }else {
                                            pomodoroModel.quartzId = UUID()
                                            pomodoroModel.hour = 0
                                            pomodoroModel.minutes = 0
                                            pomodoroModel.seconds = 0
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.right.circle")
                                        .font(.system(size: 25, weight: .semibold))
                                        .foregroundColor(isBandageQuartz ? Color.red : Color.accentColor)
                                        .rotationEffect(.init(degrees: isBandageQuartz ? 90 : 0))
                                }
                            } label: {
                                Label("关联任务", systemImage: .bandage)
                            }
                        }
                        else{
                            LabeledContent {
                                Text("暂无任务")
                            } label: {
                                Label("关联任务", systemImage: .bandage)
                            }
                        }
                        
                        
                        if isBandageQuartz {
                            LabeledContent {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 25, weight: .semibold))
                            } label: {
                                Label(selectedQuartz.quartzName!,systemImage: selectedQuartz.quartzIcon!)
                            }
                            .foregroundColor(Color(SYSColor(rawValue:selectedQuartz.quartzColor!)!.create))
                        }
                    }
                }
                .frame(minHeight: 200)
                .padding(.top, -20)
            }
            .padding(.top, -20)
            .padding(.bottom, -20)
            
            Spacer()
            
            VStack{
                if isBandageQuartz {
                    GeometryReader{ proxy in
                        let size = proxy.size
                        let trailingCardsToShown: CGFloat = 2
                        let trailingSpaceOfEachCards: CGFloat = 20
                        
                        ZStack {
                            ForEach(quartzs){ quartz in
                                InfiniteStackedCardsView(quartzs: $quartzs,quartz: quartz,selectedQuartz: $selectedQuartz,trailingCardsToShown: trailingCardsToShown,trailingSpaceOfEachCards: trailingSpaceOfEachCards)
                                    .environmentObject(pomodoroModel)
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.trailing,(trailingCardsToShown * trailingSpaceOfEachCards))
                        .frame(height: size.height / 1.3)
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                    }
                    .transition(.moveUpWithOpacity)
                }
            }
            .clipped()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.groupBg)
        .animation(.mySpring, value: isBandageQuartz)
    }
    
    /// 开启灵动岛显示功能
        func startActivity(){
            Task{
                let attributes = WidgetQuartzAttributes(name:"Quartz")
                let initialContentState = WidgetQuartzAttributes.ContentState(quartzName: selectedQuartz.quartzName ?? "倒计时",quartzIcon: selectedQuartz.quartzIcon ?? "lock.fill",quartzColor: selectedQuartz.quartzColor ?? "cyan" ,remainderText: selectedQuartz.remainderText ?? "",totalSeconds: pomodoroModel.totalSeconds)
                
               /* let initialContentState = WidgetQuartzAttributes.ContentState(quartzName: "倒计时",quartzIcon:   "lock.fill",quartzColor:  "cyan" ,remainderText:   "",timerStringValue: pomodoroModel.timerStringValue)*/
                do {
                    if #available(iOS 16.1, *) {
                        _ = try Activity<WidgetQuartzAttributes>.request(
                            attributes: attributes,
                            contentState: initialContentState,
                            pushType: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                } catch (let error) {
                    print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
                }
            }
        }
        
        /// 更新灵动岛显示
        func updateActivity(){
            Task{
                let updatedStatus = WidgetQuartzAttributes.ContentState(quartzName: selectedQuartz.quartzName ?? "倒计时",quartzIcon: selectedQuartz.quartzIcon ?? "lock.fill",quartzColor: selectedQuartz.quartzColor ?? "cyan" ,remainderText: selectedQuartz.remainderText ?? "",totalSeconds: pomodoroModel.totalSeconds)
                /* let updatedStatus =  WidgetQuartzAttributes.ContentState(quartzName: "倒计时",quartzIcon:   "lock.fill",quartzColor:  "cyan" ,remainderText:   "",timerStringValue: pomodoroModel.timerStringValue)*/
                if #available(iOS 16.1, *) {
                    for activity in Activity<WidgetQuartzAttributes>.activities{
                        await activity.update(using: updatedStatus)
                        print("已更新灵动岛显示 Value:" + pomodoroModel.timerStringValue)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        /// 结束灵动岛显示
        func endActivity(){
            Task{
                if #available(iOS 16.1, *) {
                    /*for activity in Activity<WidgetQuartzAttributes>.activities{
                        await activity.end(dismissalPolicy: .immediate)
                        print("已关闭灵动岛显示")
                    }
                    */
                    Activity<WidgetQuartzAttributes>.activities.forEach { item in
                                   Task{
                   //                    await item.end() //默认结束后，会在锁屏界面等待4小时彻底移除
                                       await item.end(dismissalPolicy:.immediate) // 立即结束
                                   }
                               }
                } else {
                    // Fallback on earlier versions
                }
            }
        }
}

struct InfiniteStackedCardsView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel 
    @Binding var quartzs: [Quartz]
    var quartz: Quartz
    @Binding var selectedQuartz: Quartz
    var trailingCardsToShown: CGFloat
    var trailingSpaceOfEachCards: CGFloat
    
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = .zero
    
    var body: some View {
        let qColor =  Color(SYSColor(rawValue: quartz.quartzColor ?? "gray")!.create)
        
        VStack(alignment: .leading,spacing: 10){
             VStack(alignment: .leading)  {
                 HStack(alignment: .top) {
                     Image(systemName: quartz.quartzIcon!)
                         .font(.title.bold())
                         .lineLimit(1)
                     
                     VStack(alignment: .leading,spacing: 15){
                         Text(quartz.quartzName!)
                             .font(.title.bold())
                         
                         Text("开始日期 : " + quartz.startDay!)
                             .font(.caption)
                             .fontWeight(.semibold)
                         
                         Text("提醒文本 : " + quartz.remainderText!)
                             .font(.caption.bold())
                             .push(to: .leading)
                             .lineLimit(1)
                         
                         HStack {
                             Text("开始 : " + getStringForHHmm(dateTime:  quartz.startTime!))
                                 .font(.caption.bold())
                                 .push(to: .leading)
                             
                             Text("结束 : " +  getStringForHHmm(dateTime:  quartz.endTime!))
                                 .font(.caption.bold())
                                 .push(to: .leading)
                         }
                         
                         Text("时长 : " +  getTimeDifference(time1: quartz.startTime!, time2:  quartz.endTime!))
                             .font(.caption.bold())
                             .push(to: .leading)
                     }
                 }
             }
            .frame(maxHeight: 200)
            .overlay(alignment: .topTrailing) {
                Image(systemName: "checkmark.circle")
                       .font(.system(size: 25, weight: .semibold))
                       .padding(.trailing)
                       .push(to: .trailing)
                       .opacity(getIndex() == 0 ? 1 : 0)
            }
        }
        .padding()
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(qColor)
        )
        .padding(.trailing, -getPadding())
        .padding(.vertical, getPadding())
        .zIndex(Double(CGFloat(quartzs.count) - getIndex()))
        .rotationEffect(.init(degrees:  getRotation(angle: 10)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    var translation = value.translation.width
                    translation = quartzs.first?.id == quartz.id ? translation : 0
                    translation = isDragging ? translation : 0
                    translation = (translation < 0 ? translation : 0)
                    offset = translation
                })
                .onEnded({ value in
                    let width = UIScreen.main.bounds.width
                    let cardPassed = -offset > (width / 2)
                    withAnimation(.easeInOut(duration: 0.2)){
                        if cardPassed {
                            offset = -width
                            removeAndPutBack()
                        } else {
                            offset = .zero
                        }
                    }
                })
        )
        .animation(.easeInOut, value: quartzs)
        .onChange(of: getIndex()) { newValue in
            if getIndex() == 0 {
                selectedQuartz = quartz
                //自动装载任务时长
                let hms = getHMSTimeDifference(time1: selectedQuartz.startTime!, time2: selectedQuartz.endTime!)
                pomodoroModel.hour = hms[0]
                pomodoroModel.minutes = hms[1]
                pomodoroModel.seconds = hms[2]
                pomodoroModel.quartzId = quartz.id!
            }
        }
    }
    
    func removeAndPutBack(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let updatedCard = quartz
            updatedCard.id = UUID()
            quartzs.append(updatedCard)
            quartzs.removeFirst()
        }
    }
    
    func getRotation(angle: Double) -> Double {
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        return Double(progress) * angle
    }
    
    func getPadding() -> CGFloat {
        let maxPadding = trailingCardsToShown * trailingSpaceOfEachCards
        let cardPadding = getIndex() * trailingSpaceOfEachCards
        return (getIndex() <= trailingCardsToShown ? cardPadding : maxPadding)
    }
    
    func getIndex() -> CGFloat {
        let index = quartzs.firstIndex { quartz in
            return self.quartz.id == quartz.id
        } ?? 0
        return CGFloat(index)
    }
}

struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView()
            .environmentObject(PomodoroModel())
    }
}
