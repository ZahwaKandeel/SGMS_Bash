#! /usr/bin/bash

Report_and_Statistics_Menu(){
echo Report and Statistics Menu:

declare -a options=("Student Transcript + GPA" "Subject Statistics" "Top Students by GPA" "Failing Students Report" "Full Grade Matrix" "Back to main menu")

select option in "${options[@]}"
do
	case $option in 
		"Student Transcript + GPA")
	
			;;
		"Subject Statistics")
	
			;;
		"Top Students by GPA")
		
			;;
		"Failing Students Report")
			
			;;
		"Full Grade Matrix")
		
			;;
		"Back to main menu")
			break
			;;
esac

done
}
