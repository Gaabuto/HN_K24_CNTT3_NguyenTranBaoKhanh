create database test1;
use test1;

-- bai 1
create table student(
student_id varchar(50) primary key,
student_name varchar(50) not null,
student_gmail varchar(50) not null unique,
student_phone varchar(12) not null unique
);

create table course(
course_id varchar(50) primary key,
course_name varchar(50) not null unique,
credit int not null check(credit>0)
);

create table enrollment(
student_id varchar(50),
course_id varchar(50),
grade float not null default 0 check (grade between 0 and 10),
foreign key (student_id) references student(student_id),
foreign key (course_id) references course(course_id),
primary key ( student_id, course_id)
);

-- bai 2
insert into student
values
('b24dtcn001', 'Nguyen Van A',  'khannh04060a@gmail.com',  '0967353728' ),
('b24dtcn002', 'Nguyen Van B',  'khannh04060b@gmail.com', '0123232767' ),
('b24dtcn003', 'Nguyen Van C',  'khannh04060c@gmail.com', '0912120123' ),
('b24dtcn004', 'Nguyen Van D', 'khannh04060d@gmail.com', '09233433264'),
('b24dtcn005', 'Nguyen Van E', 'khannh04060e@gmail.com', '09267965734');

insert into course
values
('C101', 'Van', '15'),
('C002','toan','15'),
('C003', 'anh', '15'),
('C004', 'ly', '7'),
('C005', 'hoa', '7');

insert into enrollment
values
('b24dtcn001', 'C101', '7.6'),
('b24dtcn002', 'C002', '9.5'),
('b24dtcn003', 'C005', '5.7'),
('b24dtcn004', 'C004', '10'),
('b24dtcn005', 'C003', '6.9');


update enrollment
set grade = '9' where student_id = 'b24dtcn002';

update enrollment
set grade = '9' where student_id = 'b24dtcn003';

select student_name, student_gmail, student_phone from student;

-- bai 3

delete from enrollment 
where course_id = 'C101';

delete from course
where course_id = 'C101';

-- vi co khoa ngoai vao nen khong the xoa neu chua xoa khoa ngoai cua no

