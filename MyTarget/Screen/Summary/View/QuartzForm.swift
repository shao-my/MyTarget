//
//  QuartzForm.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/14.
//


import SwiftUI 

struct QuartzForm: View {
    @Environment(\.dismiss) var dismiss
    @State var quartzPrms: QuartzPrms
    
    //  @State private var isEveryDay: Bool = true
    // @State private var isHourRange: Bool = false
    
    @State private var isEditCustom: Bool = false
    @StateObject var quartzModel: QuartzModel = QuartzModel()
    @State var scale: CGFloat = 1
    
    var onSubmit: (QuartzPrms) -> Void
    
    @State private var confirmationDialog: Dialog = .inactive
    
    private var shouldShowDialog: Binding<Bool> {
        Binding (
            get: { confirmationDialog != .inactive },
            set: { _ in confirmationDialog = .inactive }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        confirmationDialog = .closeQuartzForm
                    } label: {
                        SFSymbol.xmark
                            .font(.largeTitle.bold())
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        var shouldSave = true
                        if quartzPrms.quartzName == "" {
                            popTipMessage(icon: "", title: "提示", body: "目标名称必填")
                            shouldSave = false
                            return
                        }
                        
                        if (quartzPrms.quartzWay == "TIMES" && quartzPrms.quartzTimes == "0") {
                            popTipMessage(icon: "", title: "提示", body: "目标次数不能为0")
                            shouldSave = false
                            return
                        }
                        if shouldSave {
                            Task{
                                if quartzPrms.isRemainderOn {
                                    if let ids = try? await quartzModel.scheduleNotification(prms: quartzPrms){
                                        quartzPrms.notificationIDs = ids
                                    }
                                }
                                dismiss()
                                onSubmit(quartzPrms)
                            }
                        }
                    } label: {
                        Text("保存").font(.body.bold())
                    }
                    .buttonStyle(.bordered)
                }
                .overlay {
                    Text("编辑任务信息")
                        .font(.title3.bold())
                        .overlay(
                            Rectangle().frame(height: 2).offset(y: 4)
                            , alignment: .bottom
                        )
                        .push(to: .center)
                    
                }
                .padding([.horizontal,.top])
                
                ZStack {
                    Text("")
                        .frame(width: 130, height: 120)
                        .roundedRectBackground(radius: 20, fill: Color(.tertiarySystemFill))
                        .padding()
                        .scaleEffect(scale)
                        .animateForever(autoreverses: true) { scale = 0.8 }
                    
                    Button {
                        isEditCustom = true
                    } label: {
                        Image(systemName: quartzPrms.quartzIcon)
                            .resizable()
                            .padding()
                            .frame(width: 80, height: 80)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.bordered)
                    .roundedRectBackground(radius: 8, fill:Color(SYSColor(rawValue: quartzPrms.quartzColor)!.create))
                    .padding()
                }
                .overlay(
                    Button(action: {
                        isEditCustom = true
                    }) {
                        SFSymbol.chevronDown
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(.secondary)
                            .clipShape(Circle())
                        /*.background(
                         Circle()
                         .stroke(Color.secondary, lineWidth: 2)
                         )*/
                            .shadow(color: .white, radius: 8)
                    }.offset(x: 40, y: 40)
                    
                )
                
                Form {
                    Section {
                        LabeledContent {
                            TextField("必填",text: $quartzPrms.quartzName)
                        } label: {
                            Label("目标名称", systemImage: .flag)
                        }
                    }
                    
                    Section("目标设定") {
                        Picker(selection: $quartzPrms.quartzType) {
                            Text("坚持").tag("HOLD")
                            Text("戒除").tag("QUIT")
                        } label: {
                            Label("目标类型", systemImage: .type)
                        }
                        
                        Picker(selection: $quartzPrms.quartzWay) {
                            Text("是否").tag("BOOL")
                            Text("次数").tag("TIMES")
                        } label: {
                            Label("记录方式", systemImage: .way)
                        }
                        
                        if quartzPrms.quartzWay == "TIMES" {
                            LabeledContent {
                                TextField("",text: $quartzPrms.quartzTimes)
                                    .keyboardType(.numberPad)
                            } label: {
                                Label("每日次数", systemImage: .num)
                            }
                        }
                    }
                    
                    Section("目标日期") {
                        Toggle(isOn: $quartzPrms.isEveryDay){
                            Label("是否每天", systemImage: .loop)
                        }
                        .toggleStyle(.switch)
                        
                        DatePicker(selection: Binding<Date>(
                            get:{ getDateForYYYYMMDD(dateTime: $quartzPrms.startDay.wrappedValue) },
                            set: { date in
                                $quartzPrms.startDay.wrappedValue = getStringForYYYYMMDD(dateTime: date)
                            }), displayedComponents: DatePickerComponents.date) {
                                Label("开始日期", systemImage: .start)
                            }
                        
                        if !quartzPrms.isEveryDay {
                            DatePicker(selection: Binding<Date>(
                                get:{ getDateForYYYYMMDD(dateTime: $quartzPrms.endDay.wrappedValue) },
                                set: { date in
                                    $quartzPrms.endDay.wrappedValue = getStringForYYYYMMDD(dateTime: date)
                                }), displayedComponents: DatePickerComponents.date) {
                                    Label("结束日期", systemImage: .end)
                                }
                        }
                    }
                    
                    Section("每日时间") {
                        Toggle(isOn: $quartzPrms.isHourRange){
                            Label("是否范围", systemImage: .watch)
                        }
                        .toggleStyle(.switch)
                        
                        DatePicker(selection: $quartzPrms.startTime
                                   /* get:{ getDateForYYYYMMDDHHMM(dateTime: $quartzPrms.startDay.wrappedValue + " " + $quartzPrms.startTime.wrappedValue) },
                                    set: { date in
                                    $quartzPrms.startTime.wrappedValue = getStringForHHmm(dateTime: date)
                                    }),*/
                                   ,
                                   
                                   displayedComponents: DatePickerComponents.hourAndMinute) {
                            Label("开始时间", systemImage: .start)
                        }
                        
                        if quartzPrms.isHourRange {
                            DatePicker(selection: $quartzPrms.endTime, displayedComponents: DatePickerComponents.hourAndMinute) {
                                Label("结束时间", systemImage: .end)
                            }
                        }
                        
                        Toggle(isOn: $quartzPrms.isRemainderOn){
                            Label("是否提醒", systemImage: .bell)
                        }
                        .toggleStyle(.switch)
                        
                        if quartzPrms.isRemainderOn {
                            let weekDays = Calendar.current.weekdaySymbols
                            HStack(spacing: 10) {
                                ForEach(weekDays, id: \.self){day in
                                    
                                    let index = quartzPrms.weekDays.firstIndex {value in
                                        return value == day
                                    } ?? -1
                                    
                                    Text(day.prefix(2))
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .roundedRectBackground(radius: 10, fill: index != -1 ? Color(SYSColor(rawValue: quartzPrms.quartzColor)!.create) : .bg2)
                                        .onTapGesture {
                                            withAnimation {
                                                if index != -1 {
                                                    quartzPrms.weekDays.remove(at: index)
                                                } else {
                                                    quartzPrms.weekDays.append(day)
                                                }
                                            }
                                        }
                                }
                            }
                            
                            LabeledContent {
                                TextField("选填",text: $quartzPrms.remainderText)
                            } label: {
                                Label("提醒文本", systemImage: .speak)
                            }
                            
                            Text("提示: 每日提醒需要手机设置允许消息提醒权限")
                                .font(.caption)
                                .push(to: .center)
                        }
                    }
                    
                }
                .padding(.top,-20)
                .animation(.mySpring, value: quartzPrms.quartzWay)
                .animation(.mySpring, value: quartzPrms.isHourRange)
                .animation(.mySpring, value: quartzPrms.isEveryDay)
                .animation(.mySpring, value: quartzPrms.isRemainderOn)
                
                
            }
            .background(.groupBg)
            .multilineTextAlignment(.trailing)
            //弹出键盘和滚动互动消失
            .scrollDismissesKeyboard(.interactively)
            //键盘工具栏
            .toolbar(content: buildKeyboardTools)
        }
        .confirmationDialog(confirmationDialog.rawValue,
                            isPresented: shouldShowDialog,
                            titleVisibility: .visible) {
            Button("关闭", role: .destructive, action: closeSheet)
            Button("暂不关闭", role: .cancel){}
        } message: {
            Text(confirmationDialog.message)
        }
        .sheet(isPresented: $isEditCustom) {
            CustomIconAndColor(customItem: $quartzPrms )
        }
    }
    
    
    func buildKeyboardTools()  -> some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            
            Text("言之无文,行而不远。——《左传》")
                .font(.body)
                .padding()
                .push(to: .trailing)
            
        }
    }
    
    func closeSheet ()  -> Void {
        dismiss()
    }
    
    func addQuartz ()   {
        dismiss()
    }
    
    
    
}

private enum Dialog: String{
    case closeQuartzForm = "确定要关闭表单?"
    case inactive
    
    var message: String {
        switch self {
        case .closeQuartzForm:
            return "会丢失当前的编辑内容。"
        case .inactive:
            return ""
        }
    }
    
    func action()   {
        switch self {
        case .closeQuartzForm:
            return
        case .inactive:
            return
        }
    }
}

extension Dialog: CaseIterable {
    static let allCases: [Dialog] = [.closeQuartzForm]
}

extension Dialog: Identifiable {
    var id: String {
        self.rawValue
    }
}


struct QuartzForm_Previews: PreviewProvider {
    static var previews: some View {
        QuartzForm(quartzPrms: QuartzPrms.new){ _ in }
    }
}
