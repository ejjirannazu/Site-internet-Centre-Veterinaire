--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.6.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: animal; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.animal (
    id_animal integer NOT NULL,
    espece character varying(50),
    nom character varying(50),
    age integer,
    sexe character(1),
    signe_distinct character varying(50),
    id_proprio integer NOT NULL
);


ALTER TABLE public.animal OWNER TO "mehdi.maouche";

--
-- Name: animal_id_animal_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.animal_id_animal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.animal_id_animal_seq OWNER TO "mehdi.maouche";

--
-- Name: animal_id_animal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.animal_id_animal_seq OWNED BY public.animal.id_animal;


--
-- Name: applique; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.applique (
    id_animal integer NOT NULL,
    id_medicament integer NOT NULL
);


ALTER TABLE public.applique OWNER TO "mehdi.maouche";

--
-- Name: centre; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.centre (
    id_unique integer NOT NULL,
    nom character varying(50),
    adresse character varying(50),
    num_tel character varying(15),
    matricule integer NOT NULL
);


ALTER TABLE public.centre OWNER TO "mehdi.maouche";

--
-- Name: centre_id_unique_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.centre_id_unique_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.centre_id_unique_seq OWNER TO "mehdi.maouche";

--
-- Name: centre_id_unique_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.centre_id_unique_seq OWNED BY public.centre.id_unique;


--
-- Name: donne_operation; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.donne_operation (
    matricule integer NOT NULL,
    id_operation integer NOT NULL
);


ALTER TABLE public.donne_operation OWNER TO "mehdi.maouche";

--
-- Name: donne_ordonnance; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.donne_ordonnance (
    matricule integer NOT NULL,
    id_ordonnance integer NOT NULL
);


ALTER TABLE public.donne_ordonnance OWNER TO "mehdi.maouche";

--
-- Name: employe; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.employe (
    matricule integer NOT NULL,
    nom character varying(50),
    prenom character varying(50),
    adresse character varying(100),
    num_tel character varying(15),
    date_naissance date,
    nss character varying(21),
    date_embauche date,
    login character varying(50),
    mdp character varying(101)
);


ALTER TABLE public.employe OWNER TO "mehdi.maouche";

--
-- Name: employe_matricule_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.employe_matricule_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employe_matricule_seq OWNER TO "mehdi.maouche";

--
-- Name: employe_matricule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.employe_matricule_seq OWNED BY public.employe.matricule;


--
-- Name: espece_age; Type: VIEW; Schema: public; Owner: mehdi.maouche
--

CREATE VIEW public.espece_age AS
 SELECT animal.espece,
    avg(animal.age) AS avg
   FROM public.animal
  GROUP BY animal.espece;


ALTER TABLE public.espece_age OWNER TO "mehdi.maouche";

--
-- Name: nature; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.nature (
    id_nature integer NOT NULL,
    nature character varying(50)
);


ALTER TABLE public.nature OWNER TO "mehdi.maouche";

--
-- Name: operation; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.operation (
    id_operation integer NOT NULL,
    date_operation date,
    id_nature integer
);


ALTER TABLE public.operation OWNER TO "mehdi.maouche";

--
-- Name: recoit_operation; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.recoit_operation (
    id_operation integer NOT NULL,
    id_animal integer NOT NULL
);


ALTER TABLE public.recoit_operation OWNER TO "mehdi.maouche";

--
-- Name: espece_nature; Type: VIEW; Schema: public; Owner: mehdi.maouche
--

CREATE VIEW public.espece_nature AS
 SELECT animal.espece,
    nature.nature
   FROM (((public.animal
     JOIN public.recoit_operation USING (id_animal))
     JOIN public.operation USING (id_operation))
     JOIN public.nature USING (id_nature));


ALTER TABLE public.espece_nature OWNER TO "mehdi.maouche";

--
-- Name: espece_operation; Type: VIEW; Schema: public; Owner: mehdi.maouche
--

CREATE VIEW public.espece_operation AS
 SELECT espece_nature.espece,
    espece_nature.nature,
    count(espece_nature.nature) AS count
   FROM public.espece_nature
  GROUP BY espece_nature.espece, espece_nature.nature;


ALTER TABLE public.espece_operation OWNER TO "mehdi.maouche";

--
-- Name: est_specialiste; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.est_specialiste (
    matricule integer NOT NULL,
    id_spe integer NOT NULL
);


ALTER TABLE public.est_specialiste OWNER TO "mehdi.maouche";

--
-- Name: inscription; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.inscription (
    id_unique integer NOT NULL,
    id_animal integer NOT NULL,
    date_inscription date
);


ALTER TABLE public.inscription OWNER TO "mehdi.maouche";

--
-- Name: lieu_operation; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.lieu_operation (
    id_unique integer NOT NULL,
    id_operation integer NOT NULL
);


ALTER TABLE public.lieu_operation OWNER TO "mehdi.maouche";

--
-- Name: medicament; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.medicament (
    id_medicament integer NOT NULL,
    nom_medicament character varying(50)
);


ALTER TABLE public.medicament OWNER TO "mehdi.maouche";

--
-- Name: medicament_id_medicament_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.medicament_id_medicament_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicament_id_medicament_seq OWNER TO "mehdi.maouche";

--
-- Name: medicament_id_medicament_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.medicament_id_medicament_seq OWNED BY public.medicament.id_medicament;


--
-- Name: nature_id_nature_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.nature_id_nature_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nature_id_nature_seq OWNER TO "mehdi.maouche";

--
-- Name: nature_id_nature_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.nature_id_nature_seq OWNED BY public.nature.id_nature;


--
-- Name: operation_id_operation_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.operation_id_operation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.operation_id_operation_seq OWNER TO "mehdi.maouche";

--
-- Name: operation_id_operation_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.operation_id_operation_seq OWNED BY public.operation.id_operation;


--
-- Name: ordonnance; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.ordonnance (
    id_ordonnance integer NOT NULL,
    date_ordonnance date
);


ALTER TABLE public.ordonnance OWNER TO "mehdi.maouche";

--
-- Name: ordonnance_id_ordonnance_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.ordonnance_id_ordonnance_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ordonnance_id_ordonnance_seq OWNER TO "mehdi.maouche";

--
-- Name: ordonnance_id_ordonnance_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.ordonnance_id_ordonnance_seq OWNED BY public.ordonnance.id_ordonnance;


--
-- Name: prescrit; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.prescrit (
    id_ordonnance integer NOT NULL,
    id_medicament integer NOT NULL
);


ALTER TABLE public.prescrit OWNER TO "mehdi.maouche";

--
-- Name: proprietaire; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.proprietaire (
    id_proprio integer NOT NULL,
    nom character varying(50),
    prenom character varying(50),
    adresse character varying(255),
    num_tel character varying(15),
    email character varying(100),
    num_suivi character varying(102)
);


ALTER TABLE public.proprietaire OWNER TO "mehdi.maouche";

--
-- Name: proprietaire_id_proprio_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.proprietaire_id_proprio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.proprietaire_id_proprio_seq OWNER TO "mehdi.maouche";

--
-- Name: proprietaire_id_proprio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.proprietaire_id_proprio_seq OWNED BY public.proprietaire.id_proprio;


--
-- Name: recoit_ordonnance; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.recoit_ordonnance (
    id_ordonnance integer NOT NULL,
    id_proprio integer NOT NULL
);


ALTER TABLE public.recoit_ordonnance OWNER TO "mehdi.maouche";

--
-- Name: specialiste; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.specialiste (
    id_spe integer NOT NULL,
    nom character varying(255),
    prenom character varying(255)
);


ALTER TABLE public.specialiste OWNER TO "mehdi.maouche";

--
-- Name: specialiste_id_spe_seq; Type: SEQUENCE; Schema: public; Owner: mehdi.maouche
--

CREATE SEQUENCE public.specialiste_id_spe_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specialiste_id_spe_seq OWNER TO "mehdi.maouche";

--
-- Name: specialiste_id_spe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mehdi.maouche
--

ALTER SEQUENCE public.specialiste_id_spe_seq OWNED BY public.specialiste.id_spe;


--
-- Name: statistique; Type: VIEW; Schema: public; Owner: mehdi.maouche
--

CREATE VIEW public.statistique AS
 SELECT espece_age.espece,
    espece_age.avg,
    espece_operation.nature,
    espece_operation.count
   FROM (public.espece_age
     JOIN public.espece_operation USING (espece))
  ORDER BY espece_age.espece;


ALTER TABLE public.statistique OWNER TO "mehdi.maouche";

--
-- Name: travaille; Type: TABLE; Schema: public; Owner: mehdi.maouche
--

CREATE TABLE public.travaille (
    matricule integer NOT NULL,
    id_unique integer NOT NULL
);


ALTER TABLE public.travaille OWNER TO "mehdi.maouche";

--
-- Name: animal id_animal; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.animal ALTER COLUMN id_animal SET DEFAULT nextval('public.animal_id_animal_seq'::regclass);


--
-- Name: centre id_unique; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.centre ALTER COLUMN id_unique SET DEFAULT nextval('public.centre_id_unique_seq'::regclass);


--
-- Name: employe matricule; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.employe ALTER COLUMN matricule SET DEFAULT nextval('public.employe_matricule_seq'::regclass);


--
-- Name: medicament id_medicament; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.medicament ALTER COLUMN id_medicament SET DEFAULT nextval('public.medicament_id_medicament_seq'::regclass);


--
-- Name: nature id_nature; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.nature ALTER COLUMN id_nature SET DEFAULT nextval('public.nature_id_nature_seq'::regclass);


--
-- Name: operation id_operation; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.operation ALTER COLUMN id_operation SET DEFAULT nextval('public.operation_id_operation_seq'::regclass);


--
-- Name: ordonnance id_ordonnance; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.ordonnance ALTER COLUMN id_ordonnance SET DEFAULT nextval('public.ordonnance_id_ordonnance_seq'::regclass);


--
-- Name: proprietaire id_proprio; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.proprietaire ALTER COLUMN id_proprio SET DEFAULT nextval('public.proprietaire_id_proprio_seq'::regclass);


--
-- Name: specialiste id_spe; Type: DEFAULT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.specialiste ALTER COLUMN id_spe SET DEFAULT nextval('public.specialiste_id_spe_seq'::regclass);


--
-- Data for Name: animal; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.animal VALUES (1, 'Chien', 'Raptor', 9, 'M', 'Tache blanche', 1);
INSERT INTO public.animal VALUES (2, 'Chat', 'Grougaloragram', 10, 'F', 'Collier rouge', 5);
INSERT INTO public.animal VALUES (3, 'Perroquet', 'Chopper', 4, 'M', 'Plumes multicolores', 2);
INSERT INTO public.animal VALUES (4, 'Chien', 'Zozolito', 15, 'M', 'Queue courte', 9);
INSERT INTO public.animal VALUES (5, 'Chat', 'Claraaa', 9, 'F', 'Oreille droite pliée', 9);
INSERT INTO public.animal VALUES (6, 'Perroquet', 'Kyu', 2, 'F', 'Plumes jaunes', 3);
INSERT INTO public.animal VALUES (7, 'Chien', 'Truth', 6, 'F', 'Oreille gauche pliée', 4);
INSERT INTO public.animal VALUES (8, 'Chat', 'Idriss', 3, 'M', 'Tache noire sur le dos', 4);
INSERT INTO public.animal VALUES (9, 'Hamster', 'Dede', 11, 'M', 'Pelage bouclé', 5);
INSERT INTO public.animal VALUES (10, 'Chien', 'Ryry linnocent', 5, 'F', 'Yeux vairons', 7);


--
-- Name: animal_id_animal_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.animal_id_animal_seq', 10, true);


--
-- Data for Name: applique; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.applique VALUES (1, 1);
INSERT INTO public.applique VALUES (3, 2);
INSERT INTO public.applique VALUES (6, 3);
INSERT INTO public.applique VALUES (8, 4);
INSERT INTO public.applique VALUES (1, 5);
INSERT INTO public.applique VALUES (2, 6);
INSERT INTO public.applique VALUES (3, 7);
INSERT INTO public.applique VALUES (5, 8);


--
-- Data for Name: centre; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.centre VALUES (1, 'Centre A', '123 Rue de Paris', '01 23 45 67 89', 4);
INSERT INTO public.centre VALUES (2, 'Centre B', '456 Avenue de Lyon', '98 76 54 32 10', 7);
INSERT INTO public.centre VALUES (3, 'Centre C', '789 Rue du Soleil', '03 45 67 89 12', 3);
INSERT INTO public.centre VALUES (4, 'Centre D', '101 Avenue des Roses', '21 43 65 87 90', 9);


--
-- Name: centre_id_unique_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.centre_id_unique_seq', 4, true);


--
-- Data for Name: donne_operation; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.donne_operation VALUES (1, 1);
INSERT INTO public.donne_operation VALUES (2, 2);
INSERT INTO public.donne_operation VALUES (3, 3);
INSERT INTO public.donne_operation VALUES (4, 4);
INSERT INTO public.donne_operation VALUES (5, 5);
INSERT INTO public.donne_operation VALUES (6, 6);
INSERT INTO public.donne_operation VALUES (7, 7);
INSERT INTO public.donne_operation VALUES (8, 8);
INSERT INTO public.donne_operation VALUES (9, 9);
INSERT INTO public.donne_operation VALUES (10, 10);


--
-- Data for Name: donne_ordonnance; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.donne_ordonnance VALUES (1, 1);
INSERT INTO public.donne_ordonnance VALUES (2, 2);
INSERT INTO public.donne_ordonnance VALUES (3, 3);
INSERT INTO public.donne_ordonnance VALUES (4, 4);
INSERT INTO public.donne_ordonnance VALUES (1, 5);
INSERT INTO public.donne_ordonnance VALUES (6, 6);
INSERT INTO public.donne_ordonnance VALUES (5, 7);
INSERT INTO public.donne_ordonnance VALUES (2, 8);
INSERT INTO public.donne_ordonnance VALUES (8, 9);
INSERT INTO public.donne_ordonnance VALUES (9, 10);


--
-- Data for Name: employe; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.employe VALUES (1, 'Daddy', 'Anna', '193 Rue de Paris', '07 23 45 67 87', '1980-05-15', '1 80 05 78 066 084 36', '2022-01-10', 'jdupont', 'password123');
INSERT INTO public.employe VALUES (2, 'Artefact', 'Troupedore', '45 Avenue de Lyon', '06 76 54 32 11', '1992-08-20', '2 92 08 58 098 765 43', '2022-02-05', 'mmartin', 'secret456');
INSERT INTO public.employe VALUES (3, 'Furina', 'Cessix', '782 Rue du Soleil', '07 45 67 89 13', '1985-12-30', '1 85 12 22 333 444 55', '2022-03-20', 'plefevre', 'secure789');
INSERT INTO public.employe VALUES (4, 'Coupe', 'Tece', '11 Avenue des Roses', '06 43 65 87 91', '1990-06-25', '2 90 06 87 654 321 09', '2022-04-15', 'idufour', 'pass123word');
INSERT INTO public.employe VALUES (5, 'Substats', 'Tecedece', '2 Rue de la Lune', '07 65 87 09 22', '1982-03-18', '1 82 03 76 54 321 098', '2022-05-12', 'pgirard', 'letmein456');
INSERT INTO public.employe VALUES (6, 'Casque', 'Tece', '67 Avenue de Mars', '06 87 09 21 44', '1995-09-10', '2 95 09 34 45 56 67', '2022-06-08', 'slemoine', 'password789');
INSERT INTO public.employe VALUES (7, 'Double', 'Couronne', '89 Rue de Jupiter', '07 99 21 43 66', '1988-07-05', '1 88 07 90 12 23 34', '2022-07-03', 'mmorel', 'securepass');
INSERT INTO public.employe VALUES (8, 'Competence', 'Dechainement', '12 Avenue de Saturne', '06 21 43 65 88', '1991-04-02', '2 91 04 22 33 44 55', '2022-08-18', 'jfournier', 'pass1234');
INSERT INTO public.employe VALUES (9, 'Otage', 'Taby', '35 Rue de Neptune', '07 43 65 87 10', '1987-11-15', '1 87 11 90 09 87 65', '2022-09-22', 'nrobin', 'securepass123');
INSERT INTO public.employe VALUES (10, 'Zen', 'Toutperdu', '28 Avenue de Pluton', '06 65 87 09 23', '1993-02-28', '2 93 02 45 67 89 02', '2022-10-15', 'lcaron', 'password1234');


--
-- Name: employe_matricule_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.employe_matricule_seq', 10, true);


--
-- Data for Name: est_specialiste; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.est_specialiste VALUES (1, 1);
INSERT INTO public.est_specialiste VALUES (2, 2);
INSERT INTO public.est_specialiste VALUES (4, 3);
INSERT INTO public.est_specialiste VALUES (6, 4);


--
-- Data for Name: inscription; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.inscription VALUES (1, 1, '2023-01-15');
INSERT INTO public.inscription VALUES (2, 2, '2023-02-20');
INSERT INTO public.inscription VALUES (3, 3, '2023-03-10');
INSERT INTO public.inscription VALUES (4, 4, '2023-04-05');
INSERT INTO public.inscription VALUES (3, 5, '2023-05-12');
INSERT INTO public.inscription VALUES (2, 6, '2023-06-08');
INSERT INTO public.inscription VALUES (1, 7, '2023-07-03');
INSERT INTO public.inscription VALUES (1, 8, '2023-08-18');
INSERT INTO public.inscription VALUES (4, 9, '2023-09-22');
INSERT INTO public.inscription VALUES (3, 10, '2023-10-15');


--
-- Data for Name: lieu_operation; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.lieu_operation VALUES (1, 1);
INSERT INTO public.lieu_operation VALUES (2, 2);
INSERT INTO public.lieu_operation VALUES (3, 3);
INSERT INTO public.lieu_operation VALUES (4, 4);
INSERT INTO public.lieu_operation VALUES (2, 5);
INSERT INTO public.lieu_operation VALUES (3, 6);
INSERT INTO public.lieu_operation VALUES (4, 7);
INSERT INTO public.lieu_operation VALUES (1, 8);
INSERT INTO public.lieu_operation VALUES (3, 9);
INSERT INTO public.lieu_operation VALUES (2, 10);


--
-- Data for Name: medicament; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.medicament VALUES (1, 'Paracetamol');
INSERT INTO public.medicament VALUES (2, 'Amoxicilline');
INSERT INTO public.medicament VALUES (3, 'Ibuprofene');
INSERT INTO public.medicament VALUES (4, 'Aspirine');
INSERT INTO public.medicament VALUES (5, 'Omeprazole');
INSERT INTO public.medicament VALUES (6, 'Loratadine');
INSERT INTO public.medicament VALUES (7, 'Morphine');
INSERT INTO public.medicament VALUES (8, 'Ciprofloxacine');
INSERT INTO public.medicament VALUES (9, 'Atorvastatine');
INSERT INTO public.medicament VALUES (10, 'Sertraline');


--
-- Name: medicament_id_medicament_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.medicament_id_medicament_seq', 10, true);


--
-- Data for Name: nature; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.nature VALUES (1, 'Chirurgie');
INSERT INTO public.nature VALUES (2, 'Radiologie');
INSERT INTO public.nature VALUES (3, 'Vaccination');
INSERT INTO public.nature VALUES (4, 'Consultation');
INSERT INTO public.nature VALUES (5, 'Analyses sanguines');
INSERT INTO public.nature VALUES (6, 'Soins dentaires');
INSERT INTO public.nature VALUES (7, 'Kinesitherapie');
INSERT INTO public.nature VALUES (8, 'Imagerie medicale');
INSERT INTO public.nature VALUES (9, 'Urgence');
INSERT INTO public.nature VALUES (10, 'Physiotherapie');


--
-- Name: nature_id_nature_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.nature_id_nature_seq', 10, true);


--
-- Data for Name: operation; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.operation VALUES (1, '2023-01-15', 1);
INSERT INTO public.operation VALUES (2, '2023-02-20', 2);
INSERT INTO public.operation VALUES (3, '2023-03-10', 3);
INSERT INTO public.operation VALUES (4, '2023-04-05', 4);
INSERT INTO public.operation VALUES (5, '2023-05-12', 5);
INSERT INTO public.operation VALUES (6, '2023-06-08', 6);
INSERT INTO public.operation VALUES (7, '2023-07-03', 7);
INSERT INTO public.operation VALUES (8, '2023-08-18', 8);
INSERT INTO public.operation VALUES (9, '2023-09-22', 9);
INSERT INTO public.operation VALUES (10, '2023-10-15', 10);
INSERT INTO public.operation VALUES (11, '2023-12-12', 5);
INSERT INTO public.operation VALUES (12, '2023-12-13', 3);
INSERT INTO public.operation VALUES (13, '2023-12-19', 4);
INSERT INTO public.operation VALUES (14, '2024-01-31', 8);
INSERT INTO public.operation VALUES (15, '2023-02-01', 4);
INSERT INTO public.operation VALUES (16, '2024-09-04', 4);


--
-- Name: operation_id_operation_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.operation_id_operation_seq', 16, true);


--
-- Data for Name: ordonnance; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.ordonnance VALUES (1, '2023-01-15');
INSERT INTO public.ordonnance VALUES (2, '2023-02-20');
INSERT INTO public.ordonnance VALUES (3, '2023-03-10');
INSERT INTO public.ordonnance VALUES (4, '2023-04-05');
INSERT INTO public.ordonnance VALUES (5, '2023-05-12');
INSERT INTO public.ordonnance VALUES (6, '2023-06-08');
INSERT INTO public.ordonnance VALUES (7, '2023-07-03');
INSERT INTO public.ordonnance VALUES (8, '2023-08-18');
INSERT INTO public.ordonnance VALUES (9, '2023-09-22');
INSERT INTO public.ordonnance VALUES (10, '2023-10-15');


--
-- Name: ordonnance_id_ordonnance_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.ordonnance_id_ordonnance_seq', 10, true);


--
-- Data for Name: prescrit; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.prescrit VALUES (1, 1);
INSERT INTO public.prescrit VALUES (2, 2);
INSERT INTO public.prescrit VALUES (3, 3);
INSERT INTO public.prescrit VALUES (4, 4);
INSERT INTO public.prescrit VALUES (5, 5);
INSERT INTO public.prescrit VALUES (6, 6);
INSERT INTO public.prescrit VALUES (7, 7);
INSERT INTO public.prescrit VALUES (8, 8);
INSERT INTO public.prescrit VALUES (9, 9);
INSERT INTO public.prescrit VALUES (10, 10);


--
-- Data for Name: proprietaire; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.proprietaire VALUES (1, 'Remplacant', 'Faker', '86 Rue du Nid', '06 23 45 67 90', 'sophie.leblanc@email.com', '78945');
INSERT INTO public.proprietaire VALUES (2, 'Ama', 'Castor', '32 Avenue du Lardon', '07 76 54 32 15', 'luc.giroux@email.com', '71105');
INSERT INTO public.proprietaire VALUES (3, 'Kuroko', 'Kagami', '23 Rue des Champs', '07 45 67 88 13', 'catherine.tremblay@email.com', '71586');
INSERT INTO public.proprietaire VALUES (4, 'David', 'Lucy', '4 Avenue des Roses', '06 43 65 87 92', 'philippe.deschamps@email.com', '15914');
INSERT INTO public.proprietaire VALUES (5, 'Kousei', 'Kaori', '97 Rue de la Lune', '07 65 87 09 26', 'claudia.lavoie@email.com', '71006');
INSERT INTO public.proprietaire VALUES (6, 'Zuka', 'Oni', '80 Avenue de Mars', '06 87 09 21 49', 'francois.bernier@email.com', '64560');
INSERT INTO public.proprietaire VALUES (7, 'Lynx', 'Ash', '62 Rue de Jupiter', '07 09 21 43 88', 'julie.bergeron@email.com', '5961');
INSERT INTO public.proprietaire VALUES (8, 'Ackerman', 'Levi', '25 Avenue de Saturne', '06 21 43 65 10', 'stephane.lapointe@email.com', '95185');
INSERT INTO public.proprietaire VALUES (9, 'Ackerman', 'Mikasa', '8 Rue de Neptune', '07 43 65 87 50', 'nathalie.fortin@email.com', '95486');
INSERT INTO public.proprietaire VALUES (10, 'Roger', 'Gold', '1 Avenue de Pluton', '06 65 87 09 25', 'patrick.boucher@email.com', '31560');


--
-- Name: proprietaire_id_proprio_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.proprietaire_id_proprio_seq', 10, true);


--
-- Data for Name: recoit_operation; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.recoit_operation VALUES (1, 1);
INSERT INTO public.recoit_operation VALUES (2, 2);
INSERT INTO public.recoit_operation VALUES (3, 3);
INSERT INTO public.recoit_operation VALUES (4, 4);
INSERT INTO public.recoit_operation VALUES (5, 6);
INSERT INTO public.recoit_operation VALUES (6, 6);
INSERT INTO public.recoit_operation VALUES (7, 5);
INSERT INTO public.recoit_operation VALUES (8, 8);
INSERT INTO public.recoit_operation VALUES (9, 9);
INSERT INTO public.recoit_operation VALUES (10, 8);
INSERT INTO public.recoit_operation VALUES (11, 1);
INSERT INTO public.recoit_operation VALUES (12, 4);
INSERT INTO public.recoit_operation VALUES (13, 6);
INSERT INTO public.recoit_operation VALUES (14, 2);
INSERT INTO public.recoit_operation VALUES (15, 1);
INSERT INTO public.recoit_operation VALUES (16, 1);


--
-- Data for Name: recoit_ordonnance; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.recoit_ordonnance VALUES (1, 1);
INSERT INTO public.recoit_ordonnance VALUES (2, 2);
INSERT INTO public.recoit_ordonnance VALUES (3, 3);
INSERT INTO public.recoit_ordonnance VALUES (4, 4);
INSERT INTO public.recoit_ordonnance VALUES (5, 1);
INSERT INTO public.recoit_ordonnance VALUES (6, 6);
INSERT INTO public.recoit_ordonnance VALUES (7, 5);
INSERT INTO public.recoit_ordonnance VALUES (8, 2);
INSERT INTO public.recoit_ordonnance VALUES (9, 8);
INSERT INTO public.recoit_ordonnance VALUES (10, 9);


--
-- Data for Name: specialiste; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.specialiste VALUES (1, 'Daddy', 'Anna');
INSERT INTO public.specialiste VALUES (2, 'Artefact', 'Troupedore');
INSERT INTO public.specialiste VALUES (3, 'Furina', 'Cessix');
INSERT INTO public.specialiste VALUES (4, 'Coupe', 'Tece');


--
-- Name: specialiste_id_spe_seq; Type: SEQUENCE SET; Schema: public; Owner: mehdi.maouche
--

SELECT pg_catalog.setval('public.specialiste_id_spe_seq', 4, true);


--
-- Data for Name: travaille; Type: TABLE DATA; Schema: public; Owner: mehdi.maouche
--

INSERT INTO public.travaille VALUES (9, 3);
INSERT INTO public.travaille VALUES (7, 4);
INSERT INTO public.travaille VALUES (4, 2);
INSERT INTO public.travaille VALUES (1, 2);
INSERT INTO public.travaille VALUES (6, 1);
INSERT INTO public.travaille VALUES (2, 1);
INSERT INTO public.travaille VALUES (10, 3);
INSERT INTO public.travaille VALUES (8, 2);
INSERT INTO public.travaille VALUES (3, 3);
INSERT INTO public.travaille VALUES (5, 4);
INSERT INTO public.travaille VALUES (9, 4);
INSERT INTO public.travaille VALUES (2, 4);
INSERT INTO public.travaille VALUES (7, 2);
INSERT INTO public.travaille VALUES (10, 1);
INSERT INTO public.travaille VALUES (1, 3);
INSERT INTO public.travaille VALUES (5, 2);
INSERT INTO public.travaille VALUES (8, 3);
INSERT INTO public.travaille VALUES (4, 3);
INSERT INTO public.travaille VALUES (6, 4);
INSERT INTO public.travaille VALUES (3, 1);
INSERT INTO public.travaille VALUES (4, 1);


--
-- Name: animal animal_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_pkey PRIMARY KEY (id_animal);


--
-- Name: applique applique_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.applique
    ADD CONSTRAINT applique_pkey PRIMARY KEY (id_medicament, id_animal);


--
-- Name: centre centre_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.centre
    ADD CONSTRAINT centre_pkey PRIMARY KEY (id_unique);


--
-- Name: employe employe_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.employe
    ADD CONSTRAINT employe_pkey PRIMARY KEY (matricule);


--
-- Name: medicament medicament_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.medicament
    ADD CONSTRAINT medicament_pkey PRIMARY KEY (id_medicament);


--
-- Name: nature nature_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.nature
    ADD CONSTRAINT nature_pkey PRIMARY KEY (id_nature);


--
-- Name: operation operation_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.operation
    ADD CONSTRAINT operation_pkey PRIMARY KEY (id_operation);


--
-- Name: ordonnance ordonnance_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.ordonnance
    ADD CONSTRAINT ordonnance_pkey PRIMARY KEY (id_ordonnance);


--
-- Name: prescrit prescrit_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.prescrit
    ADD CONSTRAINT prescrit_pkey PRIMARY KEY (id_ordonnance, id_medicament);


--
-- Name: proprietaire proprietaire_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.proprietaire
    ADD CONSTRAINT proprietaire_pkey PRIMARY KEY (id_proprio);


--
-- Name: recoit_operation recoit_operation_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.recoit_operation
    ADD CONSTRAINT recoit_operation_pkey PRIMARY KEY (id_operation, id_animal);


--
-- Name: recoit_ordonnance recoit_ordonnance_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.recoit_ordonnance
    ADD CONSTRAINT recoit_ordonnance_pkey PRIMARY KEY (id_ordonnance, id_proprio);


--
-- Name: specialiste specialiste_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.specialiste
    ADD CONSTRAINT specialiste_pkey PRIMARY KEY (id_spe);


--
-- Name: travaille travaille_pkey; Type: CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.travaille
    ADD CONSTRAINT travaille_pkey PRIMARY KEY (matricule, id_unique);


--
-- Name: animal animal_id_proprio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_id_proprio_fkey FOREIGN KEY (id_proprio) REFERENCES public.proprietaire(id_proprio);


--
-- Name: applique applique_id_animal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.applique
    ADD CONSTRAINT applique_id_animal_fkey FOREIGN KEY (id_animal) REFERENCES public.animal(id_animal);


--
-- Name: applique applique_id_medicament_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.applique
    ADD CONSTRAINT applique_id_medicament_fkey FOREIGN KEY (id_medicament) REFERENCES public.medicament(id_medicament);


--
-- Name: centre centre_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.centre
    ADD CONSTRAINT centre_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule);


--
-- Name: donne_operation donne_operation_id_operation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.donne_operation
    ADD CONSTRAINT donne_operation_id_operation_fkey FOREIGN KEY (id_operation) REFERENCES public.operation(id_operation);


--
-- Name: donne_operation donne_operation_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.donne_operation
    ADD CONSTRAINT donne_operation_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule);


--
-- Name: donne_ordonnance donne_ordonnance_id_ordonnance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.donne_ordonnance
    ADD CONSTRAINT donne_ordonnance_id_ordonnance_fkey FOREIGN KEY (id_ordonnance) REFERENCES public.ordonnance(id_ordonnance);


--
-- Name: donne_ordonnance donne_ordonnance_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.donne_ordonnance
    ADD CONSTRAINT donne_ordonnance_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule);


--
-- Name: est_specialiste est_specialiste_id_spe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.est_specialiste
    ADD CONSTRAINT est_specialiste_id_spe_fkey FOREIGN KEY (id_spe) REFERENCES public.specialiste(id_spe);


--
-- Name: est_specialiste est_specialiste_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.est_specialiste
    ADD CONSTRAINT est_specialiste_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule);


--
-- Name: inscription inscription_id_animal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.inscription
    ADD CONSTRAINT inscription_id_animal_fkey FOREIGN KEY (id_animal) REFERENCES public.animal(id_animal);


--
-- Name: inscription inscription_id_unique_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.inscription
    ADD CONSTRAINT inscription_id_unique_fkey FOREIGN KEY (id_unique) REFERENCES public.centre(id_unique);


--
-- Name: lieu_operation lieu_operation_id_operation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.lieu_operation
    ADD CONSTRAINT lieu_operation_id_operation_fkey FOREIGN KEY (id_operation) REFERENCES public.operation(id_operation);


--
-- Name: lieu_operation lieu_operation_id_unique_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.lieu_operation
    ADD CONSTRAINT lieu_operation_id_unique_fkey FOREIGN KEY (id_unique) REFERENCES public.centre(id_unique);


--
-- Name: prescrit prescrit_id_medicament_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.prescrit
    ADD CONSTRAINT prescrit_id_medicament_fkey FOREIGN KEY (id_medicament) REFERENCES public.medicament(id_medicament);


--
-- Name: prescrit prescrit_id_ordonnance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.prescrit
    ADD CONSTRAINT prescrit_id_ordonnance_fkey FOREIGN KEY (id_ordonnance) REFERENCES public.ordonnance(id_ordonnance);


--
-- Name: recoit_operation recoit_operation_id_animal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.recoit_operation
    ADD CONSTRAINT recoit_operation_id_animal_fkey FOREIGN KEY (id_animal) REFERENCES public.animal(id_animal);


--
-- Name: recoit_operation recoit_operation_id_operation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.recoit_operation
    ADD CONSTRAINT recoit_operation_id_operation_fkey FOREIGN KEY (id_operation) REFERENCES public.operation(id_operation);


--
-- Name: recoit_ordonnance recoit_ordonnance_id_ordonnance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.recoit_ordonnance
    ADD CONSTRAINT recoit_ordonnance_id_ordonnance_fkey FOREIGN KEY (id_ordonnance) REFERENCES public.ordonnance(id_ordonnance);


--
-- Name: recoit_ordonnance recoit_ordonnance_id_proprio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.recoit_ordonnance
    ADD CONSTRAINT recoit_ordonnance_id_proprio_fkey FOREIGN KEY (id_proprio) REFERENCES public.proprietaire(id_proprio);


--
-- Name: travaille travaille_id_unique_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.travaille
    ADD CONSTRAINT travaille_id_unique_fkey FOREIGN KEY (id_unique) REFERENCES public.centre(id_unique);


--
-- Name: travaille travaille_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mehdi.maouche
--

ALTER TABLE ONLY public.travaille
    ADD CONSTRAINT travaille_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

