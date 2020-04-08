;lista delle domande con precursori, priorità e valori ammessi come risposta
;per la risoluzione dei conflitti si è usata la seguente tecnica:
;le domande sono divise in tre categorie sulla base delle priorità che sono HIGH, MEDIUM e LOW
;Se ci sono due domande che hanno entrambe precursori soddisfatti si porrà prima quella con priorità più alta;
;Nel caso in cui invece ci siano due domande con stessa priorità e precursori soddisfatti verranno poste in maniera random

(deffacts questions-list

    (question
        (id 1)
        (attribute ha-cuffie)
        (the-question "Possiedi gia' un paio di cuffie/auricolari?")
        (why "Sapere se sei in possesso gia di una cuffia o auricolare mi aiutera' a capire che tipo di utente sei e come parlarti.")
        (info "Rispondere solo si o no.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
    )

    (question
        (id 2)
        (attribute uso-sportivo)
        (the-question "Ne faresti un uso prevalentemente sportivo?")
        (why "Sapere se sei uno sportivo mi aiuterebbe a capire quale apparecchio consigliarti.")
        (info "Esistono prodotti che sono completamente protetti contro acqua e sudore e quindi più indicati per un uso sportivo. ")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a)
    )

    (question
        (id 3)
        (attribute auricolari-cuffie)
        (the-question "Preferiresti degli auricolari o delle cuffie?")
        (why "Sapere se hai gia' una preferenza particolare mi aiuterebbe a consigliarti gia' qualcosa che ti piacerebbe.")
        (info "Per auricolari si intende banalmente le cuffiette vendute con i telefoni, per cuffie che coprono il padiglione auricolare.")
        (priority HIGH)
        (allowed-values a c)
        (ans-mean auricolari cuffie)
    )

    (question
        (id 4)
        (attribute materiali-top)
        (the-question "Preferisci un design ricercato e ottimi materiali di costruzione?")
        (why "Sapere se ti interessano materiali di qualita' alta mi aiuterebbe a selezionare prodotti che rispecchiano questa caratteristica.")
        (info "Per materiali di alta qualità s'intende: alluminio, legno, pelle, ecc...")
        (priority HIGH)
        (allowed-values s n ns)
        (ans-mean si no "non so")
    )

    (question
        (id 5)
        (attribute brand-famoso)
        (the-question "Ti affideresti esclusivamente ad un brand gia' presente nel settore da anni?")
        (why "In questo settore il brand e' sinonimo di affidabilita' e qualita' che sono pero' caratteristiche che incidono sul prezzo.")
        (info "Brand famosi sono Beats, Sony, Pioneer, Sennheiser, ecc.")
        (priority HIGH)
        (allowed-values s n ns)
        (ans-mean si no "non so")
    )


;domande auricolari
   (question
        (id 6)
        (attribute auricolari-bluetooth)
        (the-question "Preferisci auricolari con tecnologia bluetooth?")
        (why "Ti sto ponendo questa domanda per capire se preferisci auricolari classici con attacco jack 3.5mm o bluetooth.")
        (info "Rispondere si o no.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is a)
    )

    (question
        (id 7)
        (attribute buona-durata)
        (the-question "E' un fattore di rilievo la durata della batteria?")
        (why "Ti sto ponendo questa domanda per capire quale tipo di auricolari consigliarti in base alle tue necessita'.")
        (info "Rispondere solo si o no.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is a and auricolari-bluetooth is si)
    )

    (question
        (id 8)
        (attribute senza-cavi)
        (the-question "Preferisci degli auricolari con totale assenza di cavi?")
        (why "Questa scelta e' fondamentale affinche' ti possa consigliare un prodotto che di piaccia e che rispecchi le tue esigenze.")
        (info "Per totale assenza di cavi s'intendono quei prodotti totalmente privi di cavi, sia di collegamento con i device, sia tra l'auricolare destro che sinistro.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a and auricolari-bluetooth is si)
    )

    (question
        (id 44)
        (attribute sostegno-archetto)
        (the-question "Utilizzeresti un paio di auricolari con sostegni o archetto?")
        (why "Questa risposta aiutera' a capire se nell' utilizzo avrai bisgono di un tipo di auricolari adatti a particolari situazioni.")
        (info "Per sostegno o archetto si intende quelle plastiche vicino alle orecchie o intorno al collo. ")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a and auricolari-bluetooth is si and senza-cavi is no)
    )

    (question
        (id 9)
        (attribute utilizzo-mobilita)
        (the-question "Utilizzeresti queste auricolari con lo smartphone in mobilita' ed eventualmente per chiamate?")
        (why "Non e' una domanda inutile, esistono auricolari con microfono e comandi integrati a alcune che non hanno questa caratteristica.")
        (info "Rispondere si o no.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a)
    )

    (question
        (id 10)
        (attribute fascia-prezzo-auricolari)
        (the-question "Quanto saresti disposto a spendere per degli auricolari?")
        (why "La fascia di prezzo e' una informazione fondamentale.")
        (info "Prodotti piu' costosi avranno senza dubbio caratteristiche migliori di quelle di fascia bassa.")
        (priority HIGH)
        (allowed-values a b c)
        (ans-mean "0 - 49 euro" "50 - 119 euro " "120 euro in su")
        (precursors auricolari-cuffie is a)
    )

    (question
        (id 11)
        (attribute genere-musicale-auricolari)
        (the-question "Che generi di musica ascolti prevalentemente?")
        (why "Il genere di musica e' una informazione fondamentale per dare importanza ad alcuni aspetti tecnici.")
        (info "Differenti generi musicali prediliscono alcuni suoni rispetto ad altri.")
        (priority HIGH)
        (allowed-values a b c)
        (ans-mean "Pop/Hip-Hop/Dance" "Rock/Indie/Alternative" "Jazz/Classica")
        (precursors auricolari-cuffie is a and ha-cuffie is no)
    )

    (question
        (id 12)
        (attribute freq-basse-aur)
        (the-question "Il prodotto a cui sei interessato deve essere in grado di riprodurre dei bassi con buona qualita'?")
        (why "Alcuni auricolari sono caratterizzati dal riprodurre frequenze basse di qualita' maggiore rispetto ad altri.")
        (info "Auricolari con buoni bassi permettono di percepire maggiormente suoni gravi e più pieni. ")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a and ha-cuffie is si)
    )

    (question
        (id 13)
        (attribute buona-fedelta)
        (the-question "Sei interessato ad una buona fedelta' sonora?")
         (why "Alcune cuffie tendono a sacrificare la fedeltà sonora rispetto a volume e frequenze basse.")
        (info "Alcuni auricolari sono caratterizzati dal saper riprodurre un' ampia gamma di frequenze in maniera pulita rispetto ad altri.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a and ha-cuffie is si)
    )

    (question
        (id 14)
        (attribute problemi-orecchio)
        (the-question "Soffri di particolari problemi uditivi o hai una fisionimia particolare del padiglione auricolare?")
        (why "Problemi uditivi o malformazioni dal padiglione/canale uditivo determinano la tipologia della forma dell'auricolare.")
        (info "Problemi come perforazione del timpano, deformazione del condotto uditivo è sconsigliato utilizzo di cuffie in-ear.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is a)
    )

    (question
        (id 15)
        (attribute isolamento-auricolari)
        (the-question "Durante l'ascolto preferisci isolarti dall'ambiente circostante?")
        (why "Alcuni utilizzatori durante l'ascolto preferiscono non ascoltare suoni provenienti dall'esterno.")
        (info "Rispondere si o no")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is a and problemi-orecchio is no)
    )

;domande cuffie

    (question
        (id 16)
        (attribute uso-professionale)
        (the-question "Ne vuoi fare un uso prettamente professionale?")
        (why "Questa domanda mi serve per capire quale tipologia di cuffie e padiglione scegliere per le tue esigenze.")
        (info "Per uso professionale s'intede l'utilizzo delle cuffie a scopo lavorativo (dj, radio, musicista ecc).")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c)
    )

    (question
        (id 17)
        (attribute cuffie-wireless)
        (the-question "Preferisci cuffie di tipo wireless?")
        (why "Ti sto rivolgendo questa domanda perche' esistono due tipologie di cuffie, quelle con il cavo e quelle wireless.")
        (info "Rispondere si o no.")
        (priority HIGH)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is c and uso-professionale is no)
    )

;domande cuffie uso professionale

    (question
        (id 18)
        (attribute dj)
        (the-question "Sei un DJ o vorresti dilettarti in questo campo?")
        (why "Sapere se sei un DJ mi aiutera' a capire che tipo di utente sei e di cosa hai bisogno.")
        (info "Esistono specifiche che sono prettamente consigliate per chi fa questo lavoro come impedenza, sensibilita' e apertura.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is si)
    )

    (question
        (id 19)
        (attribute radiofonico)
        (the-question "Lavori in radio/studio di registrazione e utilizzeresti le cuffie per lunghe sessioni d'ascolto?")
        (why "Sapere se lavori in determinati settori mi aiutera' a capire che tipo di utente sei e consigliarti il meglio per te.")
        (info "Esistono specifiche che sono prettamente consigliate per chi fa questo lavoro come impedenza, sensibilita' e apertura.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and dj is no)
    )

    (question
        (id 20)
        (attribute musicista)
        (the-question "Suoni qualche strumento?")
        (why "Sapere se sei un musicista e suoni qualche strumento mi aiutera' a capire che tipo di utente sei.")
        (info "Esistono specifiche che sono prettamente consigliate per chi fa questo lavoro come impedenza, sensibilita' e apertura.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is si and radiofonico is no)
    )

    (question
        (id 21)
        (attribute tipologia-strumento)
        (the-question "Che strumento suoni tra quelli proposti?")
        (why "Sapere che tipologia di strumento mi permette di capire quali suoni enfatizzare nell'ascolto.")
        (info "In base allo strumento che suoni ti consigliero' le giuste cuffie in modo tale da avere un'ottima fedelta' sonora.")
        (priority HIGH)
        (allowed-values a b c)
        (ans-mean "Basso/tromba" "Percussioni/Chitarra" "Tastiera/piano/violino")
        (precursors musicista is si)
    )

    (question
        (id 22)
        (attribute ambienti-rumorosi-pro)
        (the-question "Hai a che fare con ambienti molto rumorosi?")
        (why "Sapere la rumorosita' dell'ambiente intorno a te mi aiutera' a capire che genere di padiglione consigliarti.")
        (info "In base alla rumorosità ti posso consigliare cuffie con padiglione on-ear oppure over-ear")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is si and radiofonico is no)
    )

    (question
        (id 23)
        (attribute noise-cancelling-attivo)
        (the-question "Cerchi cuffie con tecnologia noise-cancelling attivo?")
        (why "La risposta a questa domanda mi permette di capire se le tue cuffie dovranno avere questa tecnologia o meno.")
        (info "Le cuffie con noise cancelling sono cuffie capaci di ridurre i suoni ambientali indesiderati usando il controllo del rumore attivo.")
        (priority HIGH)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is c and uso-professionale is si and ambienti-rumorosi-pro is si)
    )

    (question
        (id 24)
        (attribute range-freq-ampio)
        (the-question "Le cuffie di tuo interesse devono avere un range di frequenze abbastanza ampio?")
        (why "Alcune cuffie ampliano il range coperto al fine di offrire una migliore resa sonora nella riproduzione di toni bassi, medi e alti.")
        (info "La risposta in frequenza denota l'intera gamma di frequenze sonore che un paio di cuffie e' in grado di riprodurre.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is si)
    )

    (question
        (id 25)
        (attribute freq-basse)
        (the-question "Hai bisogno di enfatizzare frequenze basse e avere un suono pieno?")
        (why "Una risposta precisa a questa domanda mi permette di selezionare delle cuffie con una riproduzione ottima di bassi.")
        (info "Alcune cuffie sono caratterizzate dal saper riprodurre frequenze basse con qualita' maggiore rispetto ad altre.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is si and range-freq-ampio is no)
    )

    (question
        (id 26)
        (attribute freq-med-alt)
        (the-question "Quindi daresti piu' importanza a frequenze medio-alte?")
        (why "Una risposta precisa a questa domanda mi permette di selezionare delle cuffie con una riproduzione ottima di medi e alti.")
        (info "Alcune cuffie sono caratterizzate dal saper riprodurre frequenze medie e alte con qualita' maggiore rispetto ad altre.")
        (priority HIGH)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is si and freq-basse is no)
    )

    (question
        (id 27)
        (attribute richiudibilita)
        (the-question "Ti interessano cuffie pieghevoli e/o girevoli?")
        (why "Esistono alcuni modelli di cuffie che hanno una struttura ripiegabile e altre no. Questo influisce sulla portatilità.")
        (info "Per cuffie ripiegabili si intende modelli con padiglioni girevoli o ripiegavoli verso l'archetto.")
        (priority HIGH)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors auricolari-cuffie is c and dj is si)
    )


;domande cuffie uso non professionale

    (question
        (id 28)
        (attribute fascia-prezzo-cuffia)
        (the-question "Quanto sei disposto a spendere?")
        (why "Sapere quanto e' il tuo budget mi permette di scartare alcune cuffie con prezzo che non si aggirano attorno al tuo budget.")
        (info "Come in ogni settore la qualita', l'affidabilita', l'assistenza determinano il prezzo di un prodotto.")
        (priority MEDIUM)
        (allowed-values a b c)
        (ans-mean "0 - 59 euro" "60 - 149 euro " "150 euro in su")
        (precursors auricolari-cuffie is c and uso-professionale is no)
    )

    (question
        (id 29)
        (attribute esperto-cuffie)
        (the-question "Ti ritieni esperto in questo campo?")
        (why "Sapere se sei un esperto del campo mi aiutera' a capire che tipo di utente sei.")
        (info "Per me e' importante capire se posso parlarti di caratteristiche tecniche prettamente settoriali o meno.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors auricolari-cuffie is c and uso-professionale is no)
    )

;domande cuffie esperto cuffie

    (question
        (id 30)
        (attribute bassa-impedenza)
        (the-question "Hai bisogno di cuffie con bassa impedenza da collegare ad un dispositivo mobile?")
        (why "Sapere il dispositivo al quale verranno collegate e' fondamentale per scegliere il giusto paio di cuffie.")
        (info "L'impedenza indica la resistenza esercitata dalle cuffie sul segnale audio. Le cuffie a bassa impedenza impiegano una resistenza decisamente contenuta e possono essere facilmente utilizzate con dispositivi di piccole dimensioni")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors esperto-cuffie is si)
    )

    (question
        (id 31)
        (attribute alta-impedenza)
        (the-question "Quindi andranno necessariamente collegate ad un impianto?")
        (why "apere il dispositivo al quale verranno collegate e' fondamentale per scegliere il giusto paio di cuffie.")
        (info "Le cuffie ad alta impedenza potranno collegarsi a sistemi piu' complessi, come impianti Hi-Fi e mixer da studio, in grado di fornire la potenza necessaria ad alimentare headset elaborati.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is si and bassa-impedenza is no)
    )

    (question
        (id 32)
        (attribute apertura-cuffia)
        (the-question "Che tipo di cuffie preferisci?")
        (why "Le cuffie possono presentare una struttura aperta, chiusa o in alternativa semi-aperta")
        (info "Nel primo caso, il retro dei padiglioni auricolari e' aperto: cio' consente al suono di fuoriuscire verso l'esterno, contribuendo a creare una sensazione di maggior naturalezza. Questa soluzione non garantisce tuttavia un buon isolamento acustico")
        (priority MEDIUM)
        (allowed-values a s c)
        (ans-mean aperte semi-aperte chiuse)
        (precursors esperto-cuffie is si)
    )

    (question
        (id 33)
        (attribute sensibilita-cuffie)
        (the-question "Che grado di sensibilita' vuoi che le tue cuffie abbiano?")
        (why "La risposta a questa domanda mi permette di capire quale grado di sensibilita' dovranno avere le cuffie che devo proporti.")
        (info "La sensibilita' indica la pressione acustica espressa dalle cuffie in relazione alla tensione applicata ed e' misurata in Decibel (dB)")
        (priority MEDIUM)
        (allowed-values b m a)
        (ans-mean basso medio alto)
        (precursors esperto-cuffie is si)
    )

    (question
        (id 34)
        (attribute ha-scheda-audio)
        (the-question "Hai bisogno che le cuffie abbiano una scheda audio o sistemi surround integrati?")
        (why "Se cerchi queste caratteristiche in un paio di cuffie mi aiuterai a scartarne molte altre e facilitare il mio lavoro.")
        (info "Delle cuffie con una scheda audio integrata o un sistema surround 7.1 sono adatta principalmente ai videogiocatori.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is si)
    )

    (question
        (id 35)
        (attribute microfono)
        (the-question "Hai necessita' quindi di avere un microfono e comandi integrati?")
        (why "Questa domanda e' fondamentale per filtrare le cuffie a mia disposizione in base a questa caratteristica.")
        (info "Cuffie adatte per il gaming hanno un microfono e comandi esterni decicati al controllo veloce di volume.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is si)
    )

    (question
        (id 36)
        (attribute tipo-cuffie)
        (the-question "Preferisci cuffie di tipo on-ear o di tipo over-ear?")
        (why "Le cuffie si dividono in due macro-categorie: on-ear e over-ear.")
        (info "Le on-ear comprendono tutte quelle cuffie che si poggiano sulle orecchie. Le over-ear invece che poggiarsi, avvolgono completamente le orecchie.")
        (priority MEDIUM)
        (allowed-values a b)
        (ans-mean on-ear over-ear)
        (precursors esperto-cuffie is si)
    )

    (question
        (id 37)
        (attribute range-freq-ampio-esp)
        (the-question "Vorresti un paio di cuffie con un range di frequenze ampio?")
        (why "Alcune cuffie ampliano il range coperto al fine di offrire una migliore resa sonora nella riproduzione di toni bassi, medi e alti.")
        (info "La risposta in frequenza denota l'intera gamma di frequenze sonore che un paio di cuffie e' in grado di riprodurre.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors esperto-cuffie is si)
    )

    (question
        (id 38)
        (attribute freq-basse-esp)
        (the-question "Vuoi enfatizzare frequenze basse e avere un suono pieno?")
        (why "Una risposta precisa a questa domanda mi permette di selezionare delle cuffie con una riproduzione ottima di bassi.")
        (info "Alcune cuffie sono caratterizzate dal saper riprodurre frequenze basse con qualita' maggiore rispetto ad altre.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors esperto-cuffie is si and range-freq-ampio-esp is no)
    )

    (question
        (id 39)
        (attribute freq-med-alte-esp)
        (the-question "Quindi hai bisogno di sentire maggiormente medi e alti?")
        (why "Una risposta precisa a questa domanda mi permette di selezionare delle cuffie con una riproduzione ottima di medi e alti.")
        (info "Alcune cuffie sono caratterizzate dal saper riprodurre frequenze medie e alte con qualita' maggiore rispetto ad altre.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors esperto-cuffie is si and freq-basse-esp is no)
    )

    (question
        (id 45)
        (attribute noise-cancelling-esp)
        (the-question "Acquisteresti un paio di cuffie con tecnologia Noise Cancelling attivo?")
        (why "Una risposta precisa a questa domanda mi permette di selezionare delle cuffie con un isolamento acustico ottimale.")
        (info "Le cuffie con noise cancelling sono cuffie capaci di ridurre i suoni ambientali indesiderati usando il controllo del rumore attivo.")
        (priority MEDIUM)
        (allowed-values s n)
        (ans-mean si no)
        (precursors esperto-cuffie is si)
    )

    (question
        (id 46)
        (attribute richiudibili-esp)
        (the-question "Hai bisogno di un paio di cuffie richiudibili?")
        (why "Una risposta precisa a questa domanda mi permette di selezionare delle cuffie con un alto livello di portatilita'.")
        (info "Per cuffie ripiegabili si intende modelli con padiglioni girevoli o ripiegavoli verso l'archetto.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is si)
    )

;domande cuffie non esperto

    (question
        (id 40)
        (attribute ambienti-rumorosi)
        (the-question "Pensi di utilizzare le cuffie in ambienti rumorosi?")
        (why "Sapere se il luogo di utilizzo e' rumoroso mi permette di capire che tipologia di apertura dovranno avere le cuffie.")
        (info "Esistono tre tipologie di cuffie: aperte, chiuse e semi-aperte. Questa caratteristica determina anche il grado di isolamento.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is no)
    )

    (question
        (id 41)
        (attribute lungo-ascolto)
        (the-question "Utilizzeresti le cuffie per lunghe sessioni d'ascolto?")
        (why "Sapere questa informazione mi serviera' per sapare che tipologia di cuffie consigliarti.")
        (info "Esistono due tipologie di cuffie: quello on-ear e quello over-ear. Le seconde sono consigliate per un uso prolungato.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is no)
    )

    (question
        (id 42)
        (attribute con-smartphone)
        (the-question "Le utilizzeresti principalmente con lo smartphone?")
        (why "Sapere il dispositivo al quale verranno collegate e' fondamentale per dare importanza ad alcuni aspetti tecnici.")
        (info "Alcune cuffie potrebbero non funzionare o non esprimere il meglio se non collegate al giusto apparecchio.")
        (priority MEDIUM)
        (allowed-values s n ns)
        (ans-mean si no "non so")
        (precursors esperto-cuffie is no)
    )

    (question
        (id 43)
        (attribute genere-musica-non-esp)
        (the-question "Che genere di musica ascolti prevalentemente?")
        (why "Il genere di musica e' una informazione fondamentale per dare importanza ad alcuni aspetti tecnici come il range di frequenza.")
        (info "Differenti generi musicali prediliscono alcuni suoni rispetto ad altri.")
        (priority MEDIUM)
        (allowed-values a b c)
        (ans-mean "Pop/Hip-Hop/Dance" "Rock/Indie/Alternative" "Jazz/Classica")
        (precursors esperto-cuffie is no)
    )




)	