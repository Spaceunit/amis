/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     07.11.2017 20:49:44                          */
/*==============================================================*/


alter table Schedule
   drop constraint FK_SCHEDULE_HAS_POOL;

alter table Schedule
   drop constraint FK_SCHEDULE_HAS_TEAM;

alter table Tariff_plan
   drop constraint FK_TARIFF_PLAN_HAS_TARIFF;

alter table Tariff_plan
   drop constraint FK_TARIFF_PLAN_HAS_USER;

alter table Team
   drop constraint FK_TEAM_COACH_USER;

alter table Team
   drop constraint FK_TEAM_MEMBER_USER;

alter table "User"
   drop constraint FK_USER_HAS_ROLE;

drop table Pool cascade constraints;

drop table Role cascade constraints;

drop index "has a schedule_FK";

drop index "has a schedule2_FK";

drop table Schedule cascade constraints;

drop table Tariff cascade constraints;

drop index "has a tariff plan_FK";

drop index "has a tariff plan2_FK";

drop table Tariff_plan cascade constraints;

drop index coach_FK;

drop index member_FK;

drop table Team cascade constraints;

drop index "has a role_FK";

drop table "User" cascade constraints;

/*==============================================================*/
/* Table: Pool                                                  */
/*==============================================================*/
create table Pool 
(
   line_id              INTEGER              not null,
   line_number          INTEGER              not null,
   line_length          FLOAT(8)             not null,
   pool_name            VARCHAR2(256)        not null,
   deleted				NUMBER(1) DEFAULT 1,
   constraint PK_POOL primary key (line_id)
);

/*==============================================================*/
/* Table: Role                                                  */
/*==============================================================*/
create table Role 
(
   role_name            VARCHAR2(256)        not null,
   role_description     VARCHAR2(1024)       not null,
   deleted				NUMBER(1) DEFAULT 1,
   constraint PK_ROLE primary key (role_name)
);

/*==============================================================*/
/* Table: Schedule                                              */
/*==============================================================*/
create table Schedule 
(
   line_id_fk           INTEGER              not null,
   member_id_fk         INTEGER              not null,
   coach_id_fk          INTEGER              not null,
   team_name_fk         VARCHAR2(256)        not null,
   day                  DATE                 not null,
   time                 DATE                 not null,
   deleted				NUMBER(1) DEFAULT 1,
   constraint PK_SCHEDULE primary key (line_id_fk, member_id_fk, coach_id_fk, team_name_fk)
);

/*==============================================================*/
/* Index: "has a schedule2_FK"                                  */
/*==============================================================*/
create index "has a schedule2_FK" on Schedule (
   member_id_fk ASC,
   coach_id_fk ASC,
   team_name_fk ASC
);

/*==============================================================*/
/* Index: "has a schedule_FK"                                   */
/*==============================================================*/
create index "has a schedule_FK" on Schedule (
   line_id_fk ASC
);

/*==============================================================*/
/* Table: Tariff                                                */
/*==============================================================*/
create table Tariff 
(
   tariff_name          VARCHAR2(256)        not null,
   tariff_price         FLOAT(8)             not null,
   tariff_subscription_time VARCHAR2(5)      not null,
   tariff_description   VARCHAR2(1024)       not null,
   deleted				NUMBER(1) DEFAULT 1,
   constraint PK_TARIFF primary key (tariff_name)
);

/*==============================================================*/
/* Table: Tariff_plan                                           */
/*==============================================================*/
create table Tariff_plan 
(
   tariff_name_fk       VARCHAR2(256)        not null,
   user_id_fk           INTEGER              not null,
   pay_date             DATE                 not null,
   deleted				NUMBER(1) DEFAULT 1,
   constraint PK_TARIFF_PLAN primary key (tariff_name_fk, user_id_fk)
);

/*==============================================================*/
/* Index: "has a tariff plan2_FK"                               */
/*==============================================================*/
create index "has a tariff plan2_FK" on Tariff_plan (
   user_id_fk ASC
);

/*==============================================================*/
/* Index: "has a tariff plan_FK"                                */
/*==============================================================*/
create index "has a tariff plan_FK" on Tariff_plan (
   tariff_name_fk ASC
);

/*==============================================================*/
/* Table: Team                                                  */
/*==============================================================*/
create table Team 
(
   coach_id_fk          INTEGER              not null,
   member_id_fk         INTEGER              not null,
   team_name            VARCHAR2(256)        not null,
   deleted				NUMBER(1) DEFAULT 1,
   constraint PK_TEAM primary key (member_id_fk, coach_id_fk, team_name)
);

/*==============================================================*/
/* Index: member_FK                                             */
/*==============================================================*/
create index member_FK on Team (
   coach_id_fk ASC
);

/*==============================================================*/
/* Index: coach_FK                                              */
/*==============================================================*/
create index coach_FK on Team (
   member_id_fk ASC
);

/*==============================================================*/
/* Table: "User"                                                */
/*==============================================================*/
create table "User" 
(
   user_id              INTEGER              not null,
   email                VARCHAR2(254)        not null,
   role_name_fk         VARCHAR2(256)        not null,
   first_name           VARCHAR2(256)        not null,
   second_name          VARCHAR2(256)        not null,
   last_name            VARCHAR2(256)        not null,
   birthday             DATE                 not null,
   reg_day				DATE				 not null,		
   user_address         VARCHAR2(256)        not null,
   phone_number         VARCHAR2(15)         not null,
   med_doc              VARCHAR2(2048)       not null,
   sport_rank           VARCHAR2(256),
   password             VARCHAR2(256)        not null,
   deleted				NUMBER(1) DEFAULT 1  not null,
   constraint PK_USER primary key (user_id)
);

/*==============================================================*/
/* Index: "has a role_FK"                                       */
/*==============================================================*/
create index "has a role_FK" on "User" (
   role_name_fk ASC
);

/*==============================================================*/
/* MANUAL TYPING                                                */
/*==============================================================*/
/*==============================================================*/
/* USER                                                */
/*==============================================================*/
ALTER TABLE "User"
	ADD CONSTRAINT user_email_phn_med_unique UNIQUE (email, phone_number, med_doc);

ALTER TABLE "User"
	ADD CONSTRAINT check_user_id_regexp
	CHECK ( REGEXP_LIKE (user_id, '^[0-9]{1,10}($|\s)'));

ALTER TABLE "User"
	ADD CONSTRAINT user_check_email_regexp
	CHECK( REGEXP_LIKE (email, '^[A-Za-z!#$%&*+-=?^_`{|}~\.0-9]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,15}($|\s)'));

ALTER TABLE "User"
	ADD CONSTRAINT user_check_email_length
	CHECK(length(email) < 255);
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_f_name_regexp
	CHECK ( REGEXP_LIKE (first_name, '^[A-ZА-ЯІЇЄ][a-zа-яіїє-]+($|\s)', 'c'));
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_f_name_len
	CHECK (length(first_name) <= 256);

ALTER TABLE "User"
	ADD CONSTRAINT user_check_s_name_regexp
	CHECK ( REGEXP_LIKE (second_name, '^[A-ZА-ЯІЇЄ][a-zа-яіїє-]+($|\s)', 'c'));
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_s_name_len
	CHECK (length(second_name) <= 256);
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_l_name_regexp
	CHECK ( REGEXP_LIKE (last_name, '^[A-ZА-ЯІЇЄ][a-zа-яіїє-]+($|\s)', 'c'));
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_l_name_len
	CHECK (length(last_name) <= 256);
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_birthday
	CHECK (reg_day > birthday);
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_address_regexp
	CHECK ( REGEXP_LIKE (user_address, '^[A-ZА-ЯІЄЇа-яіїє,''a-z .0-9-]+($|\s)', 'c'));
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_address_len
	CHECK (length(user_address) <= 1024);

ALTER TABLE "User"
	ADD CONSTRAINT user_check_phone_number_regexp
	CHECK ( REGEXP_LIKE (phone_number, '^[0-9]{2,15}($|\s)'));

ALTER TABLE "User"
	ADD CONSTRAINT user_check_phone_number_len
	CHECK (length(phone_number) <= 15 and length(phone_number) > 2);
  
ALTER TABLE "User"
	ADD CONSTRAINT user_check_meddoc_regexp
	CHECK ( REGEXP_LIKE (med_doc, '^[_.0-9A-Za-z@()А-ЯІЄЇа-яіїє-]{3,15}+\/[_.0-9a-zA-Z@()А-ЯІЄЇа-яіїє-]{3,15}\/+[_.0-9a-zA-Z@А-ЯІЄЇа-яіїє()-]{3,15}($|\s)'));

ALTER TABLE "User"
	ADD CONSTRAINT user_check_meddoc_len
	CHECK (length(med_doc) <= 2048);
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_sport_rank_regexp
	CHECK ( REGEXP_LIKE (sport_rank, '^[A-ZА-ЯІЇЄ][a-zа-яіїє-]+($|\s)', 'c'));
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_sport_rank_len
	CHECK (length(sport_rank) <= 256);
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_password_regexp
	CHECK ( REGEXP_LIKE (password, '^[A-Za-z!#$%&*+-=?^_`{|}~\.0-9@]+($|\s)'));
	
ALTER TABLE "User"
	ADD CONSTRAINT user_check_password_len
	CHECK (length(password) >= 8 and length(password) <= 256);
	
/*==============================================================*/
/* ROLE                                                */
/*==============================================================*/
ALTER TABLE Role
	ADD CONSTRAINT check_role_name_regexp
	CHECK ( REGEXP_LIKE (role_name, '^[A-Za-z]+($|\s)'));
  
ALTER TABLE Role
	ADD CONSTRAINT role_description_unique UNIQUE (role_description);
	
ALTER TABLE Role
	ADD CONSTRAINT check_role_descp_regexp
	CHECK ( REGEXP_LIKE (role_description, '^[A-Za-zА-ЯІЇЄа-яієї,.-0-9 "?!]+($|\s)'));
	
ALTER TABLE Role
	ADD CONSTRAINT check_role_descp_len
	CHECK (length(role_description) > 10 and length(role_description) <= 1024);
	
/*==============================================================*/
/* TARIFF                                                */
/*==============================================================*/

ALTER TABLE Tariff
	ADD CONSTRAINT tariff_prc_sub_unique UNIQUE (tariff_price, tariff_subscription_time, tariff_description);
	
ALTER TABLE Tariff
	ADD CONSTRAINT tariff_check_name_regexp
	CHECK ( REGEXP_LIKE (tariff_name, '^[A-ZА-ЯІЇЄ][a-zа-яіїє-]+($|\s)', 'c'));
	
ALTER TABLE Tariff
	ADD CONSTRAINT tariff_check_name_len
	CHECK (length(tariff_name) <= 256);
	
ALTER TABLE Tariff
	ADD CONSTRAINT tariff_check_price_regexp
	CHECK ( REGEXP_LIKE (tariff_price, '^[0-9]{1,4}.[0-9]{0,2}($|\s)'));
	
ALTER TABLE Tariff
	ADD CONSTRAINT tariff_check_descp_regexp
	CHECK ( REGEXP_LIKE (tariff_description, '^[A-Za-zА-ЯІЇЄа-яієї,.-0-9 "?!]+($|\s)'));
	
ALTER TABLE Tariff
	ADD CONSTRAINT tariff_check_descp_len
	CHECK (length(tariff_description) > 10 and length(tariff_description) <= 1024);
/*==============================================================*/
/* POOL                                                */
/*==============================================================*/
ALTER TABLE Pool
	ADD CONSTRAINT pool_name_num_len_unique UNIQUE (line_number, line_length, pool_name);

ALTER TABLE Pool
	ADD CONSTRAINT pool_check_line_id_regexp
	CHECK ( REGEXP_LIKE (line_id, '^[0-9]{1,10}($|\s)'));

ALTER TABLE Pool
	ADD CONSTRAINT pool_check_line_number_regexp
	CHECK ( REGEXP_LIKE (line_number, '^[0-9]{1,10}($|\s)'));
	
ALTER TABLE Pool
	ADD CONSTRAINT pool_check_line_length_regexp
	CHECK ( REGEXP_LIKE (line_length, '^[0-9]{1,4}.[0-9]{0,2}($|\s)'));
	
ALTER TABLE Pool
	ADD CONSTRAINT pool_check_name_regexp
	CHECK ( REGEXP_LIKE (pool_name, '^[A-ZА-ЯІЇЄ][a-zа-яіїє-]+($|\s)', 'c'));
	
/*==============================================================*/
/* TEAM                                               */
/*==============================================================*/

ALTER TABLE Team
	ADD CONSTRAINT team_check_name_regexp
	CHECK ( REGEXP_LIKE (team_name, '^[A-ZА-ЯІЇЄ][a-zа-яіїє -]+($|\s)', 'c'));


alter table Schedule
   add constraint FK_SCHEDULE_HAS_POOL foreign key (line_id_fk)
      references Pool (line_id);

alter table Schedule
   add constraint FK_SCHEDULE_HAS_TEAM foreign key (member_id_fk, coach_id_fk, team_name_fk)
      references Team (member_id_fk, coach_id_fk, team_name);

alter table Tariff_plan
   add constraint FK_TARIFF_PLAN_HAS_TARIFF foreign key (tariff_name_fk)
      references Tariff (tariff_name);

alter table Tariff_plan
   add constraint FK_TARIFF_PLAN_HAS_USER foreign key (user_id_fk)
      references "User" (user_id);

alter table Team
   add constraint FK_TEAM_COACH_USER foreign key (member_id_fk)
      references "User" (user_id);

alter table Team
   add constraint FK_TEAM_MEMBER_USER foreign key (coach_id_fk)
      references "User" (user_id);

alter table "User"
   add constraint FK_USER_HAS_ROLE foreign key (role_name_fk)
      references Role (role_name);
COMMIT;

/*==============================================================*/
/* LOGIC                                               */
/*==============================================================*/

/*==============================================================*/
/* VIEWS                                               */
/*==============================================================*/

CREATE OR REPLACE VIEW "Admin" AS
SELECT "User".email email, "User".role_name_fk role_name_fk, 
"User".first_name first_name, "User".second_name second_name, 
"User".last_name last_name, "User".birthday birthday, 
"User".user_address address, "User".phone_number phone_number, 
"User".med_doc med_doc, "User".sport_rank sport_rank
FROM "User" WHERE ROLE_NAME_FK = 'Admin' AND DELETED = 1;
COMMIT;

CREATE OR REPLACE VIEW "Coach" AS
SELECT "User".email email, "User".role_name_fk role_name_fk, 
"User".first_name first_name, "User".second_name second_name, 
"User".last_name last_name, "User".birthday birthday, 
"User".user_address address, "User".phone_number phone_number, 
"User".med_doc med_doc, "User".sport_rank sport_rank
FROM "User" WHERE ROLE_NAME_FK = 'Coach' AND DELETED = 1;
COMMIT;

CREATE OR REPLACE VIEW "CoachForClient" AS
SELECT "User".email email, "User".role_name_fk role_name_fk, 
"User".first_name first_name, "User".second_name second_name, 
"User".last_name last_name, "User".sport_rank sport_rank
FROM "User" WHERE ROLE_NAME_FK = 'Coach' AND DELETED = 1;
COMMIT;

CREATE OR REPLACE VIEW "ClientForCoach" AS
SELECT "User".email email, "User".role_name_fk role_name_fk, 
"User".first_name first_name, "User".second_name second_name, 
"User".last_name last_name, "User".phone_number phone_number,
"User".sport_rank sport_rank
FROM "User" WHERE ROLE_NAME_FK = 'Client' AND DELETED = 1;
COMMIT;

CREATE OR REPLACE VIEW "Client" AS
SELECT "User".email email, "User".role_name_fk role_name_fk, 
"User".first_name first_name, "User".second_name second_name, 
"User".last_name last_name, "User".birthday birthday, 
"User".user_address address, "User".phone_number phone_number, 
"User".med_doc med_doc, "User".sport_rank sport_rank
FROM "User" WHERE ROLE_NAME_FK = 'Client' AND DELETED = 1;
COMMIT;

CREATE OR REPLACE VIEW "Guest" AS
SELECT "User".email email, "User".role_name_fk role_name_fk, 
"User".first_name first_name, "User".second_name second_name, 
"User".last_name last_name, "User".birthday birthday, 
"User".user_address address, "User".phone_number phone_number, 
"User".med_doc med_doc, "User".sport_rank sport_rank
FROM "User" WHERE ROLE_NAME_FK = 'Guest' AND DELETED = 1;
COMMIT;

CREATE OR REPLACE VIEW "Team" AS
SELECT TEAM.coach_id_fk coach_id_fk, TEAM.member_id_fk member_id_fk,
TEAM.team_name team_name FROM TEAM;
COMMIT;

/*==============================================================*/
/* PROCEDURES                                               */
/*==============================================================*/

-- CREATE OR REPLACE PROCEDURE registerGuest(user_row in "User"%)
CREATE OR REPLACE PACKAGE WORK_PACK IS
	TYPE EMPS_FILTERED AS OBJECT
	(email "User".email%TYPE
	,role_name   "User".role_name_fk%TYPE
	,first_name "User".first_name%TYPE
	,second_name "User".second_name%TYPE
	,last_name "User".last_name%TYPE
	,user_address "User".user_address%TYPE
	,phone_number "User".phone_number%TYPE
	,med_doc "User".med_doc%TYPE
	,sport_rank "User".sport_rank%TYPE
	,birthday VARCHAR2);
	TYPE is_regUser IS RECORD (
user_id                 INTEGER,
   email                VARCHAR2(254),
   first_name           VARCHAR2(256),
   second_name          VARCHAR2(256),
   last_name            VARCHAR2(256),
   birthday             DATE,
   user_address         VARCHAR2(256),
   phone_number         VARCHAR2(15),
   med_doc              VARCHAR2(2048),
   sport_rank           VARCHAR2(256),
   password             VARCHAR2(256)        
);
	FUNCTION GETUSERLOGINDATA(user_email in "User".email%TYPE) RETURN VARCHAR2;
	FUNCTION GETUSERROLE(user_email in "User".email%TYPE) RETURN VARCHAR2;
	PROCEDURE registerGuest(
	email in "User".email%TYPE
    ,password in "User".password%TYPE
	,first_name in "User".first_name%TYPE
	,second_name in "User".second_name%TYPE
	,last_name in "User".last_name%TYPE
	,user_address in "User".user_address%TYPE
	,phone_number in "User".phone_number%TYPE
	,med_doc in "User".med_doc%TYPE
	,sport_rank in "User".sport_rank%TYPE
	,birthday in VARCHAR2);
    
	PROCEDURE registerUser(register_row in is_regUser,
		role_name in "User".role_name_fk%TYPE);
	PROCEDURE copyFromRecord(register_row in is_regUser,
		USER_ROW out "User"%ROWTYPE);
	PROCEDURE createUser(user_row in "User"%ROWTYPE);
	PROCEDURE joinAdmin (admemail in "Admin".email%TYPE);
	PROCEDURE joinCoach (admemail in "Coach".email%TYPE);
	PROCEDURE joinClient (admemail in "Client".email%TYPE);
	PROCEDURE createTariffPlan(client_email in "Client".email%TYPE
, c_tariff in Tariff.tariff_name%TYPE);
	PROCEDURE createTeam(client_email in "Client".email%TYPE
, c_tariff in Tariff.tariff_name%TYPE);
END WORK_PACK;
/
CREATE OR REPLACE PACKAGE BODY WORK_PACK IS
FUNCTION GETUSERROLE(user_email in "User".email%TYPE) RETURN VARCHAR2
IS
user_role "User".role_name_fk%TYPE;
BEGIN
IF GETUSERLOGINDATA(user_email)<>'0' THEN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT role_name_fk INTO user_role FROM "User" WHERE email=user_email AND DELETED<>0;
SELECT role_name INTO user_role FROM ROLE WHERE role_name=user_role AND DELETED<>0;
COMMIT;
ELSE
user_role:='None';
END IF;
RETURN(user_role);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN('None');
END GETUSERROLE;

FUNCTION GETUSERLOGINDATA(user_email in "User".email%TYPE) RETURN VARCHAR2
IS
user_passwd "User".password%TYPE;
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT PASSWORD INTO user_passwd FROM "User" WHERE EMAIL=user_email AND
DELETED <> 0;
COMMIT;
RETURN(user_passwd);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN('0');
end GETUSERLOGINDATA;
PROCEDURE registerGuest(
	email in "User".email%TYPE
    ,password in "User".password%TYPE
	,first_name in "User".first_name%TYPE
	,second_name in "User".second_name%TYPE
	,last_name in "User".last_name%TYPE
	,user_address in "User".user_address%TYPE
	,phone_number in "User".phone_number%TYPE
	,med_doc in "User".med_doc%TYPE
	,sport_rank in "User".sport_rank%TYPE
	,birthday in VARCHAR2)
IS
role_name "User".role_name_fk%TYPE := 'Guest';
register_row is_regUser;
BEGIN
register_row.email := email;
register_row.first_name := first_name;
register_row.second_name := second_name;
register_row.last_name := last_name;
--register_row.birthday := birthday;
SELECT TO_DATE(birthday, 'YYYY-MM-DD') INTO register_row.birthday FROM DUAL;
register_row.user_address := user_address;
register_row.phone_number := phone_number;
register_row.med_doc := med_doc;
register_row.password := password;
register_row.sport_rank := sport_rank;
registerUser(register_row, role_name);
END registerGuest;

PROCEDURE registerUser(register_row in is_regUser,
		role_name in "User".role_name_fk%TYPE)
IS
USER_ROW "User"%ROWTYPE;
BEGIN
copyFromRecord(register_row, USER_ROW);
USER_ROW.role_name_fk := role_name;
createUser(USER_ROW);
END registerUser;

PROCEDURE copyFromRecord(register_row in is_regUser,
	USER_ROW out "User"%ROWTYPE)
IS
BEGIN
  USER_ROW.email := register_row.email;
  USER_ROW.first_name := register_row.first_name;
  USER_ROW.second_name := register_row.second_name;
  USER_ROW.last_name := register_row.last_name;
  USER_ROW.birthday := register_row.birthday;
  SELECT SYSDATE INTO USER_ROW.REG_DAY FROM DUAL;
  USER_ROW.user_address := register_row.user_address;
  USER_ROW.phone_number := register_row.phone_number;
  USER_ROW.med_doc := register_row.med_doc;
  USER_ROW.sport_rank := register_row.sport_rank;
  USER_ROW.password := register_row.password;
END copyFromRecord;


PROCEDURE createUser(user_row in "User"%ROWTYPE)
IS
c_user_id "User".user_id%TYPE := 0;
curdate   "User".reg_day%TYPE;
newuser "User"%ROWTYPE;
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT SYSDATE INTO curdate FROM DUAL;
newuser := user_row;
newuser.reg_day := curdate;
SELECT USER_ID INTO c_user_id FROM "User" WHERE "User".email = user_row.email; 
UPDATE "User" SET DELETED = 1 WHERE USER_ID = c_user_id;
COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO "User" VALUES user_row;
        COMMIT;
END createUser;

PROCEDURE joinAdmin (admemail in "Admin".email%TYPE)
IS
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE "User" SET role_name_fk = 'Admin'
WHERE deleted <> 0 AND email = admemail;
COMMIT;
END joinAdmin;

PROCEDURE joinCoach (admemail in "Coach".email%TYPE)
IS
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE "User" SET role_name_fk = 'Coach'
WHERE deleted <> 0 AND email = admemail;
COMMIT;
END joinCoach;

PROCEDURE joinClient (admemail in "Client".email%TYPE)
IS
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE "User" SET role_name_fk = 'Client'
WHERE deleted <> 0 AND email = admemail;
COMMIT;
END joinClient;

--INSERT INTO TARIFF_PLAN (TARIFF_NAME_FK, USER_ID_FK, PAY_DATE) VALUES ('Basic', 1837647721, TO_DATE('2017-11-01 08:46:01', 'YYYY-MM-DD HH24:MI:SS'));
PROCEDURE createTariffPlan(client_email in "Client".email%TYPE
, c_tariff in Tariff.tariff_name%TYPE)
IS
client_id "User".user_id%TYPE;
curdate Tariff_plan.PAY_DATE%TYPE; 
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT USER_ID INTO client_id FROM "User" WHERE ROLE_NAME_FK = 'Client' AND
DELETED <> 0 AND EMAIL = client_email;
SELECT SYSDATE INTO curdate FROM DUAL; 
INSERT INTO TARIFF_PLAN (TARIFF_NAME_FK, USER_ID_FK, PAY_DATE) VALUES (
c_tariff, client_id, curdate);
COMMIT;
END createTariffPlan;

--THINK ABOUT IT!!!!!
PROCEDURE createTeam(client_email in "Client".email%TYPE
, c_tariff in Tariff.tariff_name%TYPE)
IS
client_id "User".user_id%TYPE;
curdate Tariff_plan.PAY_DATE%TYPE; 
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT USER_ID INTO client_id FROM "User" WHERE ROLE_NAME_FK = 'Client' AND
DELETED <> 0 AND EMAIL = client_email;
SELECT SYSDATE INTO curdate FROM DUAL; 
INSERT INTO TARIFF_PLAN (TARIFF_NAME_FK, USER_ID_FK, PAY_DATE) VALUES (
c_tariff, client_id, curdate);
COMMIT;
END createTeam;
END WORK_PACK;
/
/*==============================================================*/
/* TRIGGERS DELETE                                               */
/*==============================================================*/

CREATE OR REPLACE TRIGGER deleteAdmin INSTEAD
OF DELETE ON "Admin"
DECLARE
BEGIN
	UPDATE "User" SET deleted = 0 WHERE "User".email = :old.email;
END deleteAdmin;
/
CREATE OR REPLACE TRIGGER deleteCoach INSTEAD
OF DELETE ON "Coach"
BEGIN
	UPDATE "User" SET deleted = 0 WHERE "User".email = :old.email;
END deleteCoach;
/
CREATE OR REPLACE TRIGGER deleteClient INSTEAD
OF DELETE ON "Client"
BEGIN
	UPDATE "User" SET deleted = 0 WHERE "User".email = :old.email;
END deleteClient;
/
CREATE OR REPLACE TRIGGER deleteGuest INSTEAD
OF DELETE ON "Guest"
BEGIN
	UPDATE "User" SET deleted = 0 WHERE "User".email = :old.email;
END deleteGuest;
/
/*==============================================================*/
/* TRIGGERS INSERT                                              */
/*==============================================================*/

CREATE OR REPLACE TRIGGER insertAdmin INSTEAD
OF INSERT ON "Admin"
BEGIN
	NULL;
END insertAdmin;
/
CREATE OR REPLACE TRIGGER insertCoach INSTEAD
OF INSERT ON "Coach"
BEGIN
	NULL;
END insertCoach;
/
CREATE OR REPLACE TRIGGER insertClient INSTEAD
OF INSERT ON "Client"
BEGIN
	NULL;
END insertClient;
/
CREATE OR REPLACE TRIGGER insertGuest INSTEAD
OF INSERT ON "Guest"
BEGIN
	NULL;
END insertGuest;
/
DROP SEQUENCE user_id_seq;
/
DROP SEQUENCE line_id_seq;
/
CREATE SEQUENCE user_id_seq START WITH 1;
/
CREATE SEQUENCE line_id_seq START WITH 1;
/

CREATE OR REPLACE TRIGGER user_id_counter 
BEFORE INSERT ON "User" 
FOR EACH ROW
BEGIN
  SELECT user_id_seq.NEXTVAL
  INTO   :new.user_id
  FROM   dual;
  :new.deleted := 1;
END;
/
CREATE OR REPLACE TRIGGER line_id_counter 
BEFORE INSERT ON POOL 
FOR EACH ROW
BEGIN
  SELECT line_id_seq.NEXTVAL
  INTO   :new.line_id
  FROM   dual;
END;
/ 