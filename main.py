from passlib.context import CryptContext
from datetime import datetime, timedelta
from flask import Flask, render_template, request, redirect, url_for, session
import psycopg2
import os
import db
app=Flask(__name__)
password_ctx = CryptContext(schemes=['bcrypt'])
app.secret_key=os.urandom(12)

#mot de passe employe
hash_employe=[password_ctx.hash("password123")]
hash_employe.append(password_ctx.hash("secret456"))
hash_employe.append(password_ctx.hash("secure789"))
hash_employe.append(password_ctx.hash("pass123word"))
hash_employe.append(password_ctx.hash("letmein456"))
hash_employe.append(password_ctx.hash("password789"))
hash_employe.append(password_ctx.hash("securepass"))
hash_employe.append(password_ctx.hash("pass1234"))
hash_employe.append(password_ctx.hash("securepass123"))
hash_employe.append(password_ctx.hash("password1234"))

i=1
for password in hash_employe:
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE employe SET mdp=%s WHERE matricule=%s",(password,i))
    i+=1

#mot de passe proprietaire
hash_proprietaire=[password_ctx.hash("78945")]
hash_proprietaire.append(password_ctx.hash("71105"))
hash_proprietaire.append(password_ctx.hash("71586"))
hash_proprietaire.append(password_ctx.hash("15914"))
hash_proprietaire.append(password_ctx.hash("71006"))
hash_proprietaire.append(password_ctx.hash("64560"))
hash_proprietaire.append(password_ctx.hash("05961"))
hash_proprietaire.append(password_ctx.hash("95185"))
hash_proprietaire.append(password_ctx.hash("95486"))
hash_proprietaire.append(password_ctx.hash("31560"))

j=1
for wordpass in hash_proprietaire:
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE proprietaire SET num_suivi=%s WHERE id_proprio=%s",(wordpass,j))
    j+=1

@app.route('/')
@app.route('/accueil')
def accueil():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute('SELECT nom,adresse FROM centre')
            centers = cur.fetchall()
    return render_template('accueil.html',centers=centers)

@app.route('/centre',methods=["GET", "POST"])
def centre():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom, adresse, num_tel FROM centre")
            centrelst =cur.fetchall()
    return render_template("centre.html",centrelst=centrelst)

@app.route('/connexion_proprietaire',methods=["GET", "POST"])
def connexion_proprietaire():
    if request.method=='POST':
        nom= request.form['ownerName']
        num_suivi= request.form['trackingNumber']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT num_suivi, nom, prenom, id_proprio FROM proprietaire WHERE nom=%s",(nom,))
                user=cur.fetchone()
        if user and password_ctx.verify(num_suivi,user[0]):
            session["user"]={
                "nom":user[1],
                "prenom":user[2],
                "id_proprio":user[3]
            }
            return redirect(url_for('soin_ordonnance_proprietaire'))
    else:
        return render_template("connexion_proprietaire.html")
    return render_template("connexion_proprietaire.html")

#dès qu'on se connecte on accede à cette fonction et uniquement à celle ci
@app.route('/soin_ordonnance_proprietaire',methods=["GET", "POST"])
def soin_ordonnance_proprietaire():
    #faire une boucle en fonction de quel proprietaire se connecte pour accéder à son ou ses animaux.
    with db.connect() as conn:
        with conn.cursor() as cur:
            print(session["user"]["id_proprio"])
            cur.execute("SELECT DISTINCT espece,nom,sexe, date_operation, nature FROM recoit_operation NATURAL JOIN operation NATURAL JOIN nature NATURAL JOIN animal WHERE id_proprio=%s",(session["user"]["id_proprio"],))
            soin =cur.fetchall()
            cur.execute("SELECT espece, nom, sexe, medicament, date_ordonnance FROM animal NATURAL JOIN applique NATURAL JOIN medicament NATURAL JOIN prescrit NATURAL JOIN ordonnance WHERE id_proprio=%s",(session["user"]["id_proprio"],))
            ordonnance=cur.fetchall()
    return render_template("soin_ordonnance_proprietaire.html",soin=soin,ordonnance=ordonnance)

@app.route('/connexion_employe',methods=["GET", "POST"])
def connexion_employe():
    if request.method=='POST':
        login= request.form['username']
        mdp= request.form['password']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT login, mdp, nom, prenom, matricule FROM employe WHERE login=%s",(login,))
                user=cur.fetchone()
        if user and password_ctx.verify(mdp,user[1]):
            session["user"]={
                "login":user[0],
                "nom":user[2],
                "prenom":user[3],
                "matricule":user[4]
            }
            return redirect(url_for('accueil_employe'))
    else:
        return render_template("connexion_employe.html")
    return render_template("connexion_employe.html")

@app.route('/accueil_employe',methods=["GET", "POST"])
def accueil_employe():
    return render_template('accueil_employe.html')

@app.route('/statistique',methods=["GET", "POST"])
#Ajout de la vue, tester si le tableau est bien affiché, si autre problème lié au code, envoyer un message pour de l'aide
def statistique():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT espece, avg, nature, count FROM statistique")
            statistique =cur.fetchall()

    print(statistique)
    return render_template('statistique.html',statistique=statistique)

@app.route('/ajout_choix',methods=["GET", "POST"])
def ajout_choix():
    return render_template('ajout_choix.html')

@app.route('/centre_choix',methods=["GET", "POST"])
def centre_choix():
    return render_template('centre_choix.html')

@app.route('/centreA',methods=["GET", "POST"])
def centreA():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom, prenom  FROM  employe NATURAL JOIN travaille WHERE id_unique=1 ")
            employe =cur.fetchall()
            cur.execute("SELECT matricule, nom, prenom, id_unique FROM employe NATURAL JOIN (SELECT matricule, id_unique FROM centre NATURAL JOIN travaille) AS sous_requete_directeur WHERE id_unique = 1")            
            directeur =cur.fetchall()
            cur.execute("SELECT espece,nom,age,sexe,signe_distinct,date_inscription FROM  animal NATURAL JOIN inscription WHERE id_unique=1")
            animal =cur.fetchall()
    return render_template("employe_directeur_animal.html",employe=employe,animal=animal,directeur=directeur)

@app.route('/centreB',methods=["GET", "POST"])
def centreB():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom, prenom  FROM  employe NATURAL JOIN travaille WHERE id_unique=2 ")
            employe =cur.fetchall()
            cur.execute("SELECT matricule, nom, prenom, id_unique FROM employe NATURAL JOIN (SELECT matricule, id_unique FROM centre NATURAL JOIN travaille) AS sous_requete_directeur WHERE id_unique = 2")            
            directeur =cur.fetchall()
            cur.execute("SELECT espece,nom,age,sexe,signe_distinct,date_inscription FROM  animal NATURAL JOIN inscription WHERE id_unique=2")
            animal =cur.fetchall()
    return render_template("employe_directeur_animal.html",employe=employe,animal=animal,directeur=directeur)

@app.route('/centreC',methods=["GET", "POST"])
def centreC():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom, prenom  FROM  employe NATURAL JOIN travaille WHERE id_unique=3 ")
            employe =cur.fetchall()
            cur.execute("SELECT matricule, nom, prenom, id_unique FROM employe NATURAL JOIN (SELECT matricule, id_unique FROM centre NATURAL JOIN travaille) AS sous_requete_directeur WHERE id_unique = 3")            
            directeur =cur.fetchall()
            cur.execute("SELECT espece,nom,age,sexe,signe_distinct,date_inscription FROM  animal NATURAL JOIN inscription WHERE id_unique=3")
            animal =cur.fetchall()
    return render_template("employe_directeur_animal.html",employe=employe,animal=animal,directeur=directeur)

@app.route('/centreD',methods=["GET", "POST"])
def centreD():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom, prenom  FROM  employe NATURAL JOIN travaille WHERE id_unique=4 ")
            employe =cur.fetchall()
            cur.execute("SELECT matricule, nom, prenom, id_unique FROM employe NATURAL JOIN (SELECT matricule, id_unique FROM centre NATURAL JOIN travaille) AS sous_requete_directeur WHERE id_unique = 4")            
            directeur =cur.fetchall()
            cur.execute("SELECT espece,nom,age,sexe,signe_distinct,date_inscription, id_animal FROM  animal NATURAL JOIN inscription WHERE id_unique=4")
            animal =cur.fetchall()
    return render_template("employe_directeur_animal.html",employe=employe,animal=animal,directeur=directeur)

#si on clique sur un animal de la page employe_directeur_animal, on arrive sur soin_ordonnance_employe avec l'historique et les soins de l'animal en question
@app.route('/soin_ordonnance_employe',methods=["GET", "POST"])
def soin_ordonnance_employe():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT espece,nom,sexe, date_operation, nature FROM recoit_operation NATURAL JOIN operation NATURAL JOIN nature NATURAL JOIN animal")
            soin =cur.fetchall()
            cur.execute("SELECT espece, nom, sexe, medicament, date_ordonnance FROM animal NATURAL JOIN applique NATURAL JOIN medicament NATURAL JOIN prescrit NATURAL JOIN ordonnance")
            ordonnance=cur.fetchall()
    return render_template("soin_ordonnance_employe.html",soin=soin,ordonnance=ordonnance)


@app.route('/accueil_proprietaire',methods=["GET", "POST"])
def accueil_proprietaire():
    return render_template('accueil_proprietaire.html')


@app.route('/action_employe',methods=["GET", "POST"])
def action_employe():
    return render_template('action_employe.html')

@app.route('/ajouter_animal',methods=["GET", "POST"])
def ajouter_animal():
    if request.method == 'POST':
        espece = request.form['espece']
        nom = request.form['nom']
        age = request.form['age']
        sexe = request.form['sexe']
        signe_distinct = request.form['signe_distinct']
        id_proprietaire = request.form['id_proprietaire']
        if not espece or not nom or not age or not sexe or not id_proprietaire:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO animal (espece, nom, age, sexe, signe_distinct,id_proprio) VALUES (%s, %s, %s, %s, %s, %s)", (espece, nom, age, sexe, signe_distinct,id_proprietaire))
            conn.commit()
            return f"Les informations {espece} {nom} {age} {sexe} {signe_distinct} {id_proprietaire} du nouvel animal ont bien été insérés."
    return render_template('ajouter_animal.html')

@app.route('/supprimer_animal', methods=["GET", "POST"])
def supprimer_animal():
    if request.method == 'POST':
        id_animal = request.form['id_animal']
        if not id_animal:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM animal WHERE id_animal = %s", (id_animal,))
                animal = cur.fetchone()
                if not animal:
                    return "L'animal spécifié n'existe pas."
                cur.execute("SELECT * FROM recoit_operation WHERE id_animal = %s", (id_animal,))
                recoit_operation_records = cur.fetchall()
                for recoit_operation in recoit_operation_records:
                    cur.execute("DELETE FROM recoit_operation WHERE id_operation = %s", (recoit_operation[0],))

                cur.execute("SELECT * FROM inscription WHERE id_animal = %s", (id_animal,))
                inscription_records = cur.fetchall()
                for inscription in inscription_records:
                    cur.execute("DELETE FROM inscription WHERE id_unique = %s", (inscription[0],))

                cur.execute("DELETE FROM animal WHERE id_animal = %s", (id_animal,))
                conn.commit()

                return f"L'animal avec l'identifiant {id_animal} a été supprimé."
    return render_template('supprimer_animal.html')



@app.route('/ajouter_proprietaire',methods=["GET", "POST"])
def ajouter_proprietaire():
    if request.method == 'POST':
        nom = request.form['nom']
        prenom = request.form['prenom']
        adresse = request.form['adresse']
        num_tel = request.form['num_tel']
        email = request.form['email']
        num_suivi = request.form['num_suivi']
        if not nom or not prenom or not adresse or not num_tel or not email or not num_suivi:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO proprietaire (nom, prenom, adresse, num_tel, email,num_suivi) VALUES (%s, %s, %s, %s, %s, %s)", (nom, prenom, adresse, num_tel, email,num_suivi))
            conn.commit()
            return f"Les informations {nom} {prenom} {adresse} {num_tel} {email} {num_suivi} du nouveau proprietaire ont bien été insérés."
    return render_template('ajouter_proprietaire.html')


@app.route('/supprimer_proprietaire', methods=["GET", "POST"])
def supprimer_proprietaire():
    if request.method == 'POST':
        id_proprio = request.form['id_proprio']
        if not id_proprio:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM proprietaire WHERE id_proprio = %s", (id_proprio,))
                proprietaire = cur.fetchone()
                if not proprietaire:
                    return "Le propriétaire spécifié n'existe pas."

                cur.execute("SELECT id_animal FROM animal WHERE id_proprio = %s", (id_proprio,))
                animals_to_delete = cur.fetchall()
                for animal_id in animals_to_delete:
                    cur.execute("DELETE FROM inscription WHERE id_animal = %s", (animal_id[0],))
                    cur.execute("DELETE FROM recoit_operation WHERE id_animal = %s", (animal_id[0],))
                    cur.execute("DELETE FROM applique WHERE id_animal = %s", (animal_id[0],))

                cur.execute("DELETE FROM recoit_ordonnance WHERE id_proprio = %s", (id_proprio,))
                cur.execute("DELETE FROM animal WHERE id_proprio = %s", (id_proprio,))
                cur.execute("DELETE FROM proprietaire WHERE id_proprio = %s", (id_proprio,))
                conn.commit()
                
                return f"Le propriétaire avec l'identifiant {id_proprio} a été supprimé."
    return render_template('supprimer_proprietaire.html')



@app.route('/ajouter_ordonnance', methods=["GET", "POST"])
def ajouter_ordonnance():
    if request.method == 'POST':
        medicament_nom = request.form['medicament']
        date = request.form['date']
        id_proprietaire = request.form['id_proprietaire']
        id_animal = request.form['id_animal']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO ordonnance (date_ordonnance) VALUES (%s) RETURNING id_ordonnance", (date,))
                id_ordonnance = cur.fetchone()[0]
                cur.execute("INSERT INTO recoit_ordonnance (id_ordonnance, id_proprio) VALUES (%s, %s)", (id_ordonnance, id_proprietaire))
                cur.execute("SELECT id_medicament, nom_medicament FROM medicament WHERE nom_medicament = %s", (medicament_nom,))
                medicament_result = cur.fetchone()
                if medicament_result:
                    id_medicament = medicament_result[0]
                else:
                    cur.execute("INSERT INTO medicament (nom_medicament) VALUES (%s) RETURNING id_medicament, nom_medicament", (medicament_nom,))
                    medicament_result = cur.fetchone()
                    id_medicament = medicament_result[0]

                cur.execute("INSERT INTO prescrit (id_ordonnance, id_medicament) VALUES (%s, %s)", (id_ordonnance, id_medicament))
                cur.execute("INSERT INTO applique (id_animal, id_medicament) VALUES (%s, %s)", (id_animal, id_medicament))
        conn.commit()
        print("salut")
        print(medicament_result)
        return f"Les informations {medicament_result[1]}, {date}, {id_proprietaire} {id_animal} de la nouvelle ordonnance ont bien été insérées."
    return render_template('ajouter_ordonnance.html')



@app.route('/supprimer_ordonnance', methods=["GET", "POST"])
def supprimer_ordonnance():
    if request.method == 'POST':
        id_ordonnance = request.form['id_ordonnance']
        if not id_ordonnance:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM ordonnance WHERE id_ordonnance = %s", (id_ordonnance,))
                ordonnance = cur.fetchone()
                if not ordonnance:
                    return "L'ordonnance spécifiée n'existe pas."
                cur.execute("DELETE FROM donne_ordonnance WHERE id_ordonnance = %s", (id_ordonnance,))
                cur.execute("DELETE FROM prescrit WHERE id_ordonnance = %s", (id_ordonnance,))
                cur.execute("DELETE FROM recoit_ordonnance WHERE id_ordonnance = %s", (id_ordonnance,))
                cur.execute("DELETE FROM ordonnance WHERE id_ordonnance = %s", (id_ordonnance,))
            conn.commit()
            return f"L'ordonnance avec l'identifiant {id_ordonnance} a été supprimée."
    return render_template('supprimer_ordonnance.html')


@app.route('/ajouter_soin',methods=["GET", "POST"])
def ajouter_soin():
    if request.method == 'POST':
        nature = request.form['nature']
        date = request.form['date']
        id_animal = request.form['id_animal']
        if not nature or not date  or not id_animal:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id_nature FROM nature WHERE nature = %s", (nature,))
                existing_nature = cur.fetchone()
                if existing_nature:
                    id_nature = existing_nature[0]
                else:
                    cur.execute("INSERT INTO nature (nature) VALUES (%s) RETURNING id_nature", (nature,))
                    id_nature = cur.fetchone()[0]
                cur.execute("INSERT INTO operation (date_operation,id_nature) VALUES (%s,%s) RETURNING id_operation", (date,id_nature))
                id_operation = cur.fetchone()[0]
                cur.execute("INSERT INTO recoit_operation (id_operation, id_animal) VALUES (%s, %s)",(id_operation, id_animal))
            conn.commit()
            return f"Les informations {nature} {date} {id_animal} de la nouvelle operation ont bien été insérés."
    return render_template('ajouter_soin.html')

@app.route('/supprimer_soin', methods=["GET", "POST"])
def supprimer_soin():
    if request.method == 'POST':
        id_operation = request.form['id_operation']
        if not id_operation:
            return "Remplissez l'intégralité des champs suivants ^^"
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM operation WHERE id_operation = %s", (id_operation,))
                operation = cur.fetchone()
                if not operation:
                    return "L'opération spécifiée n'existe pas."

                cur.execute("DELETE FROM donne_operation WHERE id_operation = %s", (id_operation,))
                cur.execute("DELETE FROM lieu_operation WHERE id_operation = %s", (id_operation,))
                cur.execute("DELETE FROM recoit_operation WHERE id_operation = %s", (id_operation,))
                cur.execute("DELETE FROM operation WHERE id_operation = %s", (id_operation,))
                conn.commit()
                
                return f"L'opération avec l'identifiant {id_operation} a été supprimée."
    return render_template('supprimer_soin.html')



@app.route('/changer_proprietaire', methods=['GET', 'POST'])
def changer_proprietaire():
    if request.method == 'POST':
        id_animal = request.form['id_animal']
        id_proprio = request.form['id_proprio']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("UPDATE animal SET id_proprio=%s WHERE id_animal=%s",(id_proprio,id_animal))
                conn.commit()
                return f"Modification réussie pour l'animal avec l'ID {id_animal}. Nouveau propriétaire : {id_proprio}"
    return render_template('changer_proprietaire.html')

@app.route('/changer_centre_animal', methods=['GET', 'POST'])
def changer_centre_animal():
    if request.method == 'POST':
        id_animal = request.form['id_animal']
        id_unique = request.form['id_unique']
        date_inscription = request.form['date_inscription']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("UPDATE inscription SET id_unique=%s,date_inscription=%s WHERE id_animal=%s",(id_unique,date_inscription,id_animal))
                conn.commit()
                return f"Modification réussie pour l'animal avec l'identifiant {id_animal}. Nouveau Centre : {id_unique}. Fait le {date_inscription}."
    return render_template('changer_centre_animal.html')

@app.route('/modifier_proprietaire', methods=['GET', 'POST'])
def modifier_proprietaire():
    if request.method == 'POST':
        id_proprio = request.form['id_proprio']
        nom = request.form['nom']
        prenom = request.form['prenom']
        adresse = request.form['adresse']
        num_tel = request.form['num_tel']
        email = request.form['email']
        num_suivi = request.form['num_suivi']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("UPDATE proprietaire SET nom=%s,prenom=%s,adresse=%s,num_tel=%s,email=%s,num_suivi=%s WHERE id_proprio = %s",(nom,prenom,adresse,num_tel,email,num_suivi,id_proprio))
                conn.commit()
                return f"Modification réussie pour le proprietaire avec l'identifiant {id_proprio} avec {nom},{prenom},{adresse},{num_tel},{email},{num_suivi}."
    return render_template('modifier_proprietaire.html')


@app.route('/modifier_ordonnance', methods=['GET', 'POST'])
def modifier_ordonnance():
    if request.method == 'POST':
        id_ordonnance = request.form['id_ordonnance']
        nom_medicament = request.form['nom_medicament']
        date_ordonnance = request.form['date_ordonnance']
        id_animal=request.form['id_animal']

        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("UPDATE ordonnance SET date_ordonnance=%s WHERE id_ordonnance=%s",(date_ordonnance,id_ordonnance))
                cur.execute("SELECT nom_medicament FROM medicament")
                medicament=cur.fetchall()
                if nom_medicament not in medicament:     
                    cur.execute("INSERT INTO medicament (nom_medicament) VALUES (%s) RETURNING id_medicament", (nom_medicament,))
                    id_medicament=cur.fetchone()
                else:
                    cur.execute("SELECT id_medicament WHERE nom_medicament=%s", (nom_medicament,))
                    id_medicament=cur.fetchone()
                cur.execute("UPDATE prescrit SET id_medicament=%s WHERE id_ordonnance=%s",(id_medicament,id_ordonnance))
                cur.execute("UPDATE applique SET id_medicament=%s WHERE id_animal=%s",(id_medicament,id_animal))
        return f"Modification réussie pour l'ordonnance avec l'identifiant {id_ordonnance}. Nouvelle date : {date_ordonnance}, Nouveau médicament : {nom_medicament}, Animal : {id_animal}"
    return render_template('modifier_ordonnance.html')
    

@app.route('/modifier_operation', methods=['GET', 'POST'])
def modifier_operation():
    if request.method == 'POST':
        id_operation = request.form['id_operation']
        date_operation = request.form['date_operation']
        nature = request.form['nature']
        id_animal = request.form['id_animal']
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT nature FROM nature")
                nature_temp=cur.fetchall()
                if nature not in nature_temp:     
                    cur.execute("INSERT INTO nature (nature) VALUES (%s) RETURNING id_nature", (nature,))
                    id_nature=cur.fetchone()
                else:
                    cur.execute("SELECT id_nature WHERE nature=%s", (nature,))
                    id_nature=cur.fetchone()
                cur.execute("UPDATE operation SET date_operation = %s, id_nature=%s WHERE id_operation = %s", (date_operation, id_nature,id_operation))
                cur.execute("UPDATE recoit_operation SET id_animal = %s WHERE id_operation = %s", (id_animal,id_operation))
        return f"Modification réussie pour l'opération avec l'identifiant {id_operation}. Nouvelle date : {date_operation}, Nouvelle nature : {nature}, Animal : {id_animal}"
    return render_template('modifier_operation.html')

@app.route('/logout')
def logout():
    session.pop('user',None)
    return redirect(url_for('accueil'))
    
if __name__=="__main__":
    app.run(debug=True)