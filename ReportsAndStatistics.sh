#! /usr/bin/bash

Report_and_Statistics_Menu(){
echo Report and Statistics Menu:

declare -a options=("Student Transcript + GPA" "Subject Statistics" "Top Students by GPA" "Failing Students Report" "Full Grade Matrix" "Back to main menu")

select option in "${options[@]}"
do
	case $option in 
		"Student Transcript + GPA")
		Student_Transcript_GPA
			;;
		"Subject Statistics")
		subject_statistics
			;;
		"Top Students by GPA")
		Top_Students_by_GPA
			;;
		"Failing Students Report")
		Failing_Students_Report
			;;
		"Full Grade Matrix")
		full_grade_matrix
			;;
		"Back to main menu")
			break
			;;
esac

done
}

Calculate_GPA(){
    studID=$1
    totalPoints=0
    totalCredits=0

    for subFile in sgms_data/subjects/*.sub
    do
        subCode=$(sed -n '1p' "$subFile")
        credits=$(sed -n '3p' "$subFile")

        gradeFile="sgms_data/grades/$subCode.grd"

        if [[ -f "$gradeFile" ]]; then
            line=$(grep "^$studID|" "$gradeFile")

            if [[ -n "$line" ]]; then
                letter=$(echo "$line" | cut -d'|' -f3)

                case $letter in
                    A+|A) points=4.0 ;;
                    A-) points=3.7 ;;
                    B+) points=3.3 ;;
                    B) points=3.0 ;;
                    B-) points=2.7 ;;
                    C+) points=2.3 ;;
                    C) points=2.0 ;;
                    C-) points=1.7 ;;
                    D) points=1.0 ;;
                    F) points=0.0 ;;
                esac

                totalPoints=$(awk "BEGIN {print $totalPoints + ($points * $credits)}")
                totalCredits=$(awk "BEGIN {print $totalCredits + $credits}")
            fi
        fi
    done

    if [[ $totalCredits != 0 ]]; then
        awk "BEGIN {print $totalPoints / $totalCredits}"
    else
        echo "No grades for that student id"
    fi
}

Student_Transcript_GPA(){
while true;do
	read -p "Enter student id: " studID
	if [[ -z $studID ]];then
	echo "Invalid! Please enter student id"
	continue
	fi
	if [[ ! -f sgms_data/students/$studID.stu ]];then
	echo "Student doesn't exist"
	continue
	fi
	break
done

echo "=============================== Student Data ==============================="
cat "sgms_data/students/$studID.stu"
echo "================================ Transcript ================================"

for subFile in sgms_data/subjects/*.sub
do
subCode=$(sed -n '1p' "$subFile")
subName=$(sed -n '2p' "$subFile")
credits=$(sed -n '3p' "$subFile")

gradeFile="sgms_data/grades/$subCode.grd"

if [[ -f "$gradeFile" ]]; then
line=$(grep "^$studID|" "$gradeFile")
	if [[ -n "$line" ]]; then
	score=$(echo "$line" | cut -d'|' -f2)
	letter=$(echo "$line" | cut -d'|' -f3)
	echo "$subCode - $subName | Score : $score | Grade: $letter"
	fi
fi
done

echo "============================================================================"
gpa=$(Calculate_GPA "$studID")
echo "GPA: $gpa"
echo "============================================================================"    
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

Top_Students_by_GPA(){
echo "=========================== Top Students by GPA ============================"
for stuFile in sgms_data/students/*.stu
do
studID=$(basename "$stuFile" .stu)
name=$(grep "^Name=" "$stuFile" | cut -d'=' -f2)
gpa=$(Calculate_GPA "$studID")

echo "$studID | $name | $gpa"
done | sort -t'|' -k3 -nr
}

Failing_Students_Report(){
echo "===== Failing Students ====="

for stuFile in sgms_data/students/*.stu
do
studID=$(grep "^ID=" "$stuFile" | cut -d'=' -f2)
name=$(grep "^Name=" "$stuFile" | cut -d'=' -f2)
gpa=$(Calculate_GPA "$studID")

if [[ "$gpa" == "0" || "$gpa" == "0.00" ]]; then
echo "$studID | $name | GPA: $gpa"
fi
done
}

full_grade_matrix(){
echo "================================================================================="
echo "                            Full Grade Matrix                     "
echo "================================================================================="
printf "%-12s %-20s %-10s"  "Student ID" "Student Name" "Year"
declare -a subjects=()
for sub in sgms_data/subjects/*.sub
do
	subCode=$(sed -n '1p' $sub)
	subName=$(sed -n '2p' $sub)
	printf "%-15s"  "$subName($subCode)"
	subjects+=("$subCode")
done
echo
echo "---------------------------------------------------------------------------------"
for stu in sgms_data/students/*.stu
do
	studID=$(sed -n '1p' $stu | cut -d'=' -f2)
	studName=$(sed -n '2p' $stu | cut -d'=' -f2)
	studYear=$(sed -n '4p' $stu | cut -d'=' -f2)
	printf "%-12s %-20s %-10s"  "$studID" "$studName" "$studYear"
	
	for subCode in "${subjects[@]}"
	do
		if grep -q "^$studID|" sgms_data/grades/$subCode.grd
		then
		score=$(grep "^$studID|" sgms_data/grades/$subCode.grd | cut -d'|' -f2)
		letter=$(grep "^$studID|" sgms_data/grades/$subCode.grd | cut -d'|' -f3)
		printf "%-15s" "$score($letter)"
		else
		printf "%-15s" "---"
		fi
	done
	echo
done
}

