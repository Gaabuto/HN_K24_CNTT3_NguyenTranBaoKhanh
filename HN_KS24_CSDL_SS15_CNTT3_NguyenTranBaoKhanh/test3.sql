/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File


-- bai 1

delimiter //
create trigger tg_CheckScore
before insert
on grades for each row
begin
if new.score <0 then set new.score = 0;
elseif new.score > 10 then set new.score = 10;
end if;
end //
delimiter ;


-- bai 2


start transaction;

insert into students (studentid, fullname)
values ('sv02', 'ha bich ngoc');

update students
set totaldebt = 5000000
where studentid = 'sv02';

commit;

-- bai 3

delimiter //
create trigger tg_LogGradeUpdate
after update
on grades for each row
begin
if( old.score<> new.score) then
insert into GradeLog(StudentID,OldScore,NewScore,ChangeDate)
values
(old.studentId,old.score,new.score,now());
end if;
end //
delimiter ;

-- bai 4

delimiter //
create procedure sp_PayTuition()
start transaction;
begin
    update students
    set totaldebt = totaldebt - 2000000
    where studentId = 'sv01';
    
	declare dept decimal;
    select dept into dept from students where studentId = 'sv01';
    
    if dept < 0 then rollback end if;
	commit ;
end ;
delimiter ;

-- bai 5

delimiter //
create trigger tg_PreventPassUpdate
before update
on grades for each row
begin
	if(old.score) > 4.0 then
    signal sqlstate '45000'
	set message_text = 'Khong the sua diem';
    end if;
end //

delimiter ;

-- bai 6
delimiter //
create procedure sp_DeleteStudentGrade(p_StudentID char(5), p_SubjectID char(5))
start transaction;
begin

declare delete_score decimal(4,2);
select score into delete_score from grades where studentId = p_StudentID and subjectId = p_SubjectID;
	insert into GradeLog(studentId,OldScore,NewScore,ChangeDate)
    values(p_StudentID,delete_score,null,now());
    
delete from grades
where studentId = p_StudentID and subjectId = p_SubjectID;

if row_count() = 0 then rollback end if;
commit;

end ;
delimiter ;

call sp_DeleteStudentGrade('SV01','SB01')