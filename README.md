# EJE_Mission
######################################################################################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################
i) INFORMAZIONI
Progetto del Corso di Robotica Aerospaziale, Laurea Magistrale in Ingegneria Robotica e dell'Automazione.
Il progetto consiste nello sviluppo di una missione interplanetaria, in particolare dalla Terra alla luna di Giove Europa, passando obbligatoriamente da Giove stesso. 
Verrà utilizzato principalmente il metodo delle Patched Conics.


######################################################################################################################################################################
######################################################################################################################################################################
######################################################################################################################################################################
ii) ISTRUZIONI
Per eseguire e modificare il codice :

SE E' LA PRIMA VOLTA CHE TI CONNETTI AL QUESTO SERVER REMOTO

	1. scegliere la directory in cui clonare la repository 'EJE_Mission' (es. Desktop)
	2. da terminale digitare
		git clone https://github.com/EJE-mission/EJE_Mission
	Vi apparirà una cartella dal nome EJE_Mission nella directory scelta
	3. Lavorate pure in locale sui vari file, create nuovi file ecc..
	5. dopo aver fatto le vostre modifiche, se volete mandarle in remoto, da terminale digitate
		git add <nomefilemodificato> (inclusa l'estensione)
		git commit -m 'commentosullevostremodifiche'
		git push origin main
	A questo punto vi chiederà username e password di GitHub
	
PER LE VOLTE SUCCESSIVE IN CUI VUOI RICONNETTERTI A QUESTO SERVER REMOTO

 	1. Da terminale spostatevi all'interno della directory clonata e digitare
		git pull 
	(integrerà i cambiamenti del repository remoto 'Pianificazione-Controllo' all'interno del branch su cui lavori. Questo perchè quando 		riprenderai il tuo lavoro, probabilmente qualcuno del tuo gruppo avrà fatto altre modifiche)- comando per aggiornare e quindi 			sovrascrivere la tua copia locale del repository
	(1. se non vuoi sovrascrivere la tua copia locale,sempre all'interno della cartella clonata, usa 
		git fetch
	ma comunque per i nostri scopi penso sia più utile git pull
	2. fare git add, git commit ecc. come sopra

	COMANDI UTILI :
		git status
	da usare per vedere cosa è stato 'add', cosa è stato 'committed' ecc
	quelli aggiunti ma non ancora committed, saranno registrati in verde. Quelli in rosso sono stati modificati o aggiornati, ma non sono 		stati aggiunti.
	(comando che uso prima e dopo il git add, e dopo il git committed per verifica)

		git add *
	per aggiungere tutti i file in rosso 
