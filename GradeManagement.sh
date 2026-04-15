#! /usr/bin/bash

Grade_Management_Menu(){
echo Student Management:

declare -a options=("Assign Grade to Student" "Update Existing Grade" "Delete a Grade" "View Grades by Subject" "View Grades by Student" "Back to main menu")

select option in "${options[@]}"
do
	case $option in 
		"Assign Grade to Student")
			
			;;
		"Update Existing Grade")
			
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
