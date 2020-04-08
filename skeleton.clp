;--------------------
; modulo main con la definizione di template regole e funzioni principali
;--------------------

(defmodule MAIN (export ?ALL))

;definizione di un generico attributo
(deftemplate MAIN::attribute
	(slot name)
	(slot value)
	(slot certainty (default 100) (range 0 100)))

(deftemplate MAIN::best-headphone
	(slot name(default ?NONE))
	(slot prezzo(default ?NONE))
	(slot certainty(default ?NONE)))

;definizione di una generica domanda
(deftemplate MAIN::question
	(slot id(type INTEGER))
	(slot attribute(default ?NONE))
	(slot the-question(type STRING)(default ?NONE))
	(multislot allowed-values)
	(slot already-asked(default FALSE))
	(multislot precursors (default ?DERIVE))
	(slot pronto (default FALSE))
	(slot info(type STRING))
	(slot why(type STRING))
	(slot priority (default LOW))
	(multislot ans-mean (default ?NONE)))

;template per tenere traccia delle domande a cui si è risposto
(deftemplate MAIN::answered-id-list
	(multislot id)
)

;template per tenere traccia, per ogni domanda fatta, di quale risposta è stata data dall'utente
(deftemplate MAIN::answer-list
	(slot id (default none))
	(slot question)
	(slot answer)
)

;template per asserire un fatto che ci dirà che dobbiamo procedere con le domande
(deftemplate MAIN::question-loop
	(slot loop (default TRUE))
)

;template per asserire  un fatto che ci dirà se dobbiamo stampare in fase di ritrattazione le domande a cui l'utente ha risposto
(deftemplate MAIN::retract-loop
	(slot print (default FALSE))
)

;template per asserire fatti che rappresentano una copia di backup delle domande e dei relativi precursori. Sarà usata principalmente in fase di ritrattazione
(deftemplate MAIN::question-precursors
	(slot question)
	(multislot precursors)
	(slot retract-it (default FALSE))
)

;template per asserire fatti che verranno utilizzati per popolare la base di conoscenza con le regole
(deftemplate MAIN::def-rule
	(multislot if)
	(multislot then)
)

;template che rappresenta una generica regola
(deftemplate MAIN::rule
  (slot certainty (default 100))
  (multislot if)
  (multislot then)
)

;template che rappresenta un generico paio di auricolari
(deftemplate MAIN::auricolari
	(slot name(default ?NONE))
	(slot brand(default ?NONE))
	(slot comandi(default no))
	(slot tipo(default ?NONE))
	(slot materiali(default ?NONE))
	(slot impermeabilita(default no))
	(slot buoni-bassi(default ?NONE))
	(slot alta-fedelta(default ?NONE))
	(slot prezzo(default ?NONE))
	(slot fascia-prezzo(default ?NONE))

)

;template che rappresenta un generico paio di auricolari wireless
(deftemplate MAIN::auricolari-w
	(slot name(default ?NONE))
	(slot brand(default ?NONE))
	(slot comandi(default no))
	(slot tipo(default ?NONE))
	(slot materiali(default ?NONE))
	(slot impermeabilita(default no))
	(slot buoni-bassi(default ?NONE))
	(slot alta-fedelta(default ?NONE))
	(slot prezzo(default ?NONE))
	(slot fascia-prezzo(default ?NONE))
	(slot archetto(default ?NONE))
	(slot cavo(default ?NONE))
	(slot cofanetto(default ?NONE)))

;template che rappresenta un generico paio di cuffie
(deftemplate MAIN::cuffie
	(slot name(default ?NONE))
	(slot brand(default ?NONE))
	(slot comandi(default no))
	(slot wired(default ?NONE))
	(slot materiali(default ?NONE))
	(slot tipo(default ?NONE))
	(slot apertura (default ?NONE))
	(slot scheda-audio(default no))
	(slot noise-cancelling(default ?NONE))
	(slot range-freq(default ?NONE))
	(slot impedenza (default ?NONE))
	(slot sensibilita(default media))
	(slot richiudibili(default no))
	(slot prezzo (default ?NONE))
	(slot fascia-prezzo-cuffie(default ?NONE)))


;funzione per stampare il why di una domanda
(deffunction MAIN::print-why(?question)
	(do-for-all-facts ((?q question))(eq ?question ?q:the-question)(printout t ?q:why crlf)))

;funzione per stampare le info di una domanda
(deffunction MAIN::print-info(?question)
	(do-for-all-facts ((?q question))(eq ?question ?q:the-question)(printout t ?q:info crlf)))

	
;funzione per chiedere all'utente di rispodere ad una domanda
;nel caso in cui si possa rispodnere con il ns (non so) si dà anche all'utente la possibilità di rispondere con un valore
;da 0 a 100 che rappresenta il grado di certezza della risposta 'si'
(deffunction MAIN::ask-question (?question ?allowed-values ?ans-mean)
	(printout t crlf crlf ?question "  " crlf)
	(loop-for-count (?i 1 (length$ ?ans-mean))
		  (format t "%-6s -> %s %n" (nth$ ?i ?allowed-values) (nth$ ?i ?ans-mean)))
	(format t "%-6s -> %s %n" "info" "per ottenere informazioni")
	(format t "%-6s -> %s %n" "why" "per capire la motivazione della domanda")
	(printout t "Risposta -> ")	
	(bind ?answer (read))
	(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	(if (eq ?answer why) then (print-why ?question))
	(if (eq ?answer info) then (print-info ?question))
	(while (and (not (member$ ?answer ?allowed-values))(not(integerp ?answer))) do
	(printout t crlf crlf ?question "  " crlf)
	(loop-for-count (?i 1 (length$ ?ans-mean))
		  (format t " %-6s -> %s %n" (nth$ ?i ?allowed-values) (nth$ ?i ?ans-mean)))
	(format t "%-6s -> %s %n" "info" "per ottenere informazioni")
	(format t "%-6s -> %s %n" "why" "per capire la motivazione della domanda")
	(printout t "Risposta -> ")	
		(bind ?answer (read))
		(if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
		(if (eq ?answer why) then (print-why ?question))
		(if (eq ?answer info) then (print-info ?question)))
	(if (eq ?answer s) then (bind ?answer si))
	(if (eq ?answer n) then (bind ?answer no))
	?answer)

;--------------------------------------------------------------|
;modulo per le domande con relativi template, funzioni e regole|
;--------------------------------------------------------------|

(defmodule QUESTIONS (import MAIN ?ALL)(export ?ALL))

;re-inizializza l'attributo loop a true per riprendere a fare domande dopo la ritrattazione
(defrule QUESTIONS::restart-question-loop
	?f <- (retract-loop (print TRUE))
	?x <- (question-loop (loop FALSE))
	=>
	(modify ?f (print FALSE))
	(modify ?x (loop TRUE))
)

;funzione che genere una copia di backup delle domande e dei relativi precursori per ripristinare le domande durante la ritrattazione
(defrule QUESTIONS::generate-question-precursors
	(declare (salience 10))
	(question (the-question ?question)(precursors $?precursors))
	(not (question-precursors (question ?question)))
	=>
	(assert (question-precursors (question ?question)(precursors ?precursors)))
)

;segna come pronta per essere posta una domanda che non ha più precursori (sono stati eliminati perchè soddisfatti da quanto presente in wm)
(defrule QUESTIONS::ready-to-ask-a-question
	(declare (salience 10))
	?q <- (question (already-asked FALSE)(precursors )(pronto FALSE)(the-question ?t))
	=>
	(modify ?q (pronto TRUE))
)

;stabilisce come comportarsi nel caso di attributo con valore ns
(defrule QUESTIONS::don-t-know-attribute
	(declare (salience 10))
	?a <- (attribute (name ?name) (value ns) (certainty ?c))
	=>
	(retract ?a)
	(assert (attribute (name ?name) (value si) (certainty (/ ?c 2))))
	(assert (attribute (name ?name) (value no) (certainty (- 100 (/ ?c 2)))))
	(focus RULES QUESTIONS RULES)
)

;regola che modifica la lista dei precursori quando uno di tipo 'is' è soddisfatto
(defrule QUESTIONS::precursor-is-satisfied
   ?q <- (question (already-asked FALSE) (precursors ?name is ?value $?rest)(the-question ?qst))
   (attribute (name ?name) (value ?value) (certainty ?certainty))
   =>
    (if (eq (nth 1 ?rest) and) 
		then (modify ?q (precursors (rest$ ?rest)))
		else (modify ?q (precursors ?rest)))
)

;regola che modifica la lista dei precursori quando uno di tipo 'is not' è soddisfatto
(defrule QUESTIONS::precursor-is-not-satisfied
   ?f <- (question (the-question ?qst)(already-asked FALSE)(precursors ?name is-not ?value $?rest))
   (attribute (name ?name) (value ~?value) (certainty ?certainty))
   =>
   (if (eq (nth 1 ?rest) and) 
		then (modify ?f (precursors (rest$ ?rest)))
		else (modify ?f (precursors ?rest))
	)
)


;;regola per porre le prime domande all'utente. Le prime domande hanno priorità HIGH
(defrule QUESTIONS::ask-starting-question
	(declare (salience -10))
	?ql <- (answered-id-list (id $?id-list))
	?f <- (question (id ?i)
					(already-asked FALSE)
					(pronto TRUE)
					(the-question ?the-question)
					(attribute ?the-attribute)
					(priority HIGH)
					(allowed-values $?valid-answers)
					(ans-mean $?ans-mean))
	=>
	(modify ?f (already-asked TRUE)(pronto FALSE))
	(bind ?answer (ask-question ?the-question ?valid-answers ?ans-mean))
	(if (lexemep ?answer)
		then (assert (attribute (name ?the-attribute)(value ?answer)))
	else (if (or(> ?answer 40)(eq ?answer 40)) 
			then (assert (attribute (name ?the-attribute) (value si) (certainty ?answer)))
			else (assert (attribute (name ?the-attribute) (value ns) (certainty (* ?answer 2))))		  )
	)
	(assert (answer-list (id ?i)(question ?the-question)(answer ?answer)))
	(modify ?ql (id (create$ ?id-list ?i)))
	(focus RULES QUESTIONS))
	
	
;regola per porre domande con priorita' media
(defrule QUESTIONS::ask-medium-question
	(declare (salience -50))
	?ql <- (answered-id-list (id $?id-list))
	?f <- (question (id ?i)
					(already-asked FALSE)
					(pronto TRUE)
					(the-question ?the-question)
					(attribute ?the-attribute)
					(priority MEDIUM)
					(allowed-values $?valid-answers)
					(ans-mean $?ans-mean))
	=>
	(modify ?f (already-asked TRUE)(pronto FALSE))
	(bind ?answer (ask-question ?the-question ?valid-answers ?ans-mean))
	(if (lexemep ?answer)
		then (assert (attribute (name ?the-attribute)(value ?answer)))
	else (if (or(> ?answer 40)(eq ?answer 40)) 
			then (assert (attribute (name ?the-attribute) (value si) (certainty ?answer)))
			else (assert (attribute (name ?the-attribute) (value ns) (certainty (* ?answer 2))))		  )
	)
	(assert (answer-list (id ?i)(question ?the-question)(answer ?answer)))
	(modify ?ql (id (create$ ?id-list ?i)))
	(focus RULES QUESTIONS))
	
;regola per modificare lo stato di una domanda con already-asked a TRUE e che permette di asserire quanto affermato dall'utente
(defrule QUESTIONS::ask-a-question
	(declare (salience -100))
	?ql <- (answered-id-list (id $?id-list))
	?f <- (question (id ?i)
					(already-asked FALSE)
					(pronto TRUE)
					(the-question ?the-question)
					(attribute ?the-attribute)
					(priority LOW)
					(allowed-values $?valid-answers)
					(ans-mean $?ans-mean))
	=>
	(modify ?f (already-asked TRUE)(pronto FALSE))
	(bind ?answer (ask-question ?the-question ?valid-answers ?ans-mean))
	(if (lexemep ?answer)
		then (assert (attribute (name ?the-attribute)(value ?answer)))
	else (if (or(> ?answer 40)(eq ?answer 40)) 
			then (assert (attribute (name ?the-attribute) (value si) (certainty ?answer)))
			else (assert (attribute (name ?the-attribute) (value ns) (certainty (* ?answer 2))))		  )
	)
	(assert (answer-list (id ?i)(question ?the-question)(answer ?answer)))
	(modify ?ql (id (create$ ?id-list ?i)))
	(focus RULES QUESTIONS))

;regola che stabilisce quando non ci sono più domande da porre
(defrule QUESTIONS::questions-finished
	(declare (salience -100))
	?f <- (question-loop (loop TRUE))
	(not (question (pronto TRUE)))
	(answer-list )
	=>
	(modify ?f (loop FALSE))
	(focus MAIN)
)

;-----------------------------------|
;modulo per la gestione delle regole|
;-----------------------------------|

(defmodule RULES (import MAIN ?ALL) (import QUESTIONS ?ALL)(export ?ALL))

;elimina le parti in and di una regola negli antecedenti o LHS
(defrule RULES::throw-away-ands-in-antecedent
  ?f <- (rule (if and $?rest))
  =>
  (modify ?f (if ?rest))
)

;elimina le parti in and di una regola nei conseguenti o RHS
(defrule RULES::throw-away-ands-in-consequent
  ?f <- (rule (then and $?rest))
  =>
  (modify ?f (then ?rest))
)


;effettua il matching fra gli attributi presenti nella wm e le parti sinistre delle regole modificando opportunamente il cf
(defrule RULES::remove-is-condition-when-satisfied
  ?f <- (rule (certainty ?c1) 
              (if ?attribute is ?value $?rest))
  (attribute (name ?attribute) 
             (value ?value) 
             (certainty ?c2))
  => 
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest))
)

;asserisce nuovi attributi quando una regola è soddisfatta. Questo è il caso in cui sia antecedente che conseguente hanno cf
(defrule RULES::perform-rule-consequent-with-certainty
  ?f <- (rule (certainty ?c1) 
              (if) 
              (then ?attribute is ?value with certainty ?c2 $?rest))
  =>
   (modify ?f (then ?rest))
   (assert (attribute (name ?attribute) 
                     (value ?value)
                     (certainty (/ (* ?c1 ?c2) 100))))  
)

;asserisce nuovi attributi quando la parte sinistra di una regola è soffisfatta. In questo caso la parte destra non ha cf
(defrule RULES::perform-rule-consequent-without-certainty
  ?f <- (rule (certainty ?c1)
              (if)
              (then ?attribute is ?value $?rest))
  (test (or (eq (length$ ?rest) 0)
            (neq (nth 1 ?rest) with)))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) (value ?value) (certainty ?c1)))
)

;elimina gli attributi che si ripetono, combinando i fattori di certezza
(defrule RULES::combine-certainties
  ?rem1 <- (attribute (name ?rel) (value ?val) (certainty ?per1))
  ?rem2 <- (attribute (name ?rel) (value ?val) (certainty ?per2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (+ (/ (- (* 100 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100) (/ (+ ?per1 ?per2) 2)) 2)))

)



;----------------------------------------|
;modulo che si occupa della ritrattazione|
;----------------------------------------|

(defmodule RETRACT (import MAIN ?ALL)(export ?ALL))

;funzione che modifica come da ritrattare tutti i precursori della domanda con attributo uguale a quello passato come parametro
;si procede poi in maniera ricorsiva per porre come da ritrattare tutte le domande che dipendono dall'attributo di partenza
(deffunction RETRACT::question-retract-chaining (?attribute)
	(do-for-all-facts ((?q question)(?p question-precursors)) (and (member$ ?attribute ?p:precursors)(eq ?p:question ?q:the-question)(eq ?q:already-asked TRUE))
	(modify ?p (retract-it TRUE))
	(question-retract-chaining ?q:attribute))
)

;funzione per stampare le domande a cui l'utente ha risposto e chiedere quale domanda vuole ritrattare
;La funzione restituisce la risposta dell'utente
(deffunction RETRACT::print-retract-process ()
   (printout t crlf)
   (printout t "Le domande a cui hai risposto sono le seguenti:")
   (printout t "" crlf)
   (do-for-all-facts ((?p answer-list)) TRUE (printout t ?p:id ". " ?p:question " -> " ?p:answer crlf))
   (printout t "Inserisci l'id della domanda che vuoi ritrattare (exit per uscire) -> ")
   (bind ?answer (read))
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer (fact-slot-value (nth 1 (find-fact ((?p answered-id-list)) TRUE)) id))) do
	  (printout t crlf)
	  (printout t "id non valido. Inserisci l'id di una delle domande stampate" crlf)
	  (do-for-all-facts ((?p answer-list)) TRUE (printout t ?p:id ". Domanda:  " ?p:question " -> " ?p:answer crlf))
	  (printout t "Inserisci l'id della domanda che vuoi ritrattare (exit per uscire) ->")
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
	)
   ?answer
)


;regola che impone come da ritrattare la domanda selezionata dall'utente
;la funzione elimina tutte le regole (che sono state modificate durante il processo di inferenza) 
;e le asserisce di nuovo per ripristinare la situazione di partenza
(defrule RETRACT::begin-retract-process
	?r <- (retract-loop (print TRUE))
	=>
	(bind ?answer (print-retract-process ))
	(if (eq ?answer exit) 
	then (focus PRODOTTI)
	else (do-for-all-facts ((?p question-precursors)(?q answer-list)) (and (eq ?answer ?q:id) (eq ?p:question ?q:question)) (modify ?p (retract-it TRUE)))
			(do-for-all-facts ((?r rule)) TRUE (retract ?r))
			(do-for-all-facts ((?d def-rule)) TRUE (assert (rule (certainty 100) (if ?d:if) (then ?d:then))))
		)
)

;funzione che ripristina i precursori di una domanda che dovrebbe avere come precursore l'attributo passato come parametro 
(deffunction restore-precursors-in-non-asked-questions
	(?attribute)
	(do-for-all-facts ((?qq question)(?pp question-precursors)) (and(member ?attribute ?pp:precursors)(eq ?qq:the-question ?pp:question)(neq ?qq:precursors ?pp:precursors)) 
		(modify ?qq (precursors ?pp:precursors)))
	
)

;funzione che modifica ad non ancora pronta per essere posta una domanda che ha come attributo un attributo presente nella parte destra di una regola. Tale attributo è quello passato come parametro
;restituisce l'attributo passato come parametro
(deffunction retract-post-rule-questions 
	(?attribute)
	(do-for-all-facts ((?qq question)(?a attribute)) (and(eq ?qq:attribute ?attribute)(eq ?a:name ?attribute)) 
		(modify ?qq (already-asked FALSE)(pronto FALSE))(restore-precursors-in-non-asked-questions ?a:name)(retract ?a))
	?attribute
)


;funzione che si occupa della ritrattazione vera e propria 
;modifica le domande ripristinando i precursori e modificando gli attributi 'pronto' e 'already-asked'
(defrule RETRACT::retract-question
	(declare (salience 10))
	?p <- (question-precursors	(question ?question)(precursors $?precursors)(retract-it TRUE))
	?x <- (question (the-question ?question)(attribute ?the-attribute))
	?a <- (answer-list (id ?id)(question ?question))
	?l  <- (answered-id-list (id $?id-list))
	=>	
	;cancella la domanda dalla lista delle domande già poste
	(progn$ (?field ?id-list) (if (eq ?field ?id) then (delete$ ?id-list ?field-index ?field-index)))
	;si elimina dalla WM il fatto che rappresenta la domanda con la relativa risposta
	(retract ?a)
	;si modificano gli attributi della domanda per ripristinare i precursori e si pongono gli attributi 'already-asked' e 'pronto' a false
	(modify ?x (precursors ?precursors)(already-asked FALSE)(pronto FALSE))
	;si pone retract-it a false per indicare che quella domanda non deve più essere ritrattata
	(modify ?p (retract-it FALSE))
	;si modificano i retract-it a true di tutti le domande che hanno come precursore l'attributo
	(question-retract-chaining ?the-attribute)
	;per tutti gli attributi, con relativi valori, che si trovano nella parte destra di una regola che nella parte sinistra ha l'attributo della domanda in esame, 
	;si avvia il question-retract-chaining e si ritratta l'attributo
	(do-for-all-facts ((?r def-rule)(?a attribute)) (and(member ?the-attribute ?r:if)(member ?a:name ?r:then)(member ?a:value ?r:then))
		(question-retract-chaining (retract-post-rule-questions ?a:name))(retract ?a))
	;si ritrattano tutti gli attributi che hanno come nome l'attributo della domanda in esame
	(do-for-all-facts ((?a attribute)) (eq ?a:name ?the-attribute) (retract ?a))
)

;regola che modifica i precursori delle domande segnando che non devono piu' essere ritrattate
(defrule RETRACT::trigger-questions
	(declare (salience -10))
	?p <- (question-precursors (retract-it TRUE))
	=>
	(modify ?p (retract-it FALSE))
)

;regola che permette di riprendere con le domande dopo aver ripristinato la situazione
(defrule RETRACT::restart-questions
	(declare (salience -10))
	(not (question-precursors (retract-it TRUE)))
	=>
	(focus RULES QUESTIONS RULES)
)


;---------------------------------------------------------------------------------------------------------------------------------------------|
;modulo con la lista delle auricolari e cuffie e le funzioni per riconoscere a partire dagli attributi quali sono le cuffie/auricolari migliori|
;---------------------------------------------------------------------------------------------------------------------------------------------|

(defmodule PRODOTTI (import MAIN ?ALL)(export ?ALL))

(deffacts PRODOTTI::list-auricolari

	;lista degli auricolari generici
	(auricolari (name AKG_N40)(brand AKG)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 399.99)(fascia-prezzo alta) )
	(auricolari (name AKG_Y20U)(brand AKG)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 29.99)(fascia-prezzo bassa) )
	(auricolari (name AKG_N20U)(brand AKG)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi no)(alta-fedelta si)(prezzo 129.99)(fascia-prezzo alta) )
	(auricolari (name Sony_MDR-E9LP)(brand Sony)(comandi no)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no) (prezzo 8.14)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-XB50AP)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta no)(prezzo 40.00)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-EX15LP)(brand Sony)(comandi no)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 9.00)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-EX110AP)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 20.00)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-EX155AP)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 27.90)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-AS210)(brand Sony)(comandi no)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 15.00)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-AS210AP)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 15.00)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-AS410AP)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 30.00)(fascia-prezzo bassa) )
	(auricolari (name Sony_MDR-XB510AS)(brand Sony)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 40.00)(fascia-prezzo bassa) )
	(auricolari (name Beats_urBeats3)(brand Beats)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 64.95)(fascia-prezzo media) )
	(auricolari (name Sennheiser_IE4)(brand Sennheiser)(comandi no)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 69.00)(fascia-prezzo media) )
	(auricolari (name Sennheiser_IE60)(brand Sennheiser)(comandi no)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 149.00)(fascia-prezzo alta) )
	(auricolari (name Sennheiser_IE80)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 299.00)(fascia-prezzo alta) )	 
	(auricolari (name Sennheiser_IE800)(brand Sennheiser)(comandi no)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 999.00)(fascia-prezzo alta) )
	(auricolari (name Sennheiser_PMX686)(brand Sennheiser)(comandi si)(tipo classico)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 49.00)(fascia-prezzo media) )
	(auricolari (name Sennheiser_OCX686)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 49.00)(fascia-prezzo media) )
	(auricolari (name Sennheiser_MX686G)(brand Sennheiser)(comandi si)(tipo classico)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 39.00)(fascia-prezzo bassa) )
	(auricolari (name Pioneer_SE-E721)(brand Pioneer)(comandi no)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 19.00)(fascia-prezzo bassa) )
	(auricolari (name Pioneer_SE-CL501)(brand Pioneer)(comandi no)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 12.90)(fascia-prezzo bassa) )
	(auricolari (name Pioneer_SE-CL621TV)(brand Pioneer)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 16.00)(fascia-prezzo bassa) )
	(auricolari (name BowersWilkins_C5_Series2)(brand Bowers_Wilkins)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 149.99)(fascia-prezzo alta) )
	(auricolari (name Bose_SoundTrue_Ultra)(brand Bose)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta si)(prezzo 149.95)(fascia-prezzo alta) )
	(auricolari (name Bose_QuietComfort_20)(brand Bose)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 249.00)(fascia-prezzo alta) )
	(auricolari (name Yianerm-Dual-Dynamic-Driver)(brand Yianerm)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta no)(prezzo 9.99)(fascia-prezzo bassa) )
	(auricolari (name Apple-Md827ZM )(brand Apple)(comandi si)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 15.00)(fascia-prezzo bassa) )
	(auricolari (name Huawei-AM115)(brand Huawei)(comandi si)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta si)(prezzo 9.99)(fascia-prezzo bassa) )
	(auricolari (name MAS-CARNEY-Cuffie-Auricolari)(brand MAS-CARNEY)(comandi si)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 9.99)(fascia-prezzo bassa) )
	(auricolari (name Sony-MDR-E9LP)(brand Sony)(comandi no)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 9.99)(fascia-prezzo bassa) )
	(auricolari (name Marley-Smile-Jamaica)(brand Marley)(comandi no)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 19.99)(fascia-prezzo bassa) )
	(auricolari-w (name Sony_WF-1000X)(brand Sony)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 200.00)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Sony_WF-SP900)(brand Sony)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita si)(buoni-bassi si)(alta-fedelta si)(prezzo 280.00)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Sony_WF-SP700N)(brand Sony)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita si)(buoni-bassi si)(alta-fedelta si)(prezzo 200.00)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Sony_WI-1000X)(brand Sony)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 280.00)(fascia-prezzo alta)(archetto si)(cavo no)(cofanetto no) )
	(auricolari-w (name Sony_WI-SP500)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta si)(prezzo 90.00)(fascia-prezzo media)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Sony_WI-C400)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta si)(prezzo 70.00)(fascia-prezzo media)(archetto si)(cavo no)(cofanetto no) )
	(auricolari-w (name Sony_MDR-XB80BS)(brand Sony)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 140.00)(fascia-prezzo alta)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Beats_BeatsX)(brand Beats)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta no)(prezzo 119.95)(fascia-prezzo media)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Beats_Powerbeats3)(brand Beats)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi si)(alta-fedelta si)(prezzo 199.95)(fascia-prezzo alta)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name AirPods)(brand Apple)(comandi si)(tipo classico)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta si)(prezzo 179.00)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Gear_IconX)(brand Samsung)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi si)(alta-fedelta si)(prezzo 179.00)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Aukey_Latitude)(brand Aukey)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 24.99)(fascia-prezzo bassa)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name MyCarbon_Wireless)(brand MyCarbon)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 40.00)(fascia-prezzo bassa)(archetto no)(cavo no)(cofanetto no) )
	(auricolari-w (name TaoTronics_Earphone)(brand TaoTronics)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta no)(prezzo 19.00)(fascia-prezzo bassa)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Bose_QuietControl_30)(brand Bose)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 299.95)(fascia-prezzo alta)(archetto si)(cavo no)(cofanetto no) )
	(auricolari-w (name Bose_SoundSport)(brand Bose)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 149.95)(fascia-prezzo alta)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Bose_SoundSport_Free)(brand Bose)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 199.95)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Jabra_Box)(brand Jabra)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 49.00)(fascia-prezzo media)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Sennheiser-CX6BT)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta si)(prezzo 99.00)(fascia-prezzo media)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Sennheiser-CX-SPORT)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi no)(alta-fedelta si)(prezzo 129.00)(fascia-prezzo alta)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Sennheiser-MOMENTUM_In-Ear_Wireless_Black)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 199.00)(fascia-prezzo alta)(archetto si)(cavo no)(cofanetto no) )
	(auricolari-w (name Sennheiser-CX-7BT_In-Ear_Wireless)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 149.00)(fascia-prezzo alta)(archetto si)(cavo no)(cofanetto no) )
	(auricolari-w (name Sennheiser_MOMENTUM_Free)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita no)(buoni-bassi si)(alta-fedelta si)(prezzo 199.00)(fascia-prezzo alta)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Sennheiser_MOMENTUM_True_Wireless)(brand Sennheiser)(comandi si)(tipo in-ear)(materiali premium)(impermeabilita si)(buoni-bassi si)(alta-fedelta si)(prezzo 299.00)(fascia-prezzo alta)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Muzili-TWS-Earbuds)(brand Muzili)(comandi si)(tipo in-ear)(materiali plastica)(impermeabilita si)(buoni-bassi si)(alta-fedelta no)(prezzo 49.99)(fascia-prezzo media)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Salpie-Pods-Bluetooth)(brand Salpie)(comandi si)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 19.99)(fascia-prezzo bassa)(archetto no)(cavo no)(cofanetto si) )
	(auricolari-w (name Charlemain-Auricolari-Bluetooth)(brand Charlemain)(comandi si)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 18.99)(fascia-prezzo bassa)(archetto no)(cavo si)(cofanetto no) )
	(auricolari-w (name Yuhao-AURICOLARI-I7S)(brand Yuhao)(comandi si)(tipo classico)(materiali plastica)(impermeabilita no)(buoni-bassi no)(alta-fedelta no)(prezzo 12.99)(fascia-prezzo bassa)(archetto no)(cavo no)(cofanetto si) )
	;(auricolari-w (name )(brand )(comandi )(tipo )(materiali )(impermeabilita )(buoni-bassi )(alta-fedelta )(prezzo )(fascia-prezzo )(archetto )(cavo )(cofanetto ) )
)

(deffacts PRODOTTI::list-cuffie

;lista delle cuffie generiche
(cuffie (name AKG-Y40)(brand AKG)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 99.95)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-N60-NC)(brand AKG)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 249.95)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-N90Q)(brand AKG)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 1499.95)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-Y45BT)(brand AKG)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 149.95)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-Y50BT)(brand AKG)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 149.95)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-K495NC)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 299.95)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K550-MKIII)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 199.95)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K551)(brand AKG)(comandi si)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 329.95)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-N700NC-Wireless)(brand AKG)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 349.95)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K553-MKII)(brand AKG)(comandi no)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 149.00)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-K240-STUDIO)(brand AKG)(comandi no)(wired si)(materiali plastica)(tipo over-ear)(apertura semiaperta)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza alta)(sensibilita media)(richiudibili no)(prezzo 69.00)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-K240-MKII)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo ove-ear)(apertura semiaperta)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza alta)(sensibilita media)(richiudibili no)(prezzo 149.00)(fascia-prezzo-cuffie media) )
;(cuffie (name AKG-K872)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 1499.00)(fascia-prezzo-cuffie alta) )
;(cuffie (name AKG-K812)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura aperta)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 1499.00)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K701)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura aperta)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza alta)(sensibilita media)(richiudibili no)(prezzo 449.00)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K271-MKII)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq alto)(impedenza alta)(sensibilita media)(richiudibili no)(prezzo 199.00)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K612-PRO)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura aperta)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza alta)(sensibilita media)(richiudibili no)(prezzo 199.00)(fascia-prezzo-cuffie alta) )
(cuffie (name AKG-K182)(brand AKG)(comandi no)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 99.00)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-K92)(brand AKG)(comandi no)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 59.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name AKG-K72)(brand AKG)(comandi no)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 49.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name AKG-K175)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq alto)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 129.00)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-K245)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura aperta)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 149.00)(fascia-prezzo-cuffie media) )
(cuffie (name AKG-K275)(brand AKG)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq alto)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 169.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-MDR-100ABN)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 300.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-WH-1000XM3)(brand Sony)(comandi no)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 380.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-MDR-1AM2)(brand Sony)(comandi si)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 250.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-WH-H900N)(brand Sony)(comandi no)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 300.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-WH-H800-2-Mini)(brand Sony)(comandi no)(wired no)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 180.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-MDR-XB950N1)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 149.00)(fascia-prezzo-cuffie media) )
(cuffie (name Sony-MDR-XB650BT)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 90.00)(fascia-prezzo-cuffie media) )
(cuffie (name Sony-MDR-XB550AP)(brand Sony)(comandi si)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 50.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-WH-CH700N)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 180.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-WH-CH500)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 59.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-MDR-ZX770BN)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 180.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Sony-MDR-ZX660AP)(brand Sony)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 59.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-MDR-ZX330BT)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 100.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-MDR-ZX310)(brand Sony)(comandi no)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 25.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-MDR-ZX220BT)(brand Sony)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 80.00)(fascia-prezzo-cuffie media) )
(cuffie (name Sony-MDR-ZX110NA)(brand Sony)(comandi no)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 59.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-MDR-XB950AP)(brand Sony)(comandi si)(wired si)(materiali premium)(tipo over-ear)(apertura semiaperta)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 110.00)(fascia-prezzo-cuffie media) )
(cuffie (name Sony-DR-V150IP)(brand Sony)(comandi no)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq alto)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 59.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Sony-V55)(brand Sony)(comandi no)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 70.00)(fascia-prezzo-cuffie media) )
(cuffie (name Sony-ZX110)(brand Sony)(comandi no)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 15.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Beats-EP)(brand Beats)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 99.00)(fascia-prezzo-cuffie media) )
(cuffie (name Beats-Solo3-Wireless)(brand Beats)(comandi si)(wired no)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 299.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Beats-Studio-3-Wireless)(brand Beats)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq bassa)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 349.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Beats-Pro)(brand Beats)(comandi si)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 399.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Bluedio-F2)(brand Bluedio)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza basso)(sensibilita alta)(richiudibili si)(prezzo 55.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Bluedio-V2)(brand Bluedio)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 70.00)(fascia-prezzo-cuffie media) )
(cuffie (name Bluedio-T2+)(brand Bluedio)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili si)(prezzo 29.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name Cuffie-QuietComfort-35-II-wireless)(brand Bose)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 379.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Cuffie-SoundLink-around-ear-II-wireless)(brand Bose)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura semiaperta)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 229.00)(fascia-prezzo-cuffie alta) )
(cuffie (name Cuffie-Bose-on-ear-wireless)(brand Bose)(comandi si)(wired no)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 199.00)(fascia-prezzo-cuffie alta) )

(cuffie (name Urbanears-Plattan-2-Bluetooth)(brand Urbanears)(comandi si)(wired no)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 80.00)(fascia-prezzo-cuffie media) )
(cuffie (name Cuffie-Urbanears-Plattan-II)(brand Urbanears)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 40.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name LinkWitz-Cuffie-Bluetooth-Wireless)(brand LinkWitz)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 16.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name Marshall-Cuffia-Major)(brand Marshall)(comandi si)(wired si)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 99.99)(fascia-prezzo-cuffie media) )
(cuffie (name LOBKIN-Cuffie-Bluetooth)(brand LOBKIN)(comandi no)(wired no)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili si)(prezzo 21.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name MiluoTech-Gaming-Headset)(brand MiluoTech)(comandi si)(wired si)(materiali plastica)(tipo over-ear)(apertura semiaperta)(scheda-audio si)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 20.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name Beexcellent-beexc-Ellent-Bass)(brand Beexcellent)(comandi si)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio si)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 29.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name Beexcellent-GM-5)(brand Beexcellent)(comandi si)(wired si)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio si)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 22.79)(fascia-prezzo-cuffie bassa) )
(cuffie (name August-EP650B)(brand August)(comandi si)(wired no)(materiali plastica)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 45.00)(fascia-prezzo-cuffie bassa) )
(cuffie (name marsboy-PC-PS4)(brand marsboy)(comandi si)(wired si)(materiali plastica)(tipo on-ear)(apertura aperta)(scheda-audio si)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 21.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name Shure-SRH440)(brand Shure)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 99.99)(fascia-prezzo-cuffie media) )
(cuffie (name Beyerdynamic-DT-770PRO)(brand Beyerdynamic)(comandi no)(wired si)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq ampio)(impedenza alta)(sensibilita alta)(richiudibili no)(prezzo 149.99)(fascia-prezzo-cuffie media) )
(cuffie (name barsone-Noise-Cancelling)(brand barsone)(comandi si)(wired no)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling si)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 39.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name MiracleLesoul-A7)(brand MiracleLesoul)(comandi si)(wired no)(materiali premium)(tipo over-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili si)(prezzo 59.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name BeoPlay-Double-Headphone)(brand Jokitech)(comandi no)(wired no)(materiali premium)(tipo on-ear)(apertura chiusa)(scheda-audio no)(noise-cancelling no)(range-freq medio)(impedenza bassa)(sensibilita media)(richiudibili no)(prezzo 16.99)(fascia-prezzo-cuffie bassa) )
(cuffie (name COWIN-E8)(brand COWIN)(comandi si)(wired no)(materiali plastica)(tipo over-ear)(apertura semiaperta)(scheda-audio no)(noise-cancelling si)(range-freq basso)(impedenza bassa)(sensibilita alta)(richiudibili no)(prezzo 119.99)(fascia-prezzo-cuffie media) )
;(cuffie (name "")(brand )(comandi )(wired )(materiali )(tipo )(apertura )(scheda-audio )(noise-cancelling )(range-freq )(impedenza )(sensibilita )(richiudibili )(prezzo )(fascia-prezzo-cuffie ) )
)

;regola per asserire fatti che rappresentano gli auricolari migliori sulla base degli attributi presenti nella WM
(defrule PRODOTTI::assert-best-matches-auricolari
	(declare (salience 100))
	(attribute (name headphone-type) (value auricolari))
	(auricolari
		(name ?name)
		(brand ?brand)
		(comandi ?com)
		(tipo ?type)
		(materiali ?mat)
		(impermeabilita ?imp)
		(buoni-bassi ?bass)
		(alta-fedelta ?fid)
		(prezzo ?prezzo)
		(fascia-prezzo ?fprezzo))
	(attribute (name brand) (value ?brand) (certainty ?c1))
	(attribute (name comandi) (value ?com) (certainty ?c2))
	(attribute (name tipo) (value ?type) (certainty ?c3))
	(attribute (name materiali) (value ?mat) (certainty ?c4))
	(attribute (name impermeabilita) (value ?imp) (certainty ?c5))
	(attribute (name buoni-bassi) (value ?bass) (certainty ?c6))
	(attribute (name alta-fedelta) (value ?fid) (certainty ?c7))
	(attribute (name fascia-prezzo) (value ?fprezzo) (certainty ?c8))
	=>
	(assert (best-headphone (name ?name) (prezzo ?prezzo) (certainty(/(+ ?c1 ?c2 ?c3 ?c4 ?c5 ?c6 ?c7 ?c8)8))))
)

;regola per asserire fatti che rappresentano gli auricolari wireless migliori sulla base degli attributi presenti nella WM
(defrule PRODOTTI::assert-best-matches-auricolari-w
	(declare (salience 100))
	(attribute (name headphone-type) (value auricolari-w))
	(auricolari-w
		(name ?name)
		(brand ?brand)
		(comandi ?com)
		(tipo ?type)
		(materiali ?mat)
		(impermeabilita ?imp)
		(buoni-bassi ?bass)
		(alta-fedelta ?fid)
		(prezzo ?prezzo)
		(fascia-prezzo ?fprezzo)
		(archetto ?arc)
		(cavo ?cav)
		(cofanetto ?cof))
	(attribute (name brand) (value ?brand) (certainty ?c1))
	(attribute (name comandi) (value ?com) (certainty ?c2))
	(attribute (name tipo) (value ?type) (certainty ?c3))
	(attribute (name materiali) (value ?mat) (certainty ?c4))
	(attribute (name impermeabilita) (value ?imp) (certainty ?c5))
	(attribute (name buoni-bassi) (value ?bass) (certainty ?c6))
	(attribute (name alta-fedelta) (value ?fid) (certainty ?c7))
	(attribute (name fascia-prezzo) (value ?fprezzo) (certainty ?c8))
	(attribute (name archetto) (value ?arc) (certainty ?c9))
	(attribute (name cavo) (value ?cav) (certainty ?c10))
	(attribute (name cofanetto) (value ?cof) (certainty ?c11))
	=>
	(assert (best-headphone (name ?name) (prezzo ?prezzo) (certainty(/(+ ?c1 ?c2 ?c3 ?c4 ?c5 ?c6 ?c7 ?c8 ?c9 ?c10 ?c11)11))))
)

;regola per asserire fatti che rappresentano le cuffie migliori sulla base degli attributi presenti nella WM
(defrule PRODOTTI::assert-best-matches-cuffie
	(declare (salience 100))
	(attribute (name headphone-type) (value cuffie))
	(cuffie
		(name ?name)
		(brand ?brand)
		(comandi ?com)
		(wired ?wir)
		(materiali ?mat)
		(tipo ?typ)
		(apertura ?ap)
		(scheda-audio ?sca)
		(noise-cancelling ?nc)
		(range-freq ?rf)
		(impedenza ?imp)
		(sensibilita ?sens)
		(richiudibili ?ric)
		(prezzo ?prezzo)
		(fascia-prezzo-cuffie ?fpc))
	(attribute (name brand) (value ?brand) (certainty ?c1))
	(attribute (name comandi) (value ?com) (certainty ?c2))
	(attribute (name wired) (value ?wir) (certainty ?c3))
	(attribute (name materiali) (value ?mat) (certainty ?c4))
	(attribute (name tipo) (value ?typ) (certainty ?c5))
	(attribute (name apertura) (value ?ap) (certainty ?c6))
	(attribute (name scheda-audio) (value ?sca) (certainty ?c7))
	(attribute (name noise-cancelling) (value ?nc) (certainty ?c8))
	(attribute (name range-freq) (value ?rf) (certainty ?c9))
	(attribute (name impedenza) (value ?imp) (certainty ?c10))
	(attribute (name sensibilita) (value ?sens) (certainty ?c11))
	(attribute (name richiudibili) (value ?ric) (certainty ?c12))
	(attribute (name fascia-prezzo-cuffie) (value ?fpc) (certainty ?c13))
	=>
	(assert (best-headphone (name ?name) (prezzo ?prezzo) (certainty(/(+ ?c1 ?c2 ?c3 ?c4 ?c5 ?c6 ?c7 ?c8 ?c9 ?c10 ?c11 ?c12 ?c13)13))))
)

;regola per stampare l'intestazione che precede la lista delle chitarre quando non ci sono pi domande da porre
(defrule PRODOTTI::print-header ""
   (declare (salience 10))
   (not (question (pronto TRUE)))
   =>
   (printout t crlf)
   (printout t "*****************************************************************" crlf)
   (printout t "*                     PRODOTTI SELEZIONATI                      *" crlf)
   (printout t "*****************************************************************" crlf crlf)
   (printout t " PRODOTTO                                 PREZZO       CERTAINTY" crlf)
   (printout t "----------------------------------------------------------------" crlf)
   (assert (phase print-headphone)))

;regola per stampare la lista delle cuffie in maniera ordinata sulla base del CF
(defrule PRODOTTI::print-headphone ""
  ?rem <- (best-headphone (name ?name) (prezzo ?prezzo) (certainty ?per))		  
  (not (best-headphone (name ?n) (prezzo ?p) (certainty ?per1&:(> ?per1 ?per))))
  =>
  (retract ?rem)
  (format t " %-40s %2.2f%-5s %2.2f %n" ?name ?prezzo " " ?per)
  (printout t "----------------------------------------------------------------" crlf))


;regola per stampare una linea che indica la fine della lista delle cuffie
(defrule PRODOTTI::end-spaces ""
   (not (best-headphone (name ?n)))
   =>
   (printout t "----------------------------------------------------------------" crlf))

;funzione per chiedere all'utente se vuole procedere con la ritrattazione di una domanda
(deffunction PRODOTTI::ask-retract()
	(printout t crlf "Vuoi visualizzare o modificare le domande a cui hai precedentemente risposto? (S/N) ")
	(bind ?answ (read))
	(if (lexemep ?answ) then (bind ?answ (lowcase ?answ)))
	(while (not (or (eq ?answ s)(eq ?answ n)))
		(printout t crlf "Vuoi visualizzare o modificare le domande a cui hai precedentemente risposto? (S/N) ")
		(bind ?answ (read))
		(if (lexemep ?answ) then (bind ?answ (lowcase ?answ)))
	)
	?answ
)

;regola che permette di chiedere all'utente se vuole terminare o avviare una nuova sessione
(defrule PRODOTTI::finish
	(declare (salience -10))
	(not (attribute (name best-headphone)))
	(retract-loop (print TRUE))
	=>
	;solo per debug (do-for-all-facts ((?a attribute)) TRUE (printout t ?a:name " " ?a:value " " ?a:certainty " " crlf))
	(if (eq s (ask-retract))
		then (focus RETRACT MAIN)
		else (printout t crlf crlf "Premere r per riavviare il programma, qualsiasi altro tasto per uscire -> ")
			 (bind ?ans (read))
			 (if (lexemep ?ans) then (bind ?ans (lowcase ?ans)))
			 (if (eq ?ans r) then (reset)(run) else (exit))
	)
)

;;******************
;; INITIAL FACTS
;;******************
					
					
;fatti da asserire al momento dell'avvio del programma
;question-loop indica che si deve procedere con le domande
;retract-loop indica che non si deve procedere con la ritrattazione
;answered-id-list è la lista delle domande a cui l'utente ha risposto
(deffacts initial-facts
	(question-loop (loop TRUE))
	(retract-loop (print FALSE))
	(answered-id-list (id create$ exit))
)

;regola che genera le regole a partire da meta-regole
(defrule MAIN::gen-rules
	(declare (salience 100))
	(def-rule (if $?if) (then $?then))
	=>
	(assert (rule (certainty 100) (if ?if) (then ?then)))
)

;regola che modifica il retract-loop in maniera da poter attivare la regola che chiede all'utente se si uvole procedere 
;con la ritrattazione
(defrule MAIN::focus-on-retract
(declare (salience 10))
	(question-loop (loop FALSE))
	?x <- (retract-loop (print FALSE))
	=>
	(modify ?x (print TRUE))
	(focus PRODOTTI RULES)
)

;regola che si attiva all'inizio dell'esecuzione per porre la strategia di risoluzione dei conflitti a random
(defrule MAIN::start
	=>
	(focus QUESTIONS RULES)
	(set-strategy random)
)