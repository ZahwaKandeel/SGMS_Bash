#! /usr/bin/bash

add_subject(){
while true
do
	read -p "Enter subject code: " subCode
	if [[ -z $subCode ]]
	then
	echo "You should enter a code"
	continue
	fi
	if [[ ! $subCode =~ ^[A-Za-z]{2,5}[0-9]{2,4}$ ]]
	then
	echo "Subject code must be 2–5 letters + 2–4 digits"
	continue
	fi
	if [[ -f sgms_data/subjects/$subCode.sub ]]
	then
	echo "This subject already exists"
	continue
	fi
	break
done

while true
do
	read -p "Enter subject name: " subName
	if [[ -z $subName ]]
	then
	echo "You should enter a name"
	continue
	fi
	break
done

while true
do
	read -p "Enter subject credit hours: " subCredits
	if [[ -z $subCredits ]]
	then
	echo "You should enter a credit hours"
	continue
	fi
	if [[ ! $subCredits =~ ^[0-9]{1,6}$ ]]
	then
	echo "Subject credit hours must be 1-6 digits"
	continue
	fi
	break
done

touch $subCode.sub
echo "$subCode" >> sgms_data/subjects/$subCode.sub
echo "$subName" >> sgms_data/subjects/$subCode.sub
echo "$subCredits" >> sgms_data/subjects/$subCode.sub
echo "Subject file created successfully"
}

list_subjects(){
if [ "$(ls -A sgms_data/subjects)" ]
then
	echo "These are all subjects"
	ls -A sgms_data/subjects
else
	echo "There are no subjects"
fi
}

delete_subject(){
while true
do 
	read -p "Enter subject code you want to delete: " subCode
	if [[ -z $subCode ]]
	then
	echo "You should enter a code"
	continue
	fi
	if [[ ! -f sgms_data/subjects/$subCode.sub ]]
	then
	echo "This subject doesn't exist"
	continue
	fi
	break
done

rm sgms_data/subjects/$subCode.sub
echo "Subject deleted successfully"
}

Subject_Management_Menu(){
declare -a arr=("Add Subject" "List Subjects" "Update Subject" "Delete Subject" "Back to main menu")
select choice in "${arr[@]}"
do
	case $choice in 
"Add Subject")
	add_subject
	;;
"List Subjects")
	list_subjects
	;;
"Update Subject")
	update_subject
	;;
"Delete Subject")
	delete_subject
	;;
"Back to main menu")
	break
	;;
*)
	echo Invalid Choice
	;;
esac
done
}




