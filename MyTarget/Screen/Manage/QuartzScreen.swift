//
//  QuartzScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/24.
//

import SwiftUI

struct ParentFunctionKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var setUpCards: (() -> Void)? {
        get { self[ParentFunctionKey.self] }
        set { self[ParentFunctionKey.self] = newValue }
    }
}

struct QuartzScreen: View {
    @State var isBlurEnable: Bool = true
    @State var isRotationEnabled: Bool = true
    //@State var quartzs: [Quartz] = []
    @State var quartzCards: [QuartzCard] = []
    
    @State var isShowEditForm: Bool = false
    @State var isShowAddForm: Bool = false
    @State var selectedQuartz: Quartz = Quartz.init()
    
    @StateObject var quartzModel: QuartzModel = QuartzModel()
    @Environment(\.self) var env
    
    /*@FetchRequest(entity: Quartz.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quartz.id, ascending: false)], predicate: NSPredicate(format: "status = %@", "1"), animation: .easeInOut)
     private var quartzList: FetchedResults<Quartz>*/
    
    func editQuartz(prms: QuartzPrms) -> Void {
        quartzModel.editQuartz(context: env.managedObjectContext, quartzPrms: prms)
    }
    
    func addHoldQuartz(prms: QuartzPrms) -> Void {
        quartzModel.addQuartz(context: env.managedObjectContext, quartzPrms: prms)
        setUpCards()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                BoomerangCard(isBlurEnable: isBlurEnable, isRotationEnabled: isRotationEnabled, quartzCards: $quartzCards,selectedQuartz: $selectedQuartz,isShowEditForm: $isShowEditForm,isShowAddForm: $isShowAddForm)
                    .frame(height: 180)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 100)
                    .environment(\.setUpCards, setUpCards)
            }
            .padding()
            .onAppear() {
                setUpCards()
            }
            .onChange(of: selectedQuartz, perform: { newValue in
                //print(QuartzPrms.newPrmsByQuartz(quartz: selectedQuartz))
            })
            .sheet(isPresented: $isShowEditForm) {
                QuartzForm(quartzPrms: QuartzPrms.newPrmsByQuartz(quartz: selectedQuartz), onSubmit: editQuartz )
            }
            .sheet(isPresented: $isShowAddForm) {
                QuartzForm(quartzPrms: QuartzPrms.newHold, onSubmit: addHoldQuartz)
            }
        }
    }
    
    
    
    func setUpCards(){
        quartzCards = []
        let  list = quartzModel.fetchQuartzList(context:  env.managedObjectContext)
        for quartz in list {
            quartzCards.append(QuartzCard.init(quartz: quartz))
        }
        if quartzCards.count > 1 {
            if var first = quartzCards.first{
                first.id = UUID().uuidString
                //first.zIndex = -100
                quartzCards.append(first)
            }
        }
    }
}

extension QuartzScreen {
    struct BoomerangCard: View {
        var isBlurEnable: Bool = false
        var isRotationEnabled: Bool = false
        @Binding var quartzCards: [QuartzCard]
        @Binding var selectedQuartz: Quartz
        @Binding var isShowEditForm: Bool
        @Binding var isShowAddForm: Bool
        
        @State var offset: CGFloat = 0
        @State var currentIndex: Int = 0
        @State var animation = 0.0
        
        @AppStorage(.shouldUseDarkMode) var shouldUseDarkMod = false
        @Environment(\.setUpCards) var setUpCards
        @State var quartzModel: QuartzModel = QuartzModel()
        @Environment(\.self) var env
        
        @State private var confirmationDialog: DelDialog = .inactive
        private var shouldShowDialog: Binding<Bool> {
            Binding (
                get: { confirmationDialog != .inactive},
                set: { _ in confirmationDialog = .inactive}
            )
        }
        
        var body: some View {
            GeometryReader {
                let size = $0.size
                if quartzCards.isEmpty {
                    VStack(alignment: .leading){
                        VStack(alignment: .leading,spacing: 10){
                            Button {
                                self.isShowAddForm.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2.bold()).foregroundColor(Color.accentColor) 
                                    .padding(.trailing,20)
                            }
                            .push(to: .trailing)
                            .buttonStyle(.plain)
                            .padding(.trailing,20)
                            .padding(.top)
                            
                            HStack {
                                Circle()
                                    .frame(width: 55, height: 55)
                                
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(height: 10)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(height: 10)
                                        .padding(.trailing, 50)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .frame(height: 10)
                                        .padding(.trailing, 100)
                                }
                            }
                            .padding(15)
                            .padding(.horizontal, 30)
                            .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white,blur: 5))
                            
                            Spacer()
                        }
                        .preferredColorScheme(.dark)
                        // .padding(.leading, 50)
                        .push(to: .trailing)
                        .frame(width: size.width,height: size.height)
                        .background(.bg2)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .aspectRatio(contentMode: .fill)
                        
                    }
                    .frame(width: size.width, height: size.height)
                    .containerShape(Rectangle())
                    .offset(y: 40)
                    //.shimmer(.init(tint: .white, highlight: .black,blur: 2))
                    
                    
                } else {
                    ZStack {
                        ForEach(quartzCards.reversed()) { quartz in
                            CardView(quartzCard: quartz, size: size)
                                .offset(y: currentIndex == findIndexOf(card: quartz) ? offset : 0)
                        }
                    }
                    .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: offset == .zero)
                    .frame(width: size.width, height: size.height)
                    .containerShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 2)
                            .onChanged(onChange(value: ))
                            .onEnded(onEnd(value: ))
                    )
                    .onAppear{
                        currentIndex = 0
                    }
                }
            }
        }
        
        func onChange(value: DragGesture.Value) {
            offset = currentIndex == (quartzCards.count - 1) ? 0 : value.translation.height
        }
        
        func onEnd(value: DragGesture.Value) {
            var translation = value.translation.height
            translation = (translation < 0 ? -translation : 0)
            translation = (currentIndex == (quartzCards.count - 1) ? 0 : translation)
            
            if translation > 110 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                    quartzCards[currentIndex].isRotated = true
                    quartzCards[currentIndex].extraOffset = -350
                    quartzCards[currentIndex].scale = 0.7
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                        quartzCards[currentIndex].zIndex = -100
                        for index in quartzCards.indices {
                            quartzCards[index].extraOffset = 0
                        }
                        if currentIndex != (quartzCards.count - 1){
                            currentIndex += 1
                        }
                        offset = .zero
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    for index in quartzCards.indices {
                        if index == currentIndex {
                            if quartzCards.indices.contains(currentIndex - 1){
                                quartzCards[currentIndex - 1].zIndex = Zindex(card: quartzCards[currentIndex - 1])
                            }
                        } else {
                            quartzCards[index].isRotated = false
                            withAnimation(.linear){
                                quartzCards[index].scale = 1
                            }
                        }
                    }
                    
                    if currentIndex == (quartzCards.count - 1){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            for index in quartzCards.indices {
                                quartzCards[index].zIndex = 0
                            }
                            currentIndex = 0
                        }
                    }
                }
            } else {
                offset = .zero
            }
        }
        
        func Zindex(card: QuartzCard) -> Double {
            let index = findIndexOf(card: card)
            let totalCount = quartzCards.count
            return currentIndex > index ? Double(index - totalCount) : quartzCards[index].zIndex
        }
        
        @ViewBuilder
        func CardView(quartzCard: QuartzCard,size: CGSize) -> some View {
            let index = findIndexOf(card: quartzCard)
            let quartz = quartzCard.quartz
            let color = Color(SYSColor(rawValue: quartz.quartzColor ?? "gray")!.create)
            
            
            VStack(alignment: .leading){
                ZStack{
                    Circle()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.bg)
                    
                    /*Circle()
                     .frame(width: 45, height: 45)
                     .foregroundColor(color)
                     
                     Image(systemName: quartz.quartzIcon ?? "def")
                     .frame(width: 45, height: 45)
                     .bold()
                     .foregroundColor(.white)*/
                    
                    Image(systemName: quartz.quartzIcon ?? "def")
                        .resizable()
                        .shimmer(.init(tint: color.opacity(0.7), highlight: .white,blur: 5))
                        .foregroundColor(color)
                        .scaleEffect(0.7, anchor: .center)
                    
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(color, lineWidth: 4)
                                .scaleEffect(0.9, anchor: .center)
                        )
                    
                    //.shadow(radius: 20)
                        .rotation3DEffect(.degrees(animation), axis: (x: 0, y: 1, z: 0.2))
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                                self.animation += 360
                            }
                        }
                }
                .overlay(
                    Circle()
                        .stroke(self.shouldUseDarkMod ? .black : .white, lineWidth: 5)
                )
                .offset(x: -40, y: 80)
                .zIndex(0.5)
                
                
                VStack(alignment: .leading,spacing: 10){
                    HStack {
                        Text(quartz.quartzName!)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            self.selectedQuartz = quartz
                            self.isShowEditForm.toggle()
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2.bold()).foregroundColor(Color.accentColor).opacity(0.8)
                            // .padding(.trailing,40)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            confirmationDialog = DelDialog.delQuartz
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.title2.bold()).foregroundColor(Color.red).opacity(0.8)
                                .padding(.trailing,20)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack(spacing: 10){
                        Text("目标类型:")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        
                        Text(quartz.quartzType == "HOLD" ? "坚持" : "戒掉")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 10){
                        Text("记录方式:")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        
                        Text(quartz.quartzWay == "HOLD" ? "是否" : "次数")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 10){
                        Text("开始日期:")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        
                        Text(quartz.startDay!)
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        
                        if (quartz.isEveryDay == false) {
                            Text("结束日期:")
                                .font(.callout.bold())
                                .foregroundColor(.white)
                            
                            Text(quartz.endDay!)
                                .font(.callout.bold())
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 10){
                        Text("开始时间:")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        
                        Text(getStringForHHmm(dateTime:quartz.startTime!))
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        
                        if (quartz.isHourRange == true ) {
                            Text("结束时间:")
                                .font(.callout.bold())
                                .foregroundColor(.white)
                            
                            Text(getStringForHHmm(dateTime:quartz.endTime!))
                                .font(.callout.bold())
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .padding(.leading, 50)
                .push(to: .leading)
                .frame(width: size.width,height: size.height)
                .background(Color(SYSColor(rawValue:  quartz.quartzColor ?? "gray")!.create))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .aspectRatio(contentMode: .fill)
                
            }
            .frame(width: size.width, height: size.height)
            .blur(radius: quartzCard.isRotated && isBlurEnable ? 6.5 : 0)
            .scaleEffect(quartzCard.scale, anchor: quartzCard.isRotated ? .center : .top)
            .rotation3DEffect(.init(degrees: isRotationEnabled && quartzCard.isRotated ? 360 : 0), axis: (x: 0, y: 0, z: 1))
            .offset(y: -offsetFor(index: index))
            .offset(y: quartzCard.extraOffset)
            .scaleEffect(scaleFor(index: index), anchor: .top)
            .zIndex(quartzCard.zIndex)
            .confirmationDialog(confirmationDialog.rawValue,
                                isPresented: shouldShowDialog,
                                titleVisibility: .visible) {
                Button("确定", role: .destructive, action:  { quartzModel.delQuartz(context:  env.managedObjectContext, quartz: quartz);  self.setUpCards!() })
                Button("取消", role: .cancel){}
            } message: {
                Text(confirmationDialog.message)
            }
        }
        
        
        
        private enum DelDialog: String, CaseIterable, Identifiable{
            var id: Self { self }
            case delQuartz = "删除任务"
            case inactive
            
            var message: String {
                switch self {
                case .delQuartz:
                    return "将删除该任务，但不影响之前的每日信息，\n此操作无法复原，确定进行吗？"
                case .inactive:
                    return ""
                }
            }
        }
        
        func scaleFor(index value: Int) -> Double {
            let index = Double(value - currentIndex)
            if index >= 0 {
                if index > 3 {
                    // 1 / 15 = 0.6
                    // 3 / 15 = 0.2
                    // 1 - 0.2 = 0.8
                    return 0.8
                }
                return 1 - (index / 15)
            } else {
                if -index > 3 {
                    return 0.8
                }
                return 1 + (index / 15)
            }
        }
        
        func offsetFor(index value: Int) -> Double {
            let index = Double(value - currentIndex)
            if index >= 0 {
                if index > 3 {
                    return 30
                }
                return (index * 10)
            } else {
                if -index > 3 {
                    return 30
                }
                return (-index * 10)
            }
        }
        
        func findIndexOf(card: QuartzCard) -> Int {
            if let index = quartzCards.firstIndex(where: { qtz in
                qtz.id == card.id
            }){
                return index
            }
            return 0
        }
    }
}
struct QuartzScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuartzScreen()
    }
}
