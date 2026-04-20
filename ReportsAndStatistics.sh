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
		subject_statistics
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

subject_statistics(){ 
while true 
do read -p "Enter subject code : " subCode 
	if [[ -z $subCode || ! $subCode =~ ^[A-Z]{2,5}[0-9]{2,4}$ ]] 
	then 
	echo "Invalid subject code, it must be 2–5 uppercase letters + 2–4 digits" 
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
echo "             $subName (Code: $subCode)            " 
echo "==================================================" 
awk ' 
BEGIN{ 
	FS="|" 
	count=0 
	max=0 
	min=0 
	sum=0 
} 
{ 
	count++ 
	if (count == 1 || $2 > max){ 
	max=$2 
	} 
	if (count == 1 || $2 < min){ 
	min=$2 
	} 
	sum += $2 
} 
END{ 
print "Total Students: " count 
print "Highest Score:  " max 
print "Lowest Score:   " min 
print "Average Score:  " sum/count 
} ' sgms_data/grades/$subCode.grd 

echo "=================================================="
}
