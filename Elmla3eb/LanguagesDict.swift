//
//  File.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 6/8/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation

let isAraLang = {
    return  L102Language.currentAppleLanguage() == "ar"
    
}
let langDicClass = {
    return  Constants.LanguagesDict()
}


extension Constants {
class LanguagesDict {
    // langDicClass().getLocalizedTitle(
    private  var dict = ["Search":"بحث",
                         "Login":"تسجيل الدخول",
                         "Profile":"الصفحه الشخصيه",
                         "Registration":"انشاء حساب",
                         "Field Name:":"اسم الملعب : ",
                         "address:":"العنوان : ",
                         "books Times: ":"مرات الحجز : ",
                         "Price for hour: ":"سعر الساعه : ",
                         "Num of Fields: ":"عدد الملاعب : ",
                         "Field Type: ":"نوع الارضيه : ",
                         "Ball: ":"توفير كره : ",
                         "field Lighting: ":"توفير اضاءه : ",
                         "You have Booked This Field waiting for approval":"تم بنجاح الحجز بانتظار الموافقه ",
                         "Done":"تم",
                         "Error with ":" خطا , ",
                         "Error" : "خطا",
                         "try again!!":"اعد المحاوله!!",
                         "Something Went Wrong":"حدث خطا",
                         "Something Went Wrong With" : "حدث خطأ حيث" ,
                         "You didn't pick Booking Date":"لم تختر معاد للحجز",
                         " Points ":"نقطه",
                         "Invalid username or password":"خطا في رقم الهاتف او كلمة المرور",
                         "Phone Number Already Exists":"رقم الهاتف مستخدم من قبل",
                         "There's no Dates to pick":"لا توجد اوقات متوفره حاليا",
                         "Code Field is Empty" : "حقل رمز التاكيد فارغ",
                         " Network Time out " : " خطأ في الاتصال ",
                         "Failed to Upload Changes" : "فشل في تجديد البيانات",
                         "Confirm" :"تاكيد",
                         "Phone number isn't in a Correct Format":"رقم التلفون غير صحيح",
                         "Please, Enter activation code that was sent to you by sms to activate your account." : "من فضلك قم بادخال الرمز الذي تم ارساله اليك  لتفعيل الاكونت.",
                         "Code" : "الرمز",
                         "Phone Number" : "رقم الهاتف",
                         "  Verfication Code :" : "ادخل رمز التفعيل :",
                         "  Phone Number :" : "ادخل رقم الهاتف :",
                         "Please, Enter The Phone Number To Complete the Process" : "من فضلك، قم بادخال رقم الهاتف لاتمام العمليه",
                         "Activate" : "   ",
                         "All Fields are Required" : "جميع الحقول مطلوبه",
                         "Send" : "ارسال",
                         "Invalid Mobile Number ":"خطا في رقم الهاتف ",
                         "Cancel" : "الغاء",
                         "Old Password Must has to be > 8 and < 20" :  "رقم المرور القديم يجب ان لا يقل عن ٨ احرف ولا تزيد عن ٢٠",
                         "New Password Must has to be > 8 and < 20":"رقم المرور الجديد يجب ان لا يقل عن ٨ احرف ولا تزيد عن ٢٠",
                         "per Hour": "للساعه",
                         "At least one Field has to be filled" : "يجب توافر حقل واحد علي الاقل لاتمام البحث",
                         "Search Result": "نتيجه البحث",
                         "No Data Found" : "لا توجد ملاعب مطابقه",
                         "Total Rate :" : "اجمالي التقييم :",
                         "Resend" : "ارسال",
                         "Resend in " : "إعاده إرسال ",
                         "Save" : "حفظ",
                         "Book Field Now" : "احجز الملعب الآن",
                         "Team Name" : "اسم الفريق",
                         " SAR" : " ريال ",
                         "Edit Field" : "تعديل الملعب",
                         "Book Now!" : "حجز الآن",
                         "Cancel Reservation" : "الغاء الحجز",
                         "price has to be only written in numbers" : "يجب ان يحتوي السعر علي ارقام فقط",
                         "Nearby Fields & bookings" : "الملاعب القريبه / المحجوزه",
                         "Playground Management" : "إدارة الملاعب",
                         "Verification Code has been Sent": "تم ارسال رمز التفعيل",
                         "Player" : "لاعب",
                         "Owner" : "صاحب ملعب",
                         "Ok" : "تم",
                         "Enter Field Name" : "ادخل اسم الملعب",
                         "Field Name" : "اسم الملعب",
                         "Enter Address" : "ادخل العنوان",
                         "Address" : "العنوان" ,
                         "Enter Field Type" : "ادخل نوع أرضيه الملعب",
                         "Field Type" : "نوع الأرضيه ",
                         "Enter Price for Hour" : "ادخل سعر الساعه",
                         "Price" : "السعر",
                         "Attendance" : "تاكيد حضور",
                         "Confirm " : "تاكيد حجز",
                         "You Can't cancel Attendance" : "لا يمكنك الفاء حجز لاعب بعد تاكيده",
                         "Network timeout" : "حاول مرة اخرى",
                         "No Playfields matched your Search." : "لم نجد ملاعب مطابقه لبحثك",
                         "Wrong Old Password" : "رقم المرور القديم خاطْئ",
                         "mobile number already exist" :"رقم الهاتف مستخدم من قبل",
                         "Username already exist, please choose another one" : "الاسم مستخدم من قبل" ,
                         "Sorry some error occurred, please try again later" : "حدث خطأ, حاول مره اخري" ,
                         "Request can't be empty" : "جميع الحقول مطلوبه" ,
                         "User not found" : "هذا الحساب غير مسجل,برجاءالتاكد من البيانات" ,
                         "Wrong password" : "خطأ في رقم المرور" ,
                         "User not confirmed" : "برجاء تفعيل رقم الهاتف" ,
                         "Mobile number is required in order to create user." : "رقم الهاتف مطلوب لاتمام عمليه التسجيل",
                         "Mobile number already exist, please try another one." : "رقم الهاتف مستخدم من قبل",
                         "Sorry some error occurred, please try again later.": "حدث خطأ, حاول مره اخري",
                         "New user, please send with valid mobile number" : "رقم الهاتف مطلوب لاتمام عمليه التسجيل",
                         "Logging out!!" : "تسجيل الخروج!!",
                         "proceed with the process?" : "تأكيد العملية؟",
                         "Cancel Reservation!!" : "الغاء الحجز!!" ,
                         "Position" : "التمركز",
                         "Pick Team" : "إختر فريق",
                         "Not Enough Points!!": "لا توجد نقاط كافيه!!",
                         "Wait for our representative Call" : "انتظر إتصال  من الإداره"
         //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        //                             "":"",
        
    ]
    // langDicClass().getLocalizedTitle("Confirm")
    
    func getLocalizedTitle(_ title : String) -> String {
        if L102Language.currentAppleLanguage() == "ar" {
            if let arTitle = dict[title] {
                print("that's the loclized value : \(arTitle)")
                return arTitle
            }
        }
        print("that's the loclized value : \(title)")
        return title
    }
    
    
}
}
