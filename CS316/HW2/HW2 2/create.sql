-- Modify the CREATE TABLE statements as needed to add constraints.
-- Do not otherwise change the column names or types.

CREATE TABLE People
(id INTEGER NOT NULL PRIMARY KEY,
 name VARCHAR(256) NOT NULL,
 pet VARCHAR(256),
 wand_core VARCHAR(256)
);

CREATE TABLE Teacher
(id INTEGER NOT NULL PRIMARY KEY,
 FOREIGN KEY (id) REFERENCES People(id)
);

CREATE TABLE House
(name VARCHAR(32) NOT NULL PRIMARY KEY,
 teacher_id INTEGER NOT NULL,
 FOREIGN KEY (teacher_id) REFERENCES Teacher(id)
);

CREATE TABLE Student
(id INTEGER NOT NULL PRIMARY KEY,
 year INTEGER NOT NULL,
 house_name VARCHAR(32) NOT NULL,
 FOREIGN KEY (id) REFERENCES People(id),
 FOREIGN KEY (house_name) REFERENCES House(name)
);

CREATE TABLE Deed
(id SERIAL PRIMARY KEY,
 student_id INTEGER NOT NULL,
 datetime TIMESTAMP NOT NULL,
 points INTEGER NOT NULL,
 description VARCHAR(512) NOT NULL,
 FOREIGN KEY (student_id) REFERENCES Student(id),
 CONSTRAINT late CHECK ((description NOT LIKE 'Arriving late,%') OR points<=(-10))
);

CREATE TABLE Subject
(name VARCHAR(256) NOT NULL PRIMARY KEY
);

CREATE TABLE Offering
(subject_name VARCHAR(256) NOT NULL,
 year INTEGER NOT NULL,
 teacher_id INTEGER NOT NULL,
 PRIMARY KEY (subject_name, year),
 FOREIGN KEY (subject_name) REFERENCES Subject(name), 
 FOREIGN KEY (teacher_id) REFERENCES Teacher(id),
 CONSTRAINT teacher_dup UNIQUE(year, teacher_id)
);

CREATE TABLE Grade
(student_id INTEGER NOT NULL,
 subject_name VARCHAR(256) NOT NULL,
 year INTEGER NOT NULL,
 grade CHAR(1),
 PRIMARY KEY (student_id, subject_name, year),
 FOREIGN KEY (subject_name, year) REFERENCES Offering(subject_name, year),
 FOREIGN KEY (student_id) REFERENCES Student(id),
 CONSTRAINT grade_options CHECK (grade in ('O', 'E', 'A', 'P', 'D', 'T') or grade = 'NULL')
);

CREATE TABLE FavoriteSubject
(student_id INTEGER NOT NULL,
 subject_name VARCHAR(256) NOT NULL,
 PRIMARY KEY (student_id, subject_name),
 FOREIGN KEY (student_id) REFERENCES Student(id),
 FOREIGN KEY (subject_name) REFERENCES Subject(name)
);

-- Using a trigger, enforce that if a student ever receives a D or
-- T for a subject, the student cannot take the same subject
-- again. (Otherwise students may repeat a subject.)
CREATE FUNCTION TF_DTGrades() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(SELECT * FROM Grade
        WHERE subject_name = NEW.subject_name AND student_id = NEW.student_id AND grade in('D', 'T')) THEN
              RAISE EXCEPTION 'student cannot take % again', NEW.subject_name;
           END IF;
    IF EXISTS(SELECT * FROM Grade
        WHERE subject_name = NEW.subject_name AND student_id = NEW.student_id AND grade in('D', 'T') AND year < NEW.year) THEN
            RAISE EXCEPTION 'student has failed course previously';
        END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_DTGrades
  BEFORE INSERT OR UPDATE ON Grade
  FOR EACH ROW
  EXECUTE PROCEDURE TF_DTGrades();

-- Using triggers, enforce that a person cannot be both student
-- and teacher at the same time.
CREATE FUNCTION blah() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(SELECT * FROM Teacher
        WHERE (id = NEW.id)) THEN
            RAISE EXCEPTION '% is already a student', NEW.id;
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER blah
  BEFORE INSERT OR UPDATE ON Student
  FOR EACH ROW
  EXECUTE PROCEDURE blah();
              
              
              
              
CREATE FUNCTION blah2() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(SELECT * FROM Student
        WHERE (id = NEW.id)) THEN
            RAISE EXCEPTION '% is already a teacher', NEW.id;
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER blah2
  BEFORE INSERT OR UPDATE ON Teacher
  FOR EACH ROW
  EXECUTE PROCEDURE blah2();

-- YOUR IMPLEMENTATION GOES HERE


-- Define a view that lists, for each House, the total number of
-- points accumulated by the House during the school year 1991-1992
-- (which started on September 1, 1991 and ended on June 30,
-- 1992). Note that your view should list all Houses, even if a House
-- didn’t have any points earned or deducted during this period (in
-- which case the total should be 0) or there were more points
-- deducted than earned (in which case the total should be negative).
CREATE VIEW HousePoints(house, points) AS
SELECT name, COALESCE(sum, 0) FROM (SELECT name, sum FROM House LEFT OUTER JOIN
(SELECT house_name, SUM(points) FROM Deed, Student WHERE Deed.student_id = Student.id AND datetime >= '1991-09-01 00:00:00' AND datetime < '1992-07-01 00:00:00' GROUP BY house_name) AS thing1 ON House.name = thing1.house_name) AS thing2;