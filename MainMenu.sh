#! /usr/bin/bash

source ./StudentManagement.sh
source ./GradeManagement.sh

echo Main Menu:

declare -a options=("Manage Students" "Manage Subjects" "Manage Grades" "Reports & Statistics" "Exit")

select option in "${options[@]}"
do
	case $option in 
		"Manage Students")
		Student_Management_Menu
			;;
		"Manage Subjects")
		Grade_Management_Menu
			;;
		"Manage Grades")
			
			;;
		"Reports & Statistics")
			
			;;
		"Exit")
			break
			;;
esac

done
