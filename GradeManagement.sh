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
			
			;;
		"View Grades by Subject")
			
			;;
		"View Grades by Student")
			
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
	if [[ -z $studScore || ! $studScore =~ ^([1-9][0-9]?|100)$ ]];then
	echo "Invalid! Score must be between 1 - 100 "
	continue
	fi
	break
done

if (( $studScore >= 90 && $studScore <= 100 )); then
	letter="A+"
elif (( $studScore >= 85 )); then
	letter="A"
elif (( $studScore >= 80 )); then
	letter="A-"
elif (( $studScore >= 75 )); then
	letter="B+"
elif (( $studScore >= 70 )); then
	letter="B"
elif (( $studScore >= 65 )); then
	letter="B-"
elif (( $studScore >= 60 )); then
	letter="C+"
elif (( $studScore >= 55 )); then
	letter="C"
elif (( $studScore >= 50 )); then
	letter="C-"
elif (( $studScore >= 45 )); then
	letter="D"
else
	letter="F"
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
