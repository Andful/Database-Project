INSERT INTO users VALUES ('andrea', '2017-10-13', '$2a$10$/Ub33GC9Ob3KKUCi.IB81u5N9wFz4ZoZndYCcsOZ6e4w4PbjxqoAa', '0000000000', 'sxS4D3R4Jomh02suiyzzCVcfgTeitS');
INSERT INTO users VALUES ('ryan', '2017-10-16', '$2a$10$3T3tgynbUATHUVgp1VfPDukXy0Td89ShQpzQdd.uC0ESgg1vx0CDm', '0011001100', 'S3mKS9NiqUEbz8xqw0ETHBUOTNXPp5');
INSERT INTO users VALUES ('anton', '2017-10-17', '$2a$10$UL9gLJ9/hLVkLK0beffqAegseW5vxE8I9FduDBUn4qIIqXUeTGijm', '0000011111', 'EWoPnVIFQQWQtoW3owXvUA6mSkOBhb');
INSERT INTO users VALUES ('anton2', '2017-10-17', '$2a$10$EI8oHCemuXaQg9gsziexaucEdSsorHnn17qiEyFAF.uOWodc3T1ly', '1010100101', 'DxIuLNGYMEFSXNPyBGq2veDw29YrPQ');

INSERT INTO users VALUES ('customer1', '2017-10-13', '$2a$10$/Ub33GC9Ob3KKUCi.IB81u5N9wFz4ZoZndYCcsOZ6e4w4PbjxqoAa', '0000000000', 'sxS4D3R4Jomh02suiyzzCVcfgTeita');
INSERT INTO users VALUES ('customer2', '2017-10-16', '$2a$10$3T3tgynbUATHUVgp1VfPDukXy0Td89ShQpzQdd.uC0ESgg1vx0CDm', '0011001100', 'S3mKS9NiqUEbz8xqw0ETHBUOTNXPpa');
INSERT INTO users VALUES ('customer3', '2017-10-17', '$2a$10$UL9gLJ9/hLVkLK0beffqAegseW5vxE8I9FduDBUn4qIIqXUeTGijm', '0000011111', 'EWoPnVIFQQWQtoW3owXvUA6mSkOBha');
INSERT INTO users VALUES ('customer4', '2017-10-17', '$2a$10$EI8oHCemuXaQg9gsziexaucEdSsorHnn17qiEyFAF.uOWodc3T1ly', '1010100101', 'DxIuLNGYMEFSXNPyBGq2veDw29YrPa');

INSERT INTO Team VALUES (1,NULL,'10/10/2010');
INSERT INTO Team VALUES (2,NULL,'10/10/2010');
INSERT INTO Team VALUES (3,NULL,'10/10/2010');
INSERT INTO Team VALUES (4,NULL,'10/10/2010');

INSERT INTO Employee VALUES ('andrea',  1 , 1, 'andrea', 'address 12', 3000, 'busy' );
INSERT INTO Employee VALUES ('ryan',  1 , 2, 'ryan', 'address 22', 3000, 'schedule' );
INSERT INTO Employee VALUES ('anton',  1 , 3, 'anton', 'address 14', 3000, 'schedule' );
INSERT INTO Employee VALUES ('anton2',  1 , 4, 'anton', 'address 16', 3000, 'schedule' );

INSERT INTO Customer VALUES ('customer1');
INSERT INTO Customer VALUES ('customer2');
INSERT INTO Customer VALUES ('customer3');
INSERT INTO Customer VALUES ('customer4');

INSERT INTO Moderator VALUES (1);
INSERT INTO Moderator VALUES (2);
INSERT INTO Moderator VALUES (3);
INSERT INTO Moderator VALUES (4);

INSERT INTO Specialist VALUES (1,'sleeping');
INSERT INTO Specialist VALUES (2,'database');
INSERT INTO Specialist VALUES (3,'java');
INSERT INTO Specialist VALUES (4,'nose picking');

INSERT INTO Manager VALUES(1);
INSERT INTO Manager VALUES(2);
INSERT INTO Manager VALUES(3);
INSERT INTO Manager VALUES(4);

INSERT INTO Topic VALUES (1,'database','data');
INSERT INTO Topic VALUES (1,'database2','data');
INSERT INTO Topic VALUES (1,'database3','data');
INSERT INTO Topic VALUES (1,'database4','data');

INSERT INTO Thread VALUES (1,'andrea','database','How to basic','hello','10/10/2010');
INSERT INTO Thread VALUES (2,'andrea','database','How to basic','hello','10/10/2010');
INSERT INTO Thread VALUES (3,'andrea','database','How to basic','hello','10/10/2010');
INSERT INTO Thread VALUES (4,'andrea','database','How to basic','hello','10/10/2010');

INSERT INTO Message VALUES ('andrea',1,1,'10/10/2010','hello');
INSERT INTO Message VALUES ('andrea',1,2,'10/10/2010','hello');
INSERT INTO Message VALUES ('andrea',1,3,'10/10/2010','hello');
INSERT INTO Message VALUES ('andrea',1,4,'10/10/2010','hello');

INSERT INTO Is_Moderated_By VALUES (1,1);
INSERT INTO Is_Moderated_By VALUES (2,2);
INSERT INTO Is_Moderated_By VALUES (3,3);
INSERT INTO Is_Moderated_By VALUES (4,4);


