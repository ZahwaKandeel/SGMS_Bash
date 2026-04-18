#! /usr/bin/bash

Student_Management_Menu(){
echo Student Management:

declare -a options=("Add Student" "List Students" "Update Student" "Delete Student" "Back to main menu")

select option in "${options[@]}"
do
	case $option in 
		"Add Student")
		 Add_Student
			;;
		"List Students")
		List_Students
			;;
		"Update Student")
		Update_Student	
			;;
		"Delete Student")
		Delete_Student	
			;;
		"Back to main menu")
			break
			;;
esac

done
}

Add_Student(){
while true;do
	read -p "Enter your id: " studID
	if [[ ! "$studID" =~ ^[0-9]{1,10}$ ]];then
	echo "Student ID must be number"
	continue
	fi
	if [[ -f "./sgms_data/students/$studID.stu" ]];then
	echo "Student ID already exists"
	continue
	fi
	break
done
	
while true;do
	read -p "Enter your full name: " studName
	if [[ -z "$studName" || ! "$studName" =~ ^[A-Za-z]+([[:space:]][A-Za-z]+)*$ ]];then
	echo "Invalid full name!"
	continue
	fi
	break
done

while true;do
	read -p "Enter your email: " studEmail
	if [[ -z "$studEmail" || ! "$studEmail" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]];then
	echo "Invalid email!"
	continue
	fi
	break
done

while true;do
	read -p "Enter your academic year: " studYear
	if [[ -z "$studYear" || ! "$studYear" =~ ^[1-6]$ ]];then
	echo "Invalid Academic Year!"
	continue
	fi
	break
done

mkdir -p "./sgms_data/students"

file="./sgms_data/students/$studID.stu"
{
echo "ID=$studID"
echo "Name=$studName"
echo "Email=$studEmail"
echo "Year=$studYear"
} > "$file"

echo "Student added successfully"
}

List_Students(){
	if [ -d "sgms_data/students" ] && [ "$(ls -A sgms_data/students)" ]
	then
	ls  sgms_data/students
	echo Thats all the students
	else
	echo There is no saved students
	fi
}

Update_Student(){
while true;do
	read -p "Enter Student ID you want to update: " studID
	if [[ -z $studID || ! $studID =~ ^[0-9]{1,10}$ ]];then
	echo "Invalid! Please enter student ID"
	continue
	fi
	if [[ ! -f sgms_data/students/$studID.stu ]];then
	echo "Student ID doesn't exist"
	continue
	fi
	break
done

echo "$(sed -n '1p' sgms_data/students/$studID.stu)"
echo "$(sed -n '2p' sgms_data/students/$studID.stu)"
echo "$(sed -n '3p' sgms_data/students/$studID.stu)"
echo "$(sed -n '4p' sgms_data/students/$studID.stu)"

while true;do
	read -p "Which field you want to update? " field
	if [[ $field != "name" && $field != "email" && $field != "year" ]];then
	echo "Invalid! Please choose from the field"
	continue
	fi
	break
done

if [[ $field == "name" ]];then
while true;do
	read -p "Enter new student name: " newStudName
	if [[ -z $newStudName || ! $newStudName =~ ^[A-Za-z]+([[:space:]][A-Za-z]+)*$ ]];then
	echo "Invalid! Enter full name again"
	continue
	fi 
	break
done

sed -i "2s/.*/Name=$newStudName/" sgms_data/students/$studID.stu
echo "Full Name updated successfully"

echo "$(sed -n '1p' sgms_data/students/$studID.stu)"
echo "$(sed -n '2p' sgms_data/students/$studID.stu)"
echo "$(sed -n '3p' sgms_data/students/$studID.stu)"
echo "$(sed -n '4p' sgms_data/students/$studID.stu)"

elif [[ $field == "email" ]];then
while true;do
	read -p "Enter new student email: " newStudEmail
	if [[ -z $newStudEmail || ! $newStudEmail =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]];then
	echo "Invalid! Enter email again"
	continue
	fi 
	break
done

sed -i "3s/.*/Email=$newStudEmail/" sgms_data/students/$studID.stu
echo "Email updated successfully"

echo "$(sed -n '1p' sgms_data/students/$studID.stu)"
echo "$(sed -n '2p' sgms_data/students/$studID.stu)"
echo "$(sed -n '3p' sgms_data/students/$studID.stu)"
echo "$(sed -n '4p' sgms_data/students/$studID.stu)"

elif [[ $field == "year" ]];then
while true;do
	read -p "Enter new academic year: " newStudYear
	if [[ -z $newStudYear || ! $newStudYear =~ ^[1-6]$ ]];then
	echo "Invalid! Enter academic year again"
	continue
	fi 
	break
done

sed -i "4s/.*/Year=$newStudYear/" sgms_data/students/$studID.stu
echo "Year updated successfully"

echo "$(sed -n '1p' sgms_data/students/$studID.stu)"
echo "$(sed -n '2p' sgms_data/students/$studID.stu)"
echo "$(sed -n '3p' sgms_data/students/$studID.stu)"
echo "$(sed -n '4p' sgms_data/students/$studID.stu)"

fi
}

Delete_Student(){
while true;do
	read -p "Enter student id you want to delete: " studID
	if [[ -z $studID || $studID =~ ^[A-Za-z] ]];then
	echo "Enter valid student id"
	continue
	fi
	if [[ ! -f sgms_data/students/$studID.stu ]];then
	echo "That student id doesn't exist"
	continue
	fi
	break
done

rm sgms_data/students/$studID.stu
echo "Student deleted successfully"
}
