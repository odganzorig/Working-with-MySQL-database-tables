# Working with databases
#
# This script will delete and then remake the tables for this assignment.
# Load the script when you need to "reset" things.
# You will also add your solutions at the bottom.

DROP TABLE IF EXISTS acquaintances;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS profiles;

# Add your answers here

CREATE TABLE profiles (
	username VARCHAR(20) UNIQUE NOT NULL,
    first VARCHAR(40),
    last  VARCHAR(40),
    PRIMARY KEY (username)
);

CREATE TABLE messages (
	id INT NOT NULL UNIQUE AUTO_INCREMENT,
    sender VARCHAR(20) NOT NULL,
    recipient  VARCHAR(20) NOT NULL,
    message VARCHAR(400) NOT NULL DEFAULT 0,
    is_read TINYINT(1) NOT NULL DEFAULT FALSE,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    in_reply_to INT DEFAULT NULL,
    FOREIGN KEY (sender) REFERENCES profiles(username) ON DELETE CASCADE,
    FOREIGN KEY (recipient) REFERENCES profiles(username) ON DELETE CASCADE,
    FOREIGN KEY (in_reply_to) REFERENCES messages(id) ON DELETE SET NULL,
    PRIMARY KEY (id)
);

CREATE TABLE acquaintances (
	source VARCHAR(20) NOT NULL,
    target VARCHAR(20) NOT NULL,
    PRIMARY KEY (source, target)
);

INSERT INTO profiles (username, first, last) VALUES
    ("admin", NULL, "Admin"),
    ("ganzorigo21", "Od", "Ganzorig"),
    ("scientist", "Alan", "Turning");
    
INSERT INTO acquaintances (source, target) VALUES
	("ganzorigo21", "scientist");
    
INSERT INTO acquaintances (source, target)
SELECT "admin", p.username
FROM profiles p
WHERE p.username <> "admin";


INSERT INTO messages (sender, recipient, message) VALUES
	("ganzorigo21", "scientist", "Congratulations, Alan Turning, on developing a machine that helped break the German Enigma code!");
    
INSERT INTO messages (sender, recipient, message, is_read)
SELECT "admin", a.target, "Welcome to our messaging service", 1
FROM acquaintances a
WHERE a.source = "admin";

INSERT INTO messages (sender, recipient, message, in_reply_to)
SELECT "scientist", m.sender, "I apologize for not replying to all of your messages.", m.id
FROM messages m
WHERE m.recipient = "scientist"
AND m.is_read = 0;

UPDATE messages m    
SET m.is_read = 1
WHERE recipient = "scientist";

SELECT sender, recipient
FROM messages m
WHERE NOT EXISTS (SELECT m.sender
FROM acquaintances a
WHERE m.sender = a.source
AND m.recipient = a.target);




