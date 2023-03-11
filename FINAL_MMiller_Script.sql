--*************************************************************************--
-- Title: ITFnd130FINAL
-- User: MMiller
-- Desc: This FINAL is a creation of a Student Course Enrollment Database using skills from A01-A07.
--        Is not constructed to be a finanical transaction system or financial database.
-- Change Log: 
-- 2023-03-01, MMiller, altering file for FINAL
-- 2017-01-01,RRoot,Created File
--**************************************************************************--
--********************************************************************--
--[ Create the Database ]--
--********************************************************************--


USE MASTER
;

GO
BEGIN TRY
   IF EXISTS (
              SELECT *
		        FROM SYS.databases 
		       WHERE NAME='ITFnd130FinalDB_MMiller'
		     )
   BEGIN
	          ALTER DATABASE ITFnd130FinalDB_MMiller
	            SET SINGLE_USER
	            WITH ROLLBACK IMMEDIATE -- Kicks everyone out of the DB
			  ;
	          DROP DATABASE ITFnd130FinalDB_MMiller
	          ;
   END
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION
	 ;
	 PRINT N'ERROR - Database Not Created.'
	 ;
	 PRINT Error_Number() -- original RDMS Error Number
	 ;
	 PRINT Error_Message() -- original RDMS Error Message
	 ;
END CATCH

GO
CREATE DATABASE ITFnd130FinalDB_MMiller
;

GO
USE ITFnd130FinalDB_MMiller
;


--********************************************************************--
--[ Create the Tables ]--
--********************************************************************--
GO
CREATE TABLE t_ACADEMIC_SESSIONS
    (SESSION_ID int IDENTITY (1,1) NOT NULL -- syntax format of IDENTITY (starts using,interval)
	                CONSTRAINT pkc_SESSION_ID 
				    PRIMARY KEY CLUSTERED (SESSION_ID) 
   , SEASON_NAME varchar(6) NOT NULL     
   , ACADEMIC_YEAR date NOT NULL
   , ACADEMIC_QUARTER varchar(13) NOT NULL
   , QUARTER_START_DATE date NOT NULL 
   , QUARTER_END_DATE date NOT NULL   
     );

GO
CREATE TABLE t_COURSES
    (COURSE_ID int IDENTITY (1,1) NOT NULL 
	               CONSTRAINT pkc_COURSE_ID 
				   PRIMARY KEY CLUSTERED (COURSE_ID)
   , COURSE_NAME varchar(200) NOT NULL
   , ACADEMIC_QUARTER varchar(13) NOT NULL 
   , COURSE_START_DATE date NOT NULL
   , COURSE_END_DATE date NOT NULL
   , COURSE_START_TIME time NOT NULL
   , COURSE_END_TIME time NOT NULL
   , COURSE_DAYS varchar(28) NOT NULL
   , COURSE_PRICE money NOT NULL
    );

GO 
CREATE TABLE t_STUDENTS
    (STUDENT_ID bigint IDENTITY(1,1) NOT NULL 
                 CONSTRAINT pkc_STUDENT_ID 
                 PRIMARY KEY CLUSTERED (STUDENT_ID) 
   , STUDENT_NUMBER varchar(15) NOT NULL 
   , FIRST_NAME varchar(30) NOT NULL
   , LAST_NAME varchar(30) NOT NULL
   , EMAIL_ADDRESS varchar(50) NOT NULL
   , PHONE_NUMBER char(10)
   , ADDRESS_LINE_1 varchar(50) NOT NULL
   , ADDRESS_LINE_2 varchar(50)
   , CITY varchar(50) NOT NULL
   , STATE_CODE char(2) NOT NULL
-- , STATE_OR_PROVINCE_CODE char(2) NOT NULL
-- , COUNTRY_CODE char(3) NOT NULL
-- , US_ZIP_CODE char(5) NOT NULL
   , ZIP_CODE char(5) NOT NULL
-- , NON_US_POSTAL_CODE char(8)
   , TUITION_DISCOUNT money NOT NULL
     );

GO  
CREATE TABLE t_ENROLLMENT
    (ENROLLMENT_ID bigint IDENTITY(1,1) NOT NULL 
               CONSTRAINT pk_ENROLLMENT_ID 
               PRIMARY KEY CLUSTERED (ENROLLMENT_ID)
   , STUDENT_NUMBER varchar(15) NOT NULL
   , COURSE_ID int NOT NULL 
   , ENROLLMENT_DATE date NOT NULL 
   , COURSE_PRICE money NOT NULL
   , AMOUNT_PAID money NOT NULL
   );


 --********************************************************************--
--[ Add Addtional Constaints ]--
--********************************************************************--

-- Table Constraints: t_Academic_Sessions (Table 1 of 4)
GO
BEGIN
/*   ALTER TABLE dbo.t_ACADEMIC_SESSIONS -- moved action to table creation avoid script run error
       ADD CONSTRAINT pk_SESSION_ID 
       PRIMARY KEY CLUSTERED ([SESSION_ID])
     ;
*/
       ALTER TABLE dbo.t_ACADEMIC_SESSIONS
       ADD CONSTRAINT uq_QUARTER_START_DATE
       UNIQUE NONCLUSTERED ([QUARTER_START_DATE]) 
     ;

       ALTER TABLE dbo.t_ACADEMIC_SESSIONS
	   ADD CONSTRAINT uq_QUARTER_END_DATE
	   UNIQUE NONCLUSTERED ([QUARTER_END_DATE]) 
     ;

       ALTER TABLE dbo.t_ACADEMIC_SESSIONS
       ADD CONSTRAINT ck_QUARTER_START_DATE
	   CHECK ([QUARTER_START_DATE] < [QUARTER_END_DATE])
     ;

       ALTER TABLE dbo.t_ACADEMIC_SESSIONS
       ADD CONSTRAINT ck_QUARTER_END_DATE
	   CHECK ([QUARTER_END_DATE] > [QUARTER_START_DATE])
     ;
END


-- Table Constraints: t_COURSES (Table 2 of 4)
GO
BEGIN
/*   ALTER TABLE dbo.t_COURSES 
       ADD CONSTRAINT pkc_COURSE_ID
       PRIMARY KEY CLUSTERED ([COURSE_ID])
	 ;
*/
     ALTER TABLE dbo.t_COURSES
       ADD CONSTRAINT uq_COURSE_ID
       UNIQUE ([COURSE_ID])
	 ;

       ALTER TABLE dbo.t_COURSES 
       ADD CONSTRAINT ck_COURSE_START_DATE
	   CHECK ([COURSE_START_DATE] < [COURSE_END_DATE])
	 ;

       ALTER TABLE dbo.t_COURSES 
       ADD CONSTRAINT ck_COURSE_END_DATE
	   CHECK ([COURSE_END_DATE] > [COURSE_START_DATE])
	 ;

       ALTER TABLE dbo.t_COURSES 
       ADD CONSTRAINT ck_COURSE_START_TIME
	   CHECK ([COURSE_START_TIME] < [COURSE_END_TIME])
	 ;

       ALTER TABLE dbo.t_COURSES 
       ADD CONSTRAINT ck_COURSE_END_TIME
	   CHECK ([COURSE_END_TIME] > [COURSE_START_TIME])
	 ;

       ALTER TABLE dbo.t_COURSES 
       ADD CONSTRAINT ck_COURSE_PRICE
	   CHECK ([COURSE_PRICE] > 99)
	 ;
END


-- Table Constraints: t_STUDENTS (Table 3 of 4)
GO
BEGIN
/*
     ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT pkc_STUDENT_ID
       PRIMARY KEY CLUSTERED (STUDENT_ID)
     ;
*/
     ALTER TABLE dbo.t_STUDENTS
       ADD CONSTRAINT uq_STUDENT_ID
       UNIQUE (STUDENT_ID)
     ;

     ALTER TABLE dbo.t_STUDENTS
       ADD CONSTRAINT uq_STUDENT_NUMBER
       UNIQUE (STUDENT_NUMBER)
     ;

	 ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT ck_FIRST_NAME_NOT_UNK
	   CHECK (FIRST_NAME NOT IN ('example', 'unknown', 'unk', 'not applicable', 'n/a', 'no one', 'anyone', 'nobody', 'generic', 'none ya', '  ', '   '))
	 ;

     ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT ck_LAST_NAME_NOT_UNK
	   CHECK (LAST_NAME NOT IN ('example', 'unknown', 'unk', 'not applicable', 'n/a',  'no one', 'anyone', 'nobody', 'generic', 'none ya', '  ', '   '))
	 ;

     ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT ck_EMAIL_ADDRESS_FORMAT
	   CHECK (EMAIL_ADDRESS LIKE '%_@_%._%')
	 ;
     ALTER TABLE dbo.t_STUDENTS
       ADD CONSTRAINT uq_EMAIL_ADDRESS
       UNIQUE (EMAIL_ADDRESS)
     ;

     ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT ck_PHONE_NUMBER_FORMAT
	   CHECK (PHONE_NUMBER LIKE '[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
	 ;

     ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT ck_ZIP_CODE_FORMAT
	   CHECK ([ZIP_CODE] LIKE '[0-9][0-9][0-9][0-9][0-9]')
	 ;

     ALTER TABLE dbo.t_STUDENTS 
       ADD CONSTRAINT ck_ZIP_CODE_VALIDTY
	   CHECK ([ZIP_CODE] NOT IN ('00000', '11111', '99999'))
	 ;

     ALTER TABLE dbo.t_STUDENTS
       ADD CONSTRAINT df_TUITION_DISCOUNT
       DEFAULT '0.00' FOR [TUITION_DISCOUNT]
     ; 
END


-- Table Constraints: t_ENROLLMENT (Table 4 of 4)
GO
BEGIN
/*
     ALTER TABLE dbo.t_ENROLLMENT 
       ADD CONSTRAINT pk_ENROLLMENT_ID
       PRIMARY KEY (INVENTORY_ID)
     ;
*/
     ALTER TABLE dbo.t_ENROLLMENT
       ADD CONSTRAINT uq_ENROLLMENT_ID
       UNIQUE (ENROLLMENT_ID)
     ;

     ALTER TABLE dbo.t_ENROLLMENT
      ADD CONSTRAINT fk_STUDENT_NUMBER
       FOREIGN KEY (STUDENT_NUMBER) REFERENCES t_STUDENTS(STUDENT_NUMBER)
     ;

     ALTER TABLE dbo.t_ENROLLMENT
       ADD CONSTRAINT fk_COURSE_ID
       FOREIGN KEY (COURSE_ID) REFERENCES t_COURSES(COURSE_ID)
     ;

     ALTER TABLE dbo.t_ENROLLMENT
       ADD CONSTRAINT df_AMOUNT_PAID
       DEFAULT '0.00' FOR [AMOUNT_PAID]
     ; 

END


--********************************************************************--
--[ Adding Data ]--
--********************************************************************--

-- t_Academic_Sessions (Table 1 of 4)
GO
BEGIN TRY
     BEGIN TRANSACTION
       INSERT INTO t_ACADEMIC_SESSIONS
                  (SEASON_NAME
				 , ACADEMIC_YEAR
				 , ACADEMIC_QUARTER
				 , QUARTER_START_DATE
				 , QUARTER_END_DATE)
           VALUES
		          ('WINTER', '2017', 'WINTER 2017', '2017-01-01', '2017-03-31')
				, ('SPRING', '2017', 'SPRING 2017', '2017-04-01', '2017-06-30')
                , ('SUMMER', '2017', 'SUMMER 2017', '2017-07-01', '2017-09-30')
                , ('FALL',   '2017', 'FALL 2017',   '2017-10-01', '2017-12-31')
	 COMMIT TRANSACTION
	 ;
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION
	 ;
	 PRINT N'ERROR - Academic_Sessions not entered. Please check data being entered!'
	 ;
	 PRINT Error_Number()-- original RDMS
	 ;
	 PRINT Error_Message() -- original RDMS
	 ;
END CATCH


-- t_COURSES (Table 2 of 4)
GO
BEGIN TRY
     BEGIN TRANSACTION
       INSERT INTO dbo.t_COURSES
                  (COURSE_NAME
				 , ACADEMIC_QUARTER
				 , COURSE_START_DATE
				 , COURSE_END_DATE
				 , COURSE_START_TIME
				 , COURSE_END_TIME
				 , COURSE_DAYS
				 , COURSE_PRICE)
           VALUES
		          ('SQL1', 'WINTER 2017', '2017-01-10', '2017-01-24', '18:00', '20:50', 'T', '399')
				, ('SQL2', 'WINTER 2017', '2017-01-31', '2017-02-14', '18:00', '20:50', 'T', '399')
 	 COMMIT TRANSACTION
	 ;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
	 ;
	 PRINT N'ERROR - Courses not entered. Please check data being entered!'
	 ;
	 PRINT Error_Number()-- original RDMS
	 ;
	 PRINT Error_Message() -- original RDMS
	 ;
END CATCH



-- t_Students (Table 3 of 4)
GO
BEGIN TRY
     BEGIN TRANSACTION
       INSERT INTO dbo.t_STUDENTS
                  (STUDENT_NUMBER
				 , FIRST_NAME
				 , LAST_NAME
				 , EMAIL_ADDRESS
				 , PHONE_NUMBER
				 , ADDRESS_LINE_1
--				 , ADDRESS_LINE_2
				 , CITY
				 , sTATE_CODE
				 , ZIP_CODE
				 , TUITION_DISCOUNT
				 )
           VALUES
		          ('B-Smith-071', 'Bob', 'Smith', 'BSmith@HipMail.com', '2061112222', '123 Main St.', 'Seattle', 'WA', '98001', '0')
				, ('S-Jones-003', 'Sue', 'Jones', 'SueJones@YaYou.com', '2062314321', '333 1st Ave.', 'Seattle', 'WA', '98001', '-50')
 	 COMMIT TRANSACTION
	 ;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
	 ;
	 PRINT N'ERROR - Students not entered. Please check data being entered!'
	 ;
	 PRINT Error_Number()-- original RDMS
	 ;
	 PRINT Error_Message() -- original RDMS
	 ;
END CATCH


-- ENROLLMENT (Table 4 of 4)
GO
BEGIN TRY
     BEGIN TRANSACTION
       INSERT INTO dbo.t_ENROLLMENT
                  (STUDENT_NUMBER
				 , COURSE_ID
				 , ENROLLMENT_DATE
				 , COURSE_PRICE
				 , AMOUNT_PAID
			       )
           VALUES
		          ('B-Smith-071', '1', '2017-01-03', '399', '399')
				, ('S-Jones-003', '1', '2016-12-14', '349', '349')
		        , ('B-Smith-071', '2', '2017-01-12', '399', '0')
				, ('S-Jones-003', '2', '2016-12-14', '349', '399')
 	 COMMIT TRANSACTION
	 ;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
	 ;
	 PRINT N'ERROR - Enrollment not entered. Please check data being entered!'
	 ;
	 PRINT Error_Number()-- original RDMS
	 ;
	 PRINT Error_Message() -- original RDMS
	 ;
END CATCH


--********************************************************************--
--[ Show Data Tables ]--
--********************************************************************--
--SELECT * FROM ASSIGNMENT07DB_MMiller.dbo.t_ACADEMIC_SESSIONS;
--SELECT * FROM ASSIGNMENT07DB_MMiller.dbo.t_COURSES;
--SELECT * FROM ASSIGNMENT07DB_MMiller.dbo.t_STUDENTS;
--SELECT * FROM ASSIGNMENT07DB_MMiller.dbo.t_ENROLLMENT;


--********************************************************************--
--[ CREATE VIEWS ]--
--********************************************************************--
GO
CREATE VIEW dbo.v_ACADEMIC_SESSIONS WITH SCHEMABINDING
       AS
       SELECT TOP 10000
--            a.ACADEMIC_YEAR
	          a.ACADEMIC_QUARTER
	        , a.QUARTER_START_DATE
	        , a.QUARTER_END_DATE
	   FROM dbo.t_ACADEMIC_SESSIONS a
	   GROUP BY
	          a.ACADEMIC_QUARTER
			, a.ACADEMIC_YEAR
	        , a.QUARTER_START_DATE
	        , a.QUARTER_END_DATE
	   ORDER BY
	         a.QUARTER_START_DATE ASC
;

GO
CREATE VIEW dbo.v_COURSES WITH SCHEMABINDING
       AS
       SELECT TOP 10000
              c.COURSE_NAME
			, c.ACADEMIC_QUARTER
			, c.COURSE_START_DATE
			, c.COURSE_END_DATE
			, c.COURSE_DAYS
			, c.COURSE_START_TIME
			, c.COURSE_END_TIME
			, c.COURSE_PRICE
	     FROM dbo.t_COURSES c
	    GROUP BY
              c.COURSE_NAME
			, c.ACADEMIC_QUARTER
			, c.COURSE_START_DATE
			, c.COURSE_END_DATE
			, c.COURSE_DAYS
			, c.COURSE_START_TIME
			, c.COURSE_END_TIME
			, c.COURSE_PRICE
	    ORDER BY
		      c.COURSE_START_DATE ASC
		    , c.COURSE_NAME
; 

GO
CREATE VIEW dbo.v_STUDENTS WITH SCHEMABINDING
       AS
       SELECT TOP 100000
              s.STUDENT_NUMBER
			, s.FIRST_NAME
			, s.LAST_NAME
			, s.EMAIL_ADDRESS
			, s.PHONE_NUMBER
			, s.ADDRESS_LINE_1
			, s.ADDRESS_LINE_2
			, s.CITY
			, s.STATE_CODE
			, s.ZIP_CODE
	     FROM dbo.t_STUDENTS s
	    GROUP BY
              s.STUDENT_NUMBER
			, s.FIRST_NAME
			, s.LAST_NAME
			, s.EMAIL_ADDRESS
			, s.PHONE_NUMBER
			, s.ADDRESS_LINE_1
			, s.ADDRESS_LINE_2
			, s.CITY
			, s.STATE_CODE
			, s.ZIP_CODE
	    ORDER BY
		      s.LAST_NAME
			, s.FIRST_NAME
; 

GO
CREATE VIEW dbo.v_ENROLLMENT WITH SCHEMABINDING
       AS
       SELECT TOP 10000
	          e.ENROLLMENT_ID
            , s.LAST_NAME
			, s.FIRST_NAME
			, e.STUDENT_NUMBER
			, c.COURSE_NAME
			, c.ACADEMIC_QUARTER
			, e.ENROLLMENT_DATE
			, c.COURSE_PRICE
			, SUM(c.COURSE_PRICE + s.TUITION_DISCOUNT) AS AMOUNT_PAID
	     FROM dbo.t_ENROLLMENT e
    LEFT JOIN dbo.t_COURSES c
	       ON c.COURSE_ID = e.COURSE_ID
	LEFT JOIN dbo.t_STUDENTS s
	       ON s.STUDENT_NUMBER = e.STUDENT_NUMBER
	 GROUP BY
	          e.ENROLLMENT_ID
            , s.LAST_NAME
			, s.FIRST_NAME
			, e.STUDENT_NUMBER
			, c.COURSE_NAME
			, c.ACADEMIC_QUARTER
			, e.ENROLLMENT_DATE
			, c.COURSE_PRICE
	 ORDER BY
	          e.ENROLLMENT_DATE
	        , s.LAST_NAME
			, s.FIRST_NAME
; 

			     /*--[ Show Views Created ]--
			     SELECT * FROM dbo.v_ACADEMIC_SESSIONS;
			     SELECT * FROM dbo.v_COURSES;
			     SELECT * FROM dbo.v_STUDENTS;
			     SELECT * FROM dbo.v_ENROLLMENT;
				 */


--********************************************************************--
--[ CREATE A STORED PROCEDURE]--
--********************************************************************--

GO
USE ITFND130FINALDB_MMiller
;

GO
CREATE PROCEDURE dbo.p_Balance_Due_Contact_List
                
/* Author:       MMiller
** Description:  Procedure to get list of students with a balance due
** Change Log:   2023 03 10, MMiller, created procedure
*/
  AS
        SELECT TOP 10000
		     e.STUDENT_NUMBER
	       , e.FIRST_NAME
		   , e.LAST_NAME
		   , s.EMAIL_ADDRESS
		   , s.PHONE_NUMBER
		   , e.COURSE_PRICE
		   , e.AMOUNT_PAID
        FROM dbo.v_ENROLLMENT e
	    JOIN dbo.v_STUDENTS s ON e.STUDENT_NUMBER = s.STUDENT_NUMBER
	   WHERE e.AMOUNT_PAID <> 0;
	RETURN;
 GO
EXECUTE p_Balance_Due_Contact_List;

GO
CREATE PROCEDURE dbo.p_COURSE_LIST 
/* Author:       MMiller
** Description:  Procedure to get list of courses
** Change Log:   2023 03 10, MMiller, created procedure
*/
  AS
        SELECT c.COURSE_NAME 
             , c.ACADEMIC_QUARTER
        FROM dbo.v_COURSES c
	    JOIN dbo.v_ACADEMIC_SESSIONS a ON c.ACADEMIC_QUARTER = a.ACADEMIC_QUARTER
	RETURN;
  GO
EXECUTE p_COURSE_LIST;

GO

CREATE PROCEDURE dbo.p_Enrollment_List               
/* Author:       MMiller
** Description:  Procedure to get list of enrolled students
** Change Log:   2023 03 10, MMiller, created procedure
*/
  AS
        SELECT TOP 10000
		       c.COURSE_NAME
			 , c.ACADEMIC_QUARTER
		     , c.COURSE_START_DATE AS [START_DATE]
			 , c.COURSE_END_DATE AS [END_DATE]
		     , c.COURSE_DAYS AS [DAYS]
			 , c.COURSE_START_TIME AS [START]
			 , c.COURSE_END_TIME AS [END]
			 , c.COURSE_PRICE AS [PRICE]
			 , s.FIRST_NAME 
			 , s.LAST_NAME
			 , e.STUDENT_NUMBER AS [NUMBER]
			 , s.EMAIL_ADDRESS AS [EMAIL]
			 , s.PHONE_NUMBER AS [PHONE]
			 , s.ADDRESS_LINE_1 AS [ADDRESS]
			 , s.CITY AS [CITY]
			 , s.STATE_CODE AS [STATE]
			 , s.ZIP_CODE AS [ADDRESS]
			 , e.ENROLLMENT_DATE AS [SIGNUP_DATE]
			 , e.COURSE_PRICE AS [AMOUNT_PAID]
        FROM dbo.v_ENROLLMENT e
		JOIN dbo.v_COURSES c ON c.COURSE_NAME = e.COURSE_NAME
		JOIN dbo.v_STUDENTS s ON s.STUDENT_NUMBER = e.STUDENT_NUMBER
      GROUP BY c.COURSE_NAME
			 , c.ACADEMIC_QUARTER
		     , c.COURSE_START_DATE
			 , c.COURSE_END_DATE 
		     , c.COURSE_DAYS
			 , c.COURSE_START_TIME
			 , c.COURSE_END_TIME
			 , c.COURSE_PRICE
			 , s.FIRST_NAME 
			 , s.LAST_NAME
			 , e.STUDENT_NUMBER
			 , s.EMAIL_ADDRESS
			 , s.PHONE_NUMBER
			 , s.ADDRESS_LINE_1
			 , s.CITY
			 , s.STATE_CODE 
			 , s.ZIP_CODE 
			 , e.ENROLLMENT_DATE
			 , e.COURSE_PRICE
		ORDER BY c.COURSE_START_DATE
		       , c.COURSE_NAME
	RETURN;
  GO
EXECUTE p_Enrollment_List;




--********************************************************************--
--[ Roles and Security ]--
--********************************************************************--
--PERMISSIONS DENY
GO
   DENY SELECT ON ITFnd130FinalDB_MMiller.dbo.t_ACADEMIC_SESSIONS to
               PUBLIC;
   DENY SELECT ON ITFnd130FinalDB_MMiller.dbo.t_COURSES to 
               PUBLIC;
   DENY SELECT ON ITFnd130FinalDB_MMiller.dbo.t_STUDENTS to
               PUBLIC;
   DENY SELECT ON ITFnd130FinalDB_MMiller.dbo.t_ENROLLMENT to 
               PUBLIC;
GO
--PERMISSIONS GRANT
   GRANT SELECT ON ITFnd130FinalDB_MMiller.dbo.v_ACADEMIC_SESSIONS to
               PUBLIC;
   GRANT SELECT ON ITFnd130FinalDB_MMiller.dbo.v_COURSES to 
               PUBLIC;
   GRANT SELECT ON ITFnd130FinalDB_MMiller.dbo.v_STUDENTS to
               PUBLIC;
   GRANT SELECT ON ITFnd130FinalDB_MMiller.dbo.v_ENROLLMENT to 
               PUBLIC;

   GRANT EXECUTE ON dbo.p_Balance_Due_Contact_List to 
               PUBLIC;

/*********************************************/
/**********       DISPLAY DATA        ********/
/*********************************************/


