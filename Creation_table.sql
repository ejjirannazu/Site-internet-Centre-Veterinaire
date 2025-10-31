CREATE TABLE proprietaire (
    id_proprio serial PRIMARY KEY,
    nom varchar(50),
    prenom varchar(50),
    adresse varchar(255),
    num_tel varchar(15),
    email varchar(100),
    num_suivi varchar(102)
);

CREATE TABLE animal (
    id_animal serial PRIMARY KEY,
    espece varchar(50),
    nom varchar(50),
    age int,
    sexe char(1),
    signe_distinct varchar(50),
    id_proprio int NOT NULL,
    FOREIGN KEY (id_proprio) REFERENCES proprietaire(id_proprio)

);

CREATE TABLE employe (
    matricule serial PRIMARY KEY,
    nom varchar(50),
    prenom varchar(50),
    adresse varchar(100),
    num_tel varchar(15),
    date_naissance date,
    nss varchar(21),
    date_embauche date,
    login varchar(50),
    mdp varchar(101)
);

CREATE TABLE centre (
    id_unique serial PRIMARY KEY,
    nom varchar(50),
    adresse varchar(50),
    num_tel varchar(15),
    matricule int NOT NULL,
    FOREIGN KEY (matricule) REFERENCES employe(matricule)
);
CREATE TABLE inscription (
    id_unique int NOT NULL,
    id_animal int NOT NULL,
    FOREIGN KEY (id_unique) REFERENCES centre(id_unique),
    FOREIGN KEY (id_animal) REFERENCES animal(id_animal),
    date_inscription date
);

CREATE TABLE operation (
    id_operation serial PRIMARY KEY,
    date_operation date,
    id_nature int
);

CREATE TABLE lieu_operation (
    id_unique int NOT NULL,
    id_operation int NOT NULL,
    FOREIGN KEY (id_unique) REFERENCES centre(id_unique),
    FOREIGN KEY (id_operation) REFERENCES operation(id_operation)
);

CREATE TABLE medicament (
    id_medicament serial PRIMARY KEY,
    nom_medicament varchar(50)
);

CREATE TABLE nature (
    id_nature serial PRIMARY KEY,
    nature varchar(50)
);



CREATE TABLE ordonnance (
    id_ordonnance serial PRIMARY KEY,
    date_ordonnance date
);



CREATE TABLE donne_operation (
    matricule int NOT NULL,
    id_operation int NOT NULL,
    FOREIGN KEY (matricule) REFERENCES employe(matricule),
    FOREIGN KEY (id_operation) REFERENCES operation(id_operation)
);

CREATE TABLE donne_ordonnance (
    matricule int NOT NULL,
    id_ordonnance int NOT NULL,
    FOREIGN KEY (matricule) REFERENCES employe(matricule),
    FOREIGN KEY (id_ordonnance) REFERENCES ordonnance(id_ordonnance)
);

CREATE TABLE specialiste (
    id_spe serial PRIMARY KEY,
    nom varchar(255),
    prenom varchar(255)
);

CREATE TABLE est_specialiste (
    matricule int NOT NULL,
    id_spe int NOT NULL,
    FOREIGN KEY (matricule) REFERENCES employe(matricule),
    FOREIGN KEY (id_spe) REFERENCES specialiste(id_spe)
);


CREATE TABLE prescrit (
    id_ordonnance int,
    id_medicament int,
    PRIMARY KEY (id_ordonnance, id_medicament),
    FOREIGN KEY (id_ordonnance) REFERENCES ordonnance(id_ordonnance),
    FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament)
);



CREATE TABLE recoit_operation (
    id_operation int,
    id_animal int,
    PRIMARY KEY (id_operation, id_animal),
    FOREIGN KEY (id_operation) REFERENCES operation(id_operation),
    FOREIGN KEY (id_animal) REFERENCES animal(id_animal)
);

CREATE TABLE applique(
    id_animal int,
    id_medicament int,
    PRIMARY KEY (id_medicament, id_animal),
    FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament),
    FOREIGN KEY (id_animal) REFERENCES animal(id_animal)
);

CREATE TABLE recoit_ordonnance (
    id_ordonnance int,
    id_proprio int,
    PRIMARY KEY (id_ordonnance, id_proprio),
    FOREIGN KEY (id_ordonnance) REFERENCES ordonnance(id_ordonnance),
    FOREIGN KEY (id_proprio) REFERENCES proprietaire(id_proprio)
);

CREATE TABLE travaille (
    matricule int,
    id_unique int,
    PRIMARY KEY (matricule, id_unique),
    FOREIGN KEY (matricule) REFERENCES employe(matricule),
    FOREIGN KEY (id_unique) REFERENCES centre(id_unique)
);


INSERT INTO proprietaire(nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Remplacant', 'Faker', '86 Rue du Nid', '06 23 45 67 90', 'sophie.leblanc@email.com', 78945);
INSERT INTO proprietaire(nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Ama', 'Castor', '32 Avenue du Lardon', '07 76 54 32 15', 'luc.giroux@email.com', 71105);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Kuroko', 'Kagami', '23 Rue des Champs', '07 45 67 88 13', 'catherine.tremblay@email.com', 71586);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('David', 'Lucy', '4 Avenue des Roses', '06 43 65 87 92', 'philippe.deschamps@email.com', 15914);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Kousei', 'Kaori', '97 Rue de la Lune', '07 65 87 09 26', 'claudia.lavoie@email.com', 71006);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Zuka', 'Oni', '80 Avenue de Mars', '06 87 09 21 49', 'francois.bernier@email.com', 64560);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Lynx', 'Ash', '62 Rue de Jupiter', '07 09 21 43 88', 'julie.bergeron@email.com', 05961);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Ackerman', 'Levi', '25 Avenue de Saturne', '06 21 43 65 10', 'stephane.lapointe@email.com', 95185);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Ackerman', 'Mikasa', '8 Rue de Neptune', '07 43 65 87 50', 'nathalie.fortin@email.com', 95486);
INSERT INTO proprietaire( nom, prenom, adresse, num_tel, email, num_suivi)
VALUES ('Roger', 'Gold', '1 Avenue de Pluton', '06 65 87 09 25', 'patrick.boucher@email.com', 31560);

INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Daddy', 'Anna', '193 Rue de Paris', '07 23 45 67 87', '1980-05-15', '1 80 05 78 066 084 36', '2022-01-10', 'jdupont', 'password123');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Artefact', 'Troupedore', '45 Avenue de Lyon', '06 76 54 32 11', '1992-08-20', '2 92 08 58 098 765 43', '2022-02-05', 'mmartin', 'secret456');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Furina', 'Cessix', '782 Rue du Soleil', '07 45 67 89 13', '1985-12-30', '1 85 12 22 333 444 55', '2022-03-20', 'plefevre', 'secure789');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Coupe', 'Tece', '11 Avenue des Roses', '06 43 65 87 91', '1990-06-25', '2 90 06 87 654 321 09', '2022-04-15', 'idufour', 'pass123word');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Substats', 'Tecedece', '2 Rue de la Lune', '07 65 87 09 22', '1982-03-18', '1 82 03 76 54 321 098', '2022-05-12', 'pgirard', 'letmein456');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Casque', 'Tece', '67 Avenue de Mars', '06 87 09 21 44', '1995-09-10', '2 95 09 34 45 56 67', '2022-06-08', 'slemoine', 'password789');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Double', 'Couronne', '89 Rue de Jupiter', '07 99 21 43 66', '1988-07-05', '1 88 07 90 12 23 34', '2022-07-03', 'mmorel', 'securepass');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Competence', 'Dechainement', '12 Avenue de Saturne', '06 21 43 65 88', '1991-04-02', '2 91 04 22 33 44 55', '2022-08-18', 'jfournier', 'pass1234');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Otage', 'Taby', '35 Rue de Neptune', '07 43 65 87 10', '1987-11-15', '1 87 11 90 09 87 65', '2022-09-22', 'nrobin', 'securepass123');
INSERT INTO employe( nom, prenom, adresse, num_tel, date_naissance, nss, date_embauche, login, mdp)
VALUES ( 'Zen', 'Toutperdu', '28 Avenue de Pluton', '06 65 87 09 23', '1993-02-28', '2 93 02 45 67 89 02', '2022-10-15', 'lcaron', 'password1234');



INSERT INTO nature(nature)
VALUES ( 'Chirurgie');
INSERT INTO nature( nature)
VALUES ( 'Radiologie');
INSERT INTO nature( nature)
VALUES ( 'Vaccination');
INSERT INTO nature( nature)
VALUES ( 'Consultation');
INSERT INTO nature( nature)
VALUES ( 'Analyses sanguines');
INSERT INTO nature( nature)
VALUES ( 'Soins dentaires');
INSERT INTO nature( nature)
VALUES ( 'Kinesitherapie');
INSERT INTO nature( nature)
VALUES ( 'Imagerie medicale');
INSERT INTO nature( nature)
VALUES ( 'Urgence');
INSERT INTO nature( nature)
VALUES ( 'Physiotherapie');

INSERT INTO medicament( nom_medicament)
VALUES ( 'Paracetamol');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Amoxicilline');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Ibuprofene');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Aspirine');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Omeprazole');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Loratadine');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Morphine');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Ciprofloxacine');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Atorvastatine');
INSERT INTO medicament( nom_medicament)
VALUES ( 'Sertraline');

INSERT INTO specialiste( nom, prenom)
VALUES ('Daddy', 'Anna');
INSERT INTO specialiste( nom, prenom)
VALUES ('Artefact', 'Troupedore');
INSERT INTO specialiste( nom, prenom)
VALUES ('Furina', 'Cessix');
INSERT INTO specialiste( nom, prenom)
VALUES ('Coupe', 'Tece');


INSERT INTO est_specialiste(matricule, id_spe)
VALUES (1,1);
INSERT INTO est_specialiste(matricule, id_spe)
VALUES (2,2);
INSERT INTO est_specialiste(matricule, id_spe)
VALUES (4,3);
INSERT INTO est_specialiste(matricule, id_spe)
VALUES (6,4);


INSERT INTO centre( nom, adresse, num_tel, matricule)
VALUES ( 'Centre A', '123 Rue de Paris', '01 23 45 67 89', 4);
INSERT INTO centre( nom, adresse, num_tel, matricule)
VALUES ( 'Centre B', '456 Avenue de Lyon', '98 76 54 32 10', 7);
INSERT INTO centre( nom, adresse, num_tel, matricule)
VALUES ( 'Centre C', '789 Rue du Soleil', '03 45 67 89 12', 3);
INSERT INTO centre( nom, adresse, num_tel, matricule)
VALUES ( 'Centre D', '101 Avenue des Roses', '21 43 65 87 90', 9);

INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chien', 'Raptor', 9, 'M', 'Tache blanche', 1);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chat', 'Grougaloragram', 10, 'F', 'Collier rouge', 5);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Perroquet', 'Chopper', 4, 'M', 'Plumes multicolores', 2);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chien', 'Zozolito', 15, 'M', 'Queue courte', 9);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chat', 'Claraaa', 9, 'F', 'Oreille droite pliée', 9);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Perroquet', 'Kyu', 2, 'F', 'Plumes jaunes', 3);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chien', 'Truth', 6, 'F', 'Oreille gauche pliée', 4);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chat', 'Idriss', 3, 'M', 'Tache noire sur le dos', 4);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Hamster', 'Dede', 11, 'M', 'Pelage bouclé', 5);
INSERT INTO animal( espece, nom, age, sexe, signe_distinct, id_proprio) 
VALUES ( 'Chien', 'Ryry linnocent', 5, 'F', 'Yeux vairons', 7);

INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (1, 1, '2023-01-15');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (2, 2, '2023-02-20');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (3, 3, '2023-03-10');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (4, 4, '2023-04-05');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (3, 5, '2023-05-12');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (2, 6, '2023-06-08');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (1, 7, '2023-07-03');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (1, 8, '2023-08-18');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (4, 9, '2023-09-22');
INSERT INTO inscription(id_unique, id_animal, date_inscription)
VALUES (3, 10, '2023-10-15');


INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-01-15', 1);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-02-20', 2);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-03-10', 3);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-04-05', 4);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-05-12', 5);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-06-08', 6);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-07-03', 7);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-08-18', 8);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-09-22', 9);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-10-15', 10);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-12-12', 5);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-12-13', 3);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-12-19', 4);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2024-01-31', 8);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2023-02-01', 4);
INSERT INTO operation( date_operation, id_nature)
VALUES ( '2024-09-04', 4);

INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (1,1);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (2,2);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (3,3);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (4,4);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (2,5);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (3,6);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (4,7);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (1,8);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (3,9);
INSERT INTO lieu_operation(id_unique, id_operation)
VALUES (2,10);








INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-01-15');
INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-02-20');
INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-03-10');
INSERT INTO ordonnance( date_ordonnance)
VALUES ('2023-04-05');
INSERT INTO ordonnance( date_ordonnance)
VALUES ('2023-05-12');
INSERT INTO ordonnance( date_ordonnance)
VALUES ('2023-06-08');
INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-07-03');
INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-08-18');
INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-09-22');
INSERT INTO ordonnance(date_ordonnance)
VALUES ('2023-10-15');

INSERT INTO donne_operation(matricule, id_operation)
VALUES (1,1);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (2,2);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (3,3);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (4,4);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (5,5);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (6,6);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (7,7);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (8,8);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (9,9);
INSERT INTO donne_operation(matricule, id_operation)
VALUES (10,10);

INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (1,1);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (2,2);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (3,3);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (4,4);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (1,5);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (6,6);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (5,7);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (2,8);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (8,9);
INSERT INTO donne_ordonnance(matricule, id_ordonnance)
VALUES (9,10);

INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (1,1);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (2,2);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (3,3);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (4,4);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (5,5);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (6,6);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (7,7);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (8,8);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (9,9);
INSERT INTO prescrit(id_medicament, id_ordonnance)
VALUES (10,10);



INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (1,1);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (2,2);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (3,3);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (4,4);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (6,5);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (6,6);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (5,7);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (8,8);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (9,9);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (8,10);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (1,11);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (4,12);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (6,13);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (2,14);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (1,15);
INSERT INTO recoit_operation(id_animal, id_operation)
VALUES (1,16);

INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (1,1);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (2,2);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (3,3);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (4,4);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (1,5);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (6,6);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (5,7);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (2,8);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (8,9);
INSERT INTO recoit_ordonnance(id_proprio, id_ordonnance)
VALUES (9,10);







INSERT INTO applique(id_medicament, id_animal)
VALUES (1,1);
INSERT INTO applique(id_medicament, id_animal)
VALUES (2,3);
INSERT INTO applique(id_medicament, id_animal)
VALUES (3,6);
INSERT INTO applique(id_medicament, id_animal)
VALUES (4,8);
INSERT INTO applique(id_medicament, id_animal)
VALUES (5,1);
INSERT INTO applique(id_medicament, id_animal)
VALUES (6,2);
INSERT INTO applique(id_medicament, id_animal)
VALUES (7,3);
INSERT INTO applique(id_medicament, id_animal)
VALUES (8,5);

INSERT INTO travaille(matricule, id_unique)
VALUES (9, 3);
INSERT INTO travaille(matricule, id_unique)
VALUES (7, 4);
INSERT INTO travaille(matricule, id_unique)
VALUES (4, 2);
INSERT INTO travaille(matricule, id_unique)
VALUES (1, 2);
INSERT INTO travaille(matricule, id_unique)
VALUES (6, 1);
INSERT INTO travaille(matricule, id_unique)
VALUES (2, 1);
INSERT INTO travaille(matricule, id_unique)
VALUES (10, 3);
INSERT INTO travaille(matricule, id_unique)
VALUES (8, 2);
INSERT INTO travaille(matricule, id_unique)
VALUES (3, 3);
INSERT INTO travaille(matricule, id_unique)
VALUES (5, 4);
INSERT INTO travaille(matricule, id_unique)
VALUES (9, 4);
INSERT INTO travaille(matricule, id_unique)
VALUES (2, 4);
INSERT INTO travaille(matricule, id_unique)
VALUES (7, 2);
INSERT INTO travaille(matricule, id_unique)
VALUES (10, 1);
INSERT INTO travaille(matricule, id_unique)
VALUES (1, 3);
INSERT INTO travaille(matricule, id_unique)
VALUES (5, 2);
INSERT INTO travaille(matricule, id_unique)
VALUES (8, 3);
INSERT INTO travaille(matricule, id_unique)
VALUES (4, 3);
INSERT INTO travaille(matricule, id_unique)
VALUES (6, 4);
INSERT INTO travaille(matricule, id_unique)
VALUES (3, 1);
INSERT INTO travaille(matricule, id_unique)
VALUES (4,1);


CREATE VIEW espece_age AS
 SELECT animal.espece,
    avg(animal.age) AS avg
   FROM animal
  GROUP BY animal.espece;

CREATE VIEW espece_nature AS
 SELECT animal.espece,nature.nature 
 FROM (animal NATURAL JOIN recoit_operation NATURAL JOIN operation NATURAL JOIN nature);

CREATE VIEW espece_operation AS
 SELECT espece_nature.espece,
    espece_nature.nature,
    count(espece_nature.nature) AS count
   FROM espece_nature
  GROUP BY espece_nature.espece, espece_nature.nature;

CREATE VIEW statistique AS
 SELECT espece_age.espece,
    espece_age.avg,
    espece_operation.nature,
    espece_operation.count
   FROM (espece_age NATURAL JOIN espece_operation)
  ORDER BY espece_age.espece;