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

}

Delete_Student(){
while true;do
	read -p "Enter student id you want to delete: " studID
	if [[ -z $studID || $studID =~ ^[A-Za-z] ]]
	then
		echo "Enter valid student id"
		continue
	fi
	if [[ ! -f sgms_data/students/$studID.stu ]]
	then
		echo "That student id doesn't exist"
		continue
	fi
	break
done

rm sgms_data/students/$studID.stu
echo "Student deleted successfully"
}
