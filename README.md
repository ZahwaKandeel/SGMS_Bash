# 🎓 Student Grade Management System (SGMS)
> A CLI menu-based Bash application for managing students, subjects, and grades using flat-file storage — no external databases required.

---

## 📋 Project Overview

SGMS is a Bash shell script project that supports full CRUD operations, input validation, and statistical reports through an interactive terminal menu.

## 🛠️ Tech Stack

- **Language:** Bash Shell Script
- **Storage:** Flat files (`.stu`, `.sub`, `.grd`)
- **Tools:** `awk`, `sed`, `grep`

## 📁 Project Structure

```
SGMS_Bash_Project/
  ├── data/
  │   ├── grades/
  │   ├── reports&statistics/
  │   ├── students/
  │   └── subjects/
  ├── GradeManagement.sh
  ├── MainMenu.sh
  ├── README.md
  ├── Reports&Statistics.sh
  ├── StudentManagement.sh
  └── SubjectManagement.sh
```

## 🚀 How to Run

```bash
bash MainMenu.sh
```

---

## 👥 Team Task Distribution

### 👤 Zahwa Kandeel — Main Menu · Student Management · Grade Management

#### Main Menu (`MainMenu.sh`)
- Application entry point and navigation loop
- Routing user input to all sub-menus
- Exit handling and session control

#### Student Management (`StudentManagement.sh`)
- Add, list, update, and delete students
- Validate Student ID, name, email, and academic year
- Manage student records in `data/students/`

#### Grade Management (`GradeManagement.sh`)
- Assign, update, and delete grades
- View grades by subject or by student
- Validate score range and compute letter grades
- Manage grade records in `data/grades/`

---

### 👤 Nada Ayman — Subject Management · Reports & Statistics

#### Subject Management (`SubjectManagement.sh`)
- Add, list, update, and delete subjects
- Validate subject code format and credit hours
- Manage subject records in `data/subjects/`

#### Reports & Statistics (`Reports&Statistics.sh`)
- Student Transcript + GPA calculation
- Subject statistics (averages, distributions)
- Top students by GPA report
- Failing students report
- Full grade matrix view
- Manage output in `data/reports&statistics/`

---
