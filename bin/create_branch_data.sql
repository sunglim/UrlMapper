CREATE TABLE ua_spoof_branch(
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  BRANCH VARCHAR(24),
  SITE VARCHAR(255),
  KIND VARCHAR(24),
  STATUS INTEGER
);

INSERT INTO ua_spoof_branch (BRANCH, SITE, KIND, STATUS) values('lite', 'mail.ru', "SP_MAIL", 1);
INSERT INTO ua_spoof_branch (BRANCH, SITE, KIND, STATUS) values('lite', 'sohu.com', "SP_ANDROID_M", 1);
INSERT INTO ua_spoof_branch (BRANCH, SITE, KIND, STATUS) values('lite', 'abc.es', "SP_ABC", 0);
SELECT * from ua_spoof_branch;
