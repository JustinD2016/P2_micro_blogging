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