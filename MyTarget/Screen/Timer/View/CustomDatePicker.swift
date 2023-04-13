//
//  CustomDatePicker.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/22.
//

import SwiftUI

extension TimerScreen {
    struct CustomDatePicker: View {
        @Binding var currentDate: Date
        @State var currentMonth: Int = 0
        @State var animationStatus: [Bool] = Array(repeating: false, count: 2)
        @AppStorage(.myLocale) private var myLocale: String = "zh_cn"

        
        //@StateObject public var coreDataModel = CoreDataModel()
        //@EnvironmentObject public var coreDataModel : CoreDataModel
        
        @StateObject var dayBookModel: DayBookModel = DayBookModel()
        
        @FetchRequest(entity: DayBook.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.id, ascending: false)], predicate: NSPredicate(format: "dayTime >= %@ and dayTime <= %@", getStringForYYYYMM(dateTime: Date())+"-01",getStringForYYYYMM(dateTime: Date())+"-31"), animation: .easeInOut)
        var dayBookMonth: FetchedResults<DayBook>
        
        @Environment(\.self) var env
         
        @Binding var dayBookListForState: [DayBook]
        
        var body: some View {
            
            VStack{
                
                let days: [String] = myLocale == "zh_cn" ? ["日","一","二","三","四","五","六"] :  ["Sun","Mon","Tues","Wed","Thur","Fri","Sat"]
                
                ZStack {
                    HStack(spacing: 20) {
                        Button {
                            withAnimation {
                                currentMonth -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        
                        Text(extractDate()[0] + " " + extractDate()[1])
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Button {
                            withAnimation {
                                currentMonth += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                       
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .opacity(animationStatus[0] ? 1 : 0)
                    
                    Button {
                        withAnimation {
                            currentMonth = 0
                            currentDate = getCurrentMonth()
                        }
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.circle")
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                    .padding(.trailing, 10)
                    .push(to: .trailing)
                    .opacity(currentMonth == 0 ? 0 : 1)
                }
                
                HStack(spacing: 10) {
                    ForEach(days, id: \.self){ day in
                        Text(day)
                            .font(.caption2)
                            .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding(.top, 4)
                .foregroundColor(.white)
                .opacity(animationStatus[0] ? 1 : 0)
                
                Rectangle()
                    .fill(.white.opacity(0.4))
                    .frame(width: animationStatus[0] ? nil : 0,height: 1)
                    .padding(.vertical, 3)
                    .push(to: .leading)
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                if animationStatus[0] {
                    LazyVGrid(columns: columns,spacing: 10) {
                        ForEach(extractDateValue().indices, id: \.self) {index in
                            let value = extractDateValue()[index]
                            PickerCardView(value: value, index: index, currentDate: $currentDate, isFinished: $animationStatus[1])
                                .onTapGesture {
                                    currentDate = value.date
                                    dayBookListForState = dayBookModel.fetchDayBookForDay(context: env.managedObjectContext,date:  currentDate)
                                }
                        }
                    }
                }
                else {
                    LazyVGrid(columns: columns,spacing: 10) {
                        ForEach(extractDateValue().indices, id: \.self) {index in
                            let value = extractDateValue()[index]
                            PickerCardView(value: value, index: index, currentDate: $currentDate,isFinished: $animationStatus[1])
                                .onTapGesture {
                                    currentDate = value.date
                                    dayBookListForState = dayBookModel.fetchDayBookForDay(context: env.managedObjectContext,date:  currentDate)
                                }
                        }
                    }
                    .opacity(0)
                }
            }
            .padding()
            .onChange(of: currentMonth) { newValue in
                currentDate = getCurrentMonth()
            }
            .onAppear {
                currentDate = getCurrentMonth()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.3)){
                        animationStatus[0] = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animationStatus[1] = true
                    }
                }
            }
        }
        
        func extractDate() -> [String] {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: myLocale)
            formatter.dateFormat = "YYYY MMMM"
            let date = formatter.string(from: currentDate)
            return date.components(separatedBy: " ")
        }
        
        func getCurrentMonth() -> Date {
            let calendar = Calendar.current
            guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
            return currentMonth
        }
        
        func extractDateValue() -> [DateValue] {
            let calendar = Calendar.current
            let currentMonth = getCurrentMonth()
            
            var days = currentMonth.getAllDates().compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                return DateValue(day: day, date: date)
            }
            
            let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
            
            for _ in 0..<firstWeekday - 1 {
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }
            
            return days
        }
    }
}

func isSameDay(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    return calendar.isDate(date1, inSameDayAs: date2)
}

func markDay(dayBookMonth: [DayBook],value: DateValue) -> Bool {
    var isMark = false
    dayBookMonth.forEach{ book in
        if(isSameDay(date1: value.date, date2: getDateForYYYYMMDD(dateTime: book.dayTime!))){
            isMark = true
        }
    }
    return isMark
}

struct PickerCardView : View {
    var value: DateValue
    var index: Int
    @Binding var currentDate: Date
    @Binding var isFinished: Bool
    @State var showView: Bool = false
    //@Binding var dayBookMonth: [DayBook]
    
    @FetchRequest(entity: DayBook.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.id, ascending: false)], predicate: NSPredicate(format: "dayTime >= %@ and dayTime <= %@", getStringForYYYYMM(dateTime: Date())+"-01",getStringForYYYYMM(dateTime: Date())+"-31"), animation: .easeInOut)
    var dayBookMonth: FetchedResults<DayBook>
    
    var body: some View {  
        VStack(spacing: 8) {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .black : .white)
                //.frame(width: .infinity)
                //.frame(width: 35)
                    .background {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.white)
                            .padding(.vertical, -5)
                            .padding(.horizontal, -5)
                            .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                    }
                
                // Spacer()
                
                Circle()
                    .fill(markDay(dayBookMonth: dayBookMonth.reversed(), value: value) ? Color(.systemPink) : Color.clear)
                    .frame(width: 8, height: 8) 
            }
        }
        .opacity(showView ? 1 : 0)
        .onAppear {
            if isFinished { showView = true }
            withAnimation(.spring().delay(Double(index) * 0.02)){
                showView = true
            }
        }
    }
}

extension Date{
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

extension Date{
    func getYearAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        let range = calendar.range(of: .day, in: .year, for: startDate)!
        
        return range.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

/*
 struct CustomDatePicker_Previews: PreviewProvider {
 static var previews: some View {
 CustomDatePicker(currentDate: .constant(Date()))
 }
 }
 
 */
