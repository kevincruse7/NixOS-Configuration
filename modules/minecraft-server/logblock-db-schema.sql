CREATE TABLE `lb-players` (
    playerid SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    UUID varchar(36) NOT NULL,
    playername varchar(32) NOT NULL,
    firstlogin DATETIME NOT NULL,
    lastlogin DATETIME NOT NULL,
    onlinetime TIME NOT NULL,
    ip varchar(255) NOT NULL,
    PRIMARY KEY (playerid),
    UNIQUE (playername)
);

CREATE TABLE `lb-chat` (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    playerid SMALLINT UNSIGNED NOT NULL,
    message VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    KEY playerid (playerid),
   FULLTEXT message (message)
) ENGINE=MyISAM;

CREATE TABLE `lb-world` (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    playerid SMALLINT UNSIGNED NOT NULL,
    replaced TINYINT UNSIGNED NOT NULL,
    type TINYINT UNSIGNED NOT NULL,
    data TINYINT UNSIGNED NOT NULL,
    x SMALLINT NOT NULL,
    y TINYINT UNSIGNED NOT NULL,
    z SMALLINT NOT NULL,
    PRIMARY KEY (id),
    KEY coords (x, z, y),
    KEY date (date),
    KEY playerid (playerid)
);

CREATE TABLE `lb-world-sign` (
    id INT UNSIGNED NOT NULL,
    signtext VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE `lb-world-chest` (
    id INT UNSIGNED NOT NULL,
    itemtype SMALLINT UNSIGNED NOT NULL,
    itemamount SMALLINT NOT NULL,
    itemdata TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE `lb-world-kills` (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL,
    killer SMALLINT UNSIGNED,
    victim SMALLINT UNSIGNED NOT NULL,
    weapon SMALLINT UNSIGNED NOT NULL,
    x SMALLINT NOT NULL,
    y TINYINT UNSIGNED NOT NULL,
    z SMALLINT NOT NULL,
    PRIMARY KEY (id)
);
