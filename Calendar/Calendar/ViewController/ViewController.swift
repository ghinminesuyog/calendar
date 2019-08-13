//
//  ViewController.swift
//  Calendar
//
//  Created by Suyog Ghinmine on 08/08/19.
//  Copyright © 2019 Suyog Ghinmine. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Initialize some variables:
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    
    
    //IBActions:
    
    @IBOutlet weak var previousMonth: UIButton!
    
    @IBOutlet weak var nextMonth: UIButton!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var weekStack: UIStackView!
    
    
    
    
    //numberOfItems in 1 section in collectionView:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex] + firstWeekDayOfMonth - 1
    }
    
    
    // Data in each cell of collectionView:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DateCollectionViewCell
        
        if indexPath.item <= firstWeekDayOfMonth - 2
        {
            cell.isHidden=true
        }
        else
        {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.dateLabel.text="\(calcDate)"
            //Check if calculated date is earlier than today's AND current year is the present year AND current month's index is the same as present month index:
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                //Disable user interaction on past dates
                cell.isUserInteractionEnabled=false
                //Colour of the text in past date cells
                cell.dateLabel.textColor = UIColor.lightGray
            } else {
                //Enable user interaction on upcoming dates
                cell.isUserInteractionEnabled=true
                //Colour of the text in upcoming date cells
                cell.dateLabel.textColor = UIColor.blue
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        print("\(monthsArr[currentMonthIndex]) \(currentYear)")
        
    }
    
    
    //Size of each item:
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    // Spacing between each section:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    //Spacing between each item:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    

    
    
    
    override func viewDidLoad() {
        
        //Index of current month:
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        //Current year:
        currentYear = Calendar.current.component(.year, from: Date())
        //Today's date:
        todaysDate = Calendar.current.component(.day, from: Date())
        //Acquire the first weekday:
        firstWeekDayOfMonth=getFirstWeekDay()
        
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        
        //Present month index and present year:
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        //Text for Month-year label:
        monthYearLabel.text="\(monthsArr[currentMonthIndex]) \(currentYear)"

        //Disable previous month:
        previousMonth.isEnabled = false
        
        
        //Reuse for the cells:
        calendarCollectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    
    
    //Change the number of days in a month(next/previous):
    @IBAction func btnLeftRightAction(sender: UIButton) {
        //When next month button is clicked:
        if sender == nextMonth {
            //Increment the index of the current month:
            currentMonthIndex += 1
            //Check if next month is January of the next year:
            if currentMonthIndex > 11 {
                //Reset the current month index:
                currentMonthIndex = 0
                //Increment the current year:
                currentYear += 1
            }
        }
            //When previous month button is clicked:
        else {
            //Decrement the index of the current month:
            currentMonthIndex -= 1
            //Check if previous month is December of the last year:
            if currentMonthIndex < 0 {
                //Reset the current month index:
                currentMonthIndex = 11
                //Decrement the current year:
                currentYear -= 1
            }

            
        }
        // Set label text for Month-Year:
        monthYearLabel.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        //Call didChangeMonth function:
        didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)

    }
    
    
    
    
    
    
    
    func getFirstWeekDay() -> Int {
        
        let day = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.firstDayOfTheMonth.weekday)!
        
        return day == 7 ? 1 : day
    }
    
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        
        currentMonthIndex=monthIndex
        currentYear = year
        
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        calendarCollectionView.reloadData()
        
        previousMonth.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Month and year name:
    
    //The array that contains the name of the months:
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    
    
    
    
    
    
    
}


//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}


//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
