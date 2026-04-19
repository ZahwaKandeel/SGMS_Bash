#! /usr/bin/bash

Grade_Management_Menu(){
echo Grade Management:

declare -a options=("Assign Grade to Student" "Update Existing Grade" "Delete a Grade" "View Grades by Subject" "View Grades by Student" "Back to main menu")

select option in "${options[@]}"
do
	case $option in 
		"Assign Grade to Student")
		Assign_Grade_to_Student
			;;
		"Update Existing Grade")
		update_grade
			;;
		"Delete a Grade")
		Delete_Grade
			;;
		"View Grades by Subject")
		view_grades_by_subject
			;;
		"View Grades by Student")
		view_grades_by_student
			;;
		"Back to main menu")
			break
			;;
esac

done
}

Assign_Grade_to_Student(){
while true;do
	read -p "Enter subject code: " subCode
	if [[ -z $subCode ]];then
	echo "Invalid! Please enter subject code"
	continue
	fi
	if [[ ! -f sgms_data/subjects/$subCode.sub ]];then
	echo "Subject doesn't exist"
	continue
	fi
	break
done

file="./sgms_data/grades/$subCode.grd"

while true;do
	read -p "Enter student id: " studId
	if [[ -z $studId ]];then
	echo "Invalid! Please enter student id"
	continue
	fi
	if [[ ! -f sgms_data/students/$studId.stu ]];then
	echo "Student doesn't exist"
	continue
	fi
	if [[ -f "$file" ]] && grep -q "^$studId|" "$file"; then
	echo "This student already has a grade for this subject"
	continue
	fi
	break
done

while true;do
	read -p "Enter your score: " studScore
	if [[ -z $studScore || ! $studScore =~ ^[0-9]+(\.[0-9]+)?$ ]];then
	echo "Invalid! Score must be between 0 - 100 "
	continue
	fi
	if awk "BEGIN {exit !($studScore > 100 || $studScore < 0 )}"
	then
	echo "Score must be between 0.0 and 100.0"
	continue
	fi
	break
done

if awk "BEGIN {exit !($studScore >= 90)}"; then letter="A+"
elif awk "BEGIN {exit !($studScore >= 85)}"; then letter="A"
elif awk "BEGIN {exit !($studScore >= 80)}"; then letter="A-"
elif awk "BEGIN {exit !($studScore >= 75)}"; then letter="B+"
elif awk "BEGIN {exit !($studScore >= 70)}"; then letter="B"
elif awk "BEGIN {exit !($studScore >= 65)}"; then letter="B-"
elif awk "BEGIN {exit !($studScore >= 60)}"; then letter="C+"
elif awk "BEGIN {exit !($studScore >= 55)}"; then letter="C"
elif awk "BEGIN {exit !($studScore >= 50)}"; then letter="C-"
elif awk "BEGIN {exit !($studScore >= 45)}"; then letter="D"
else letter="F"
fi

echo "$studId|$studScore|$letter" >> "$file"

echo "Student grade assigned successfully"
}

update_grade(){
while true
do
	read -p "Enter subject code : " subCode
	if [[ -z $subCode || ! $subCode =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
	then
	echo "Invalid subject code, it must be 2–5 uppercase letters + 2–4 digits"
	continue
	fi
	if [[ ! -f sgms_data/grades/$subCode.grd ]]
	then
	echo "No grades for this subject"
	continue
	fi
	break
done
cat sgms_data/grades/$subCode.grd

while true
do
	read -p "Enter student id that you want to update his grade : " studID
	if [[ -z $studID || ! "$studID" =~ ^[0-9]{1,10}$ ]]
	then
	echo "Invalid student id, it must be number"
	continue
	fi
	if ! grep -q "^$studID|" sgms_data/grades/$subCode.grd
	then
	echo "This student doesn't exist"
	continue
	fi
	break
done

while true
do
	read -p "Enter new score : " newScore
	if [[ -z $newScore ]]
	then
	echo "You should enter a score"
	continue
	fi
	if [[ ! $newScore =~ ^[0-9]+(\.[0-9]+)?$ ]]
	then
	echo "Invalid score format, it must be float number between 0.0 and 100.0"
	continue
	fi
	if awk "BEGIN {exit !($newScore > 100 || $newScore < 0 )}"
	then
	echo "Score must be between 0.0 and 100.0"
	continue
	fi
	break
done

if awk "BEGIN {exit !($newScore >= 90)}"; then newLetter="A+"
elif awk "BEGIN {exit !($newScore >= 85)}"; then newLetter="A"
elif awk "BEGIN {exit !($newScore >= 80)}"; then newLetter="A-"
elif awk "BEGIN {exit !($newScore >= 75)}"; then newLetter="B+"
elif awk "BEGIN {exit !($newScore >= 70)}"; then newLetter="B"
elif awk "BEGIN {exit !($newScore >= 65)}"; then newLetter="B-"
elif awk "BEGIN {exit !($newScore >= 60)}"; then newLetter="C+"
elif awk "BEGIN {exit !($newScore >= 55)}"; then newLetter="C"
elif awk "BEGIN {exit !($newScore >= 50)}"; then newLetter="C-"
elif awk "BEGIN {exit !($newScore >= 45)}"; then newLetter="D"
else newLetter="F"
fi

echo "Grade updated successfully"
sed -i "s/^$studID|.*/$studID|$newScore|$newLetter/" sgms_data/grades/$subCode.grd
grep "^$studID|" sgms_data/grades/$subCode.grd
}

Delete_Grade(){
while true;do
	read -p "Enter subject to remove in its grade: " subCode
	if [[ -z $subCode ]];then
	echo "Invalid! Please enter subject code"
	continue
	fi
	if [[ ! -f sgms_data/grades/$subCode.grd ]];then
	echo "Subject doesn't exist"
	continue
	fi
	break
done

while true;do
	read -p "Enter student id you want to remove: " studId
	if [[ -z $studId ]];then
	echo "Invalid! Please enter student id"
	continue
	fi
	if [[ ! -f sgms_data/students/$studId.stu ]];then
	echo "Student doesn't exist"
	continue
	fi
	break
done

file="./sgms_data/grades/$subCode.grd"

while true;do
	if [[ -f "$file" ]] && grep -q "^$studId|" "$file"; then
	sed -i "/^$studId|/d" "$file"
	echo "This student grade has been removed"
	continue
	fi
	break
done
}

view_grades_by_subject(){
while true
do
	read -p "Enter subject code : " subCode
	if [[ -z $subCode || ! $subCode =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
	then
	echo "Invalid subject code, it must be 2–5 uppercase letters + 2–4 digits"
	continue
	fi
	if [[ ! -f sgms_data/subjects/$subCode.sub ]]
	then
	echo "This subject doesn't exist"
	continue
	fi
	if [[ ! -f sgms_data/grades/$subCode.grd || ! -s sgms_data/grades/$subCode.grd ]]
	then
	echo "No grades for this subject"
	continue
	fi
	break
done
subName=$(sed -n '2p' sgms_data/subjects/$subCode.sub)
echo "=================================================="
echo "         Grades for $subName (Code: $subCode)"
echo "=================================================="
printf "%-12s %-15s %-10s %-5s\n" "Student ID" "Student Name" "Score" "Grade"
echo "--------------------------------------------------"
while IFS="|" read studID score letter
do
if [[ -f sgms_data/students/$studID.stu ]]
then
studName=$(sed -n '2p' sgms_data/students/$studID.stu | cut -d'=' -f2)
else
studName="--"
fi
printf "%-12s %-15s %-10s %-5s\n" "$studID" "$studName" "$score" "$letter"
done < sgms_data/grades/$subCode.grd 
}

view_grades_by_student(){
while true
do
	read -p "Enter student ID: " studID
	if [[ -z $studID || ! "$studID" =~ ^[0-9]{1,10}$ ]]
	then
	echo "Invalid student id, it must be number"
	continue
	fi
	if [[ ! -f sgms_data/students/$studID.stu ]]
	then
	echo "This student doesn't exist"
	continue
	fi
	break
done
studName=$(sed -n '2p' sgms_data/students/$studID.stu | cut -d'=' -f2)

echo "=================================================="
echo "         Grades for $studName (ID: $studID)"
echo "=================================================="
printf "%-15s %-15s %-10s %-5s\n" "Subject code" "Subject Name" "Score" "Grade"
echo "--------------------------------------------------"
found=0
for file in sgms_data/grades/*.grd
do
	if grep -q "^$studID|" $file
	then
	subCode=$(echo $file | cut -d'/' -f3 | cut -d'.' -f1)
	subName=$(sed -n '2p' sgms_data/subjects/$subCode.sub)
	score=$(grep "^$studID|" $file | cut -d'|' -f2)
	letter=$(grep "^$studID|" $file | cut -d'|' -f3)
	printf "%-15s %-15s %-10s %-5s\n" "$subCode" "$subName" "$score" "$letter"
	found=1
	fi
done
if [[ $found -eq 0 ]]
then
echo "No grades for this student"
fi
}


