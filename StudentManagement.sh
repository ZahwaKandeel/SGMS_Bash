#! /usr/bin/bash

Student_Management_Menu(){
echo Student Management:

declare -a options=("Add Student" "List Students" "Update Student" "Delete Student" "Back to main menu")

select option in "${options[@]}"
do
	case $option in 
		"Add Student")
			
			;;
		"List Subjects")
			
			;;
		"Update Student")
			
			;;
		"Delete Student")
			
			;;
		"Back to main menu")
			break
			;;
esac

done
}
