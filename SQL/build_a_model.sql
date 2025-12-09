
/*
1. start with the table that has most records --> use as driving
2. look which table refrences which pk of other table as it fk, use them to make joins 
*/

Q. julia just finished conducting a coding contest and she needs your help assembling the leaderboard! 
-- Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge.
-- Order your output in descending order by the total number of challenges in which the hacker earned a full score. 
-- If more than one hacker received full scores in the same number of challenges,then sort them by ascending hacker_id.
 
 

-- Hackers table
CREATE TABLE Hackers (
    hacker_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
 
-- Difficulty table
CREATE TABLE Difficulty (
    difficulty_level INT PRIMARY KEY,
    score INT NOT NULL
);
 
-- Challenges table
CREATE TABLE Challenges (
    challenge_id INT PRIMARY KEY,
    hacker_id INT REFERENCES Hackers(hacker_id),
    difficulty_level INT REFERENCES Difficulty(difficulty_level)
);
 
-- Submissions table
CREATE TABLE Submissions (
    submission_id INT PRIMARY KEY,
    hacker_id INT REFERENCES Hackers(hacker_id),
    challenge_id INT REFERENCES Challenges(challenge_id),
    score INT NOT NULL
);
 
 
-- Hackers
INSERT INTO Hackers (hacker_id, name) VALUES
(558, 'Rose'),
(843, 'Angela'),
(921, 'Frank'),
(132, 'Patrick');
 
-- Difficulty
INSERT INTO Difficulty (difficulty_level, score) VALUES
(1, 20),
(2, 30),
(3, 40),
(4, 60);
 
-- Challenges
INSERT INTO Challenges (challenge_id, hacker_id, difficulty_level) VALUES
(1, 558, 1),
(2, 843, 2),
(3, 921, 3),
(4, 132, 4),
(5, 558, 2),
(6, 843, 3);
 
-- Submissions
INSERT INTO Submissions (submission_id, hacker_id, challenge_id, score) VALUES
(1, 558, 1, 20),
(2, 843, 2, 30),
(3, 921, 3, 40),
(4, 132, 4, 60),
(5, 558, 5, 30),
(6, 843, 6, 40),
(7, 558, 1, 10),
(8, 843, 2, 25);


-- submission >> received a score corressponing to challenge_id >> 
-- join challenge_id and challenges table to get difficulty  >>
-- get difficulty >> corrsponding to difficulty is max score in difficulty tb



with cte as (
select 
h.hacker_id,
h.name,
c.challenge_id,
s.score,
d.difficulty_level,
d.score  as max_score

from hackers h
join Challenges c 
on c.hacker_id = h.hacker_id
join Submissions s
on c.hacker_id = s.hacker_id
and c.challenge_id = s.challenge_id 
join Difficulty d 
on d.difficulty_level = c.difficulty_level
)
select hacker_id, name , count(1) from cte 
where score = max_score
group by hacker_id, name
having count(1)>1
order by hacker_id ;












