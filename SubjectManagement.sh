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
	if [[ ! $subCode =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]]
	then
	echo "Subject code must be 2–5 uppercase letters + 2–4 digits"
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
	echo "You should enter credit hours"
	continue
	fi
	if [[ ! $subCredits =~ ^[1-6]$ ]]
	then
	echo "Subject credit hours must be a number from 1 to 6"
	continue
	fi
	break
done

echo "$subCode" > sgms_data/subjects/$subCode.sub
echo "$subName" >> sgms_data/subjects/$subCode.sub
echo "$subCredits" >> sgms_data/subjects/$subCode.sub
echo "Subject file created successfully"
touch sgms_data/grades/$subCode.grd
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

update_subject(){
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
	break
done
echo "Code: $(sed -n '1p' sgms_data/subjects/$subCode.sub)"
echo "Name: $(sed -n '2p' sgms_data/subjects/$subCode.sub)"
echo "Credit Hours: $(sed -n '3p' sgms_data/subjects/$subCode.sub)"

while true
do
read -p "Enter the field you want to update (name - credits) : " field
if [[ ! $field == "name" && ! $field == "credits" ]]
then
echo "Invalid field"
continue
fi
break
done

if [[ $field == "name" ]] 
then
while true
do
	read -p "Enter subject name: " newName
	if [[ -z $newName ]]
	then
	echo "You should enter a name"
	continue
	fi
	break
done
sed -i "2s/.*/$newName/" sgms_data/subjects/$subCode.sub
echo "Subject name updated successfully"
echo "Code: $(sed -n '1p' sgms_data/subjects/$subCode.sub)"
echo "Name: $(sed -n '2p' sgms_data/subjects/$subCode.sub)"
echo "Credit Hours: $(sed -n '3p' sgms_data/subjects/$subCode.sub)"

elif [[ $field == "credits" ]] 
then
while true
do
	read -p "Enter subject credit hours: " newCredits
	if [[ -z $newCredits ]]
	then
	echo "You should enter credit hours"
	continue
	fi
	if [[ ! $newCredits =~ ^[1-6]$ ]]
	then
	echo "Subject credit hours must be a number from 1 to 6"
	continue
	fi
	break
done
sed -i "3s/.*/$newCredits/" sgms_data/subjects/$subCode.sub
echo "Subject credit hours updated successfully"
echo "Code: $(sed -n '1p' sgms_data/subjects/$subCode.sub)"
echo "Name: $(sed -n '2p' sgms_data/subjects/$subCode.sub)"
echo "Credit Hours: $(sed -n '3p' sgms_data/subjects/$subCode.sub)"
fi
}

delete_subject(){
while true
do 
	read -p "Enter subject code you want to delete: " subCode
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
	break
done

rm sgms_data/subjects/$subCode.sub
rm sgms_data/grades/$subCode.grd
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




