-- Create the database.
create database if not exists csx370_mb_platform;

-- Use the created database.
use csx370_mb_platform;

-- Create the user table.
create table if not exists user (
    userId int auto_increment,
    username varchar(255) not null,
    password varchar(255) not null,
    firstName varchar(255) not null,
    lastName varchar(255) not null,
    primary key (userId),
    unique (username),
    constraint userName_min_length check (char_length(trim(userName)) >= 2),
    constraint firstName_min_length check (char_length(trim(firstName)) >= 2),
    constraint lastName_min_length check (char_length(trim(lastName)) >= 2)
);
CREATE TABLE IF NOT EXISTS post (
    postId INT AUTO_INCREMENT,
    userId INT NOT NULL,
    content VARCHAR(1024) NOT NULL,
    postDate DATETIME NOT NULL,
    PRIMARY KEY (postId),
    FOREIGN KEY (userId) REFERENCES user(userId),
    CONSTRAINT content_min_length CHECK (CHAR_LENGTH(TRIM(content)) >= 1)
);

CREATE TABLE IF NOT EXISTS comment (
    commentId INT AUTO_INCREMENT,
    postId INT NOT NULL,
    userId INT NOT NULL,
    content VARCHAR(1024) NOT NULL,
    commentDate DATETIME NOT NULL,
    PRIMARY KEY (commentId),
    FOREIGN KEY (postId) REFERENCES post(postId),
    FOREIGN KEY (userId) REFERENCES user(userId),
    CONSTRAINT comment_min_length CHECK (CHAR_LENGTH(TRIM(content)) >= 1)
);

CREATE TABLE IF NOT EXISTS heart (
    postId INT NOT NULL,
    userId INT NOT NULL,
    PRIMARY KEY (postId, userId),
    FOREIGN KEY (postId) REFERENCES post(postId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

CREATE TABLE IF NOT EXISTS bookmark (
    postId INT NOT NULL,
    userId INT NOT NULL,
    PRIMARY KEY (postId, userId),
    FOREIGN KEY (postId) REFERENCES post(postId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

CREATE TABLE IF NOT EXISTS follow (
    followerId INT NOT NULL,
    followeeId INT NOT NULL,
    PRIMARY KEY (followerId, followeeId),
    FOREIGN KEY (followerId) REFERENCES user(userId),
    FOREIGN KEY (followeeId) REFERENCES user(userId)
);

CREATE TABLE IF NOT EXISTS poll (
    pollId INT AUTO_INCREMENT,
    userId INT NOT NULL,
    question VARCHAR(1024) NOT NULL,
    pollDate DATETIME NOT NULL,
    PRIMARY KEY (pollId),
    FOREIGN KEY (userId) REFERENCES user(userId)
);

CREATE TABLE IF NOT EXISTS poll_option (
    optionId INT AUTO_INCREMENT,
    pollId INT NOT NULL,
    optionText VARCHAR(255) NOT NULL,
    PRIMARY KEY (optionId),
    FOREIGN KEY (pollId) REFERENCES poll(pollId)
);

CREATE TABLE IF NOT EXISTS poll_vote (
    pollId INT NOT NULL,
    userId INT NOT NULL,
    optionId INT NOT NULL,
    PRIMARY KEY (pollId, userId),
    FOREIGN KEY (pollId) REFERENCES poll(pollId),
    FOREIGN KEY (userId) REFERENCES user(userId),
    FOREIGN KEY (optionId) REFERENCES poll_option(optionId)
);

-- Hashtag table
CREATE TABLE IF NOT EXISTS hashtag (
    hashtagId INT AUTO_INCREMENT,
    tag VARCHAR(255) NOT NULL,
    PRIMARY KEY (hashtagId),
    UNIQUE (tag)
);

-- Join table between post and hashtag
CREATE TABLE IF NOT EXISTS post_hashtag (
    postId INT NOT NULL,
    hashtagId INT NOT NULL,
    PRIMARY KEY (postId, hashtagId),
    FOREIGN KEY (postId) REFERENCES post(postId),
    FOREIGN KEY (hashtagId) REFERENCES hashtag(hashtagId)
);

--Below are insertion statements to populate all tables

-- Populate the user table, this gives each user an id, a username, an encrypted password, and stores their first and last name. Note the password for all users was set to "pass".
INSERT INTO `user` (`userId`, `username`, `password`, `firstName`, `lastName`)
VALUES
	(1, 'KBrown', '$2a$10$LUdMQV4RVxrPCIRSBEMRpuRgEvSu7gis3sIdK2axNBsSIH7ZvW7fq', 'Keaton', 'Brown'),
	(2, 'JDorval', '$2a$10$gE6tQRGe3GLHSdiYBIDJOuo/M.XTILArT0/XZ9qfkfS2oQqvnaOYS', 'Justin', 'Dorval'),
	(3, 'AGupta', '$2a$10$5F0Yc91vTy/YZ4GXngFnNOcvqC1t8eoSrbfY77GazY2CSPKcc.wvm', 'Aaryan', 'Gupta'),
	(4, 'CRay', '$2a$10$fHwtzGrgEIJ9bqZz47oRxO2cq1WQt8V8wmn7JoDO8lWuuYOs75iNa', 'Connor', 'Ray'),
	(5, 'JStewart', '$2a$10$GPlkK1zsngpMPVeJYPnG9ubi65XmeUkuCn7NzLpPw2jEq/MuWubPu', 'Jacob', 'Stewart'),
	(6, 'JDoe', '$2a$10$nT6mLl8MAmc8gz7ktnNbBe2Z0eCXylIuKqYdstYuWFzWsPi.CjXuG', 'John', 'Doe');

-- Populate the post table for posts made, who made the post, the content of the post, and when the post was made.
INSERT INTO `post` (`postId`, `userId`, `content`, `postDate`)
VALUES
	(1, 1, 'My first post, I can see it too! #first', '2026-03-29 14:47:27'),
	(2, 2, 'Keaton followed me??? I havent even made a post yet, wait this is my first post too! #first', '2026-03-29 14:48:51'),
	(3, 4, 'You guys like my hashtag implementation? #first #implementation', '2026-03-29 14:52:21'),
	(4, 5, 'Wow this is a great project! #awesome #first', '2026-03-29 17:39:48'),
	(5, 3, 'How do I post? Did this go through?', '2026-03-29 17:40:52'),
	(6, 6, 'First post!!! #First', '2026-03-29 19:40:58'),
	(7, 1, 'WHere is everyone at???', '2026-03-29 19:42:27');

-- Populate the hashtag table for hashtags in posts.
INSERT INTO `hashtag` (`hashtagId`, `tag`)
VALUES
	(5, 'awesome'),
	(1, 'first'),
	(4, 'implementation');

-- Populate the post_hashtag table for which posts used which hashtags.
INSERT INTO `post_hashtag` (`postId`, `hashtagId`)
VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
	(6, 1),
	(3, 4),
	(4, 5);

-- Populate the bookmark table for which users have bookmarked which posts.
INSERT INTO `bookmark` (`postId`, `userId`)
VALUES
	(5, 1);

-- Populate the comment table for which posts have comments on them, who made the comment, what the comment said, and when it was made.
INSERT INTO `comment` (`commentId`, `postId`, `userId`, `content`, `commentDate`)
VALUES
	(1, 2, 1, 'Haha congrats man on the first post', '2026-03-29 19:44:49');

-- Populate the follow table for which users have followed who.
INSERT INTO `follow` (`followerId`, `followeeId`)
VALUES
	(2, 1),
	(3, 1),
	(4, 1),
	(5, 1),
	(1, 6);

-- Populate the heart table for who has liked (heart) which posts.
INSERT INTO `heart` (`postId`, `userId`)
VALUES
	(2, 1);

-- Populate the poll table for Poll questions, who made the poll, assign the poll an id, and when the poll was made.
INSERT INTO `poll` (`pollId`, `userId`, `question`, `pollDate`)
VALUES
	(1, 1, 'What do you think about my poll implementation?', '2026-03-28 19:58:50'),
	(2, 1, 'Hey is this working?', '2026-03-29 19:52:18');

-- Populate the poll_option table for which poll has which options, and what those options say.
INSERT INTO `poll_option` (`optionId`, `pollId`, `optionText`)
VALUES
	(1, 1, 'Its awesome!!!'),
	(2, 1, 'Its neat'),
	(3, 1, 'Its okay I guess?'),
	(4, 2, 'yes'),
	(5, 2, 'no');

-- Populate the poll_vote table for which user has voted which option for a certain poll.
INSERT INTO `poll_vote` (`pollId`, `userId`, `optionId`)
VALUES
	(1, 2, 1),
	(1, 3, 1),
	(1, 4, 1),
	(1, 5, 1),
	(2, 1, 4),
	(2, 6, 5);
