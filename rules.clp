(deffacts RULES::regole

    (def-rule
        (if ha-cuffie is no)
        (then neofita is si))

    (def-rule
        (if ha-cuffie is si)
        (then neofita is no))

    (def-rule
        (if uso-sportivo is si)
        (then impermeabilita is si with certainty 70
        and impermeabilita is no with certainty 30))

    (def-rule
        (if uso-sportivo is no)
        (then impermeabilita is no with certainty 70
        and impermeabilita is si with certainty 30))    

    (def-rule
        (if materiali-top is si)
        (then materiali is premium with certainty 80
        and materiali is plastica with certainty 30))

    (def-rule
        (if materiali-top is no)
        (then materiali is premium with certainty 30
        and materiali is plastica with certainty 80))

    (def-rule
        (if brand-famoso is si)
        (then brand is Beats
        and brand is Sennheiser with certainty 80
        and brand is Pioneer with certainty 70
        and brand is AKG with certainty 80
        and brand is Apple
        and brand is Samsung
        and brand is Sony with certainty 90
        and brand is Bose with certainty 85
        and brand is Jabra with certainty 35
        and brand is Bowers_Wilkins with certainty 80
        and brand is Huawei with certainty 80
        and brand is Marley with certainty 70
        and brand is Marshall with certainty 75
        and brand is Shure with certainty 75
        and brand is Beyerdynamic with certainty 85
        and brand is Urbanears with certainty 60))

    (def-rule
        (if brand-famoso is no)
        (then brand is Aukey
        and brand is MyCarbon with certainty 70
        and brand is TaoTronics with certainty 85
        and brand is Jabra with certainty 90
        and brand is Bluedio
        and brand is Sony with certainty 50
        and brand is AKG with certainty 40
        and brand is Pioneer with certainty 30
        and brand is Yianerm with certainty 80
        and brand is MAS-CARNEY with certainty 75
        and brand is Marley with certainty 40
        and brand is Muzili with certainty 75
        and brand is Salpie with certainty 70
        and brand is Charlemain with certainty 70
        and brand is Yuhao with certainty 70
        and brand is Urbanears with certainty 60
        and brand is LinkWitz with certainty 60
        and brand is LOBKIN with certainty 55
        and brand is MiluoTech with certainty 60 
        and brand is Beexcellent with certainty 65
        and brand is August with certainty 75
        and brand is marsboy with certainty 70
        and brand is Shure with certainty 60
        and brand is barsone with certainty 60
        and brand is MiracleLesoul with certainty 65
        and brand is Jokitech with certainty 60
        and brand is COWIN with certainty 80
        and brand is Marshall with certainty 60))

    (def-rule
        (if auricolari-cuffie is c)
        (then headphone-type is cuffie))

    (def-rule
        (if fascia-prezzo-auricolari is a)
        (then fascia-prezzo is bassa
        and fascia-prezzo is media with certainty 40))

    (def-rule
        (if fascia-prezzo-auricolari is b)
        (then fascia-prezzo is media
        and fascia-prezzo is bassa with certainty 20
        and fascia-prezzo is alta with certainty 20))

    (def-rule
        (if fascia-prezzo-auricolari is c)
        (then fascia-prezzo is alta
        and fascia-prezzo is media with certainty 30))

    (def-rule
        (if auricolari-cuffie is a and auricolari-bluetooth is si)
        (then headphone-type is auricolari-w))

    (def-rule
        (if auricolari-cuffie is a and auricolari-bluetooth is no)
        (then headphone-type is auricolari))

    (def-rule
        (if buona-durata is si)
        (then lunga-durata is si))

    (def-rule
        (if senza-cavi is si)
        (then cofanetto is si with certainty 80
        and cavo is no
        and archetto is no))

    (def-rule
        (if senza-cavi is no and sostegno-archetto is si)
        (then cofanetto is no
        and cavo is no
        and archetto is si with certainty 80
        and cavo is si with certainty 30))

    (def-rule
        (if senza-cavi is no and sostegno-archetto is no)
        (then cofanetto is no
        and cavo is si with certainty 60
        and archetto is no
        and cofanetto is si with certainty 30))   

    (def-rule
        (if senza-cavi is no and sostegno-archetto is si and lunga-durata is si)
        (then cofanetto is no
        and cavo is no
        and archetto is si with certainty 80
        and cavo is si with certainty 30
        and cofanetto is si with certainty 30))

    (def-rule
        (if senza-cavi is si and lunga-durata is si)
        (then cofanetto is si with certainty 80
        and cavo is no
        and archetto is no
        and cavo is si with certainty 30
        and archetto is si with certainty 30))

    (def-rule       
        (if utilizzo-mobilita is si)
        (then comandi is si with certainty 90))

    (def-rule       
        (if utilizzo-mobilita is no)
        (then comandi is no with certainty 90
        and comandi is si with certainty 60))


    (def-rule
        (if problemi-orecchio is si)
        (then tipo is classico with certainty 90))

    (def-rule
        (if isolamento-auricolari is si)
        (then tipo is in-ear with certainty 70))

    (def-rule
        (if isolamento-auricolari is no)
        (then tipo is in-ear with certainty 40
        and tipo is classico with certainty 70))


    (def-rule
        (if genere-musicale-auricolari is a)
        (then buoni-bassi is si with certainty 80
        and alta-fedelta is no with certainty 60
        and alta-fedelta is si with certainty 20
        and buoni-bassi is no with certainty 15))

    (def-rule
        (if genere-musicale-auricolari is b)
        (then buoni-bassi is si with certainty 80
        and alta-fedelta is si with certainty 80
        and buoni-bassi is no with certainty 40
        and alta fedelta is no with certainty 20)) 

    (def-rule
        (if genere-musicale-auricolari is c)
        (then alta-fedelta is si with certainty 80
        and buoni-passi is no with certainty 80
        and buoni-bassi is si with certainty 20
        and alta-fedelta is no with certainty 10))

    (def-rule
        (if freq-basse-aur is si)
        (then buoni-bassi is si with certainty 75
        and buoni-bassi is no with certainty 25))

    (def-rule
        (if freq-basse-aur is no)
        (then buoni-bassi is no with certainty 75
        and buoni-bassi is si with certainty 25))

    (def-rule
        (if buona-fedelta is si)
        (then alta-fedelta is si with certainty 75
        and alta-fedelta is no with certainty 25))

    (def-rule
        (if buona-fedelta is no)
        (then alta-fedelta is no with certainty 75
        and alta-fedelta is si with certainty 25))     


    ;regole cuffie
    (def-rule
        (if uso-professionale is si)
        (then wired is si))

    (def-rule
        (if uso-professionale is si)
        (then comandi is no
        and comandi is si with certainty 30))

    (def-rule
        (if uso-professionale is si)
        (then scheda-audio is no))

    (def-rule
        (if uso-professionale is si)
        (then fascia-prezzo-cuffie is media with certainty 60
        and fascia-prezzo-cuffie is alta with certainty 75))

    (def-rule
        (if uso-professionale is no)
        (then richiudibili is si with certainty 70
        and richiudibili is no with certainty 70))    

    (def-rule
        (if cuffie-wireless is si)
        (then wired is no))    

    (def-rule
        (if cuffie-wireless is no)
        (then wired is si
        and wired is no with certainty 30))


    ;regole per dj
    (def-rule
        (if dj is no)
        (then richiudibili is no with certainty 70
        and richiudibili is si with certainty 40))

    (def-rule 
        (if dj is si)
        (then apertura is chiusa with certainty 90
        and apertura is semiaperta with certainty 50))

    (def-rule
        (if richiudibilita is si)
        (then richiudibili is si
        and richiudibili is no with 30))

    (def-rule
        (if richiudibilita is no)
        (then richiudibili is no
        and richiudibili is si with 30))  

    (def-rule
        (if dj is si)
        (then impedenza is alta with certainty 80
        and impedenza is bassa with certainty 50))

    (def-rule
        (if dj is si)
        (then sensibilita is alta))

    (def-rule
        (if dj is si)
        (then noise-cancelling-attivo is no with certainty 90
        and noise-cancelling-attivo is si with certainty 20))

    (def-rule
        (if dj is si)
        (then tipo is on-ear with certainty 90
        and tipo is over-ear with certainty 45))


    ;regole per radiofonico
    (def-rule
        (if radiofonico is si)
        (then tipo is over-ear with certainty 95
        and tipo is on-ear with certainty 40))

    (def-rule
        (if radiofonico is si)
        (then apertura is aperta with certainty 90
        and apertura is semiaperta with certainty 70))

    (def-rule
        (if radiofonico is si)
        (then noise-cancelling-attivo is no with certainty 80
        and noise-cancelling-attivo is si with certainty 30))

    (def-rule
        (if radiofonico is si)
        (then impedenza is alta with certainty 80
        and impedenza is bassa with certainty 40))

    (def-rule
        (if radiofonico is si)
        (then sensibilita is media with certainty 80
        and sensibilita is bassa with certainty 70))

    (def-rule
        (if musicista is si)
        (then impedenza is bassa))

    (def-rule
        (if musicista is si)
        (then tipo is over-ear with certainty 70
        and tipo is on-ear with certainty 30))

    (def-rule
        (if tipologia-strumento is a)
        (then sensibilita is alta with certainty 90
        and sensibilita is media with certainty 70
        and apertura is semiaperta
        and apertura is aperta with certainty 55))

    (def-rule
        (if tipologia-strumento is b)
        (then sensibilita is alta with certainty 90
        and sensibilita is media with certainty 70
        and apertura is chiusa
        and apertura is semiaperta with certainty 60))

    (def-rule
        (if tipologia-strumento is c)
        (then sensibilita is bassa with certainty 90
        and sensibilita is media with certainty 70
        and apertura is aperta))

    (def-rule
        (if musicista is no)
        (then tipo is on-ear with certainty 60
        and tipo is over-ear with certainty 60
        and impedenza is bassa with certainty 70
        and impedenza is alta with certainty 30
        and sensibilita is alta with certainty 70
        and sensibilita is media with certainty 50))

    (def-rule 
        (if musicista is no and ambienti-rumorosi-pro is no)
        (then apertura is aperta with certainty 65
        and apertura is semiaperta with certainty 65))

    (def-rule 
        (if musicista is no and ambienti-rumorosi-pro is si)
        (then apertura is chiusa with certainty 80))

    (def-rule
        (if range-freq-ampio is si)
        (then range-freq is ampio
        and range-freq is medio with certainty 55))

    (def-rule
        (if freq-basse is si)
        (then range-freq is basso))

    (def-rule
        (if freq-med-alt is si)
        (then range-freq is alto with certainty 90
        and range-freq is medio with certainty 70))

    (def-rule
        (if freq-med-alt is no)
        (then range-freq is alto with certainty 50
        and range-freq is medio with certainty 50
        and range-freq is basso with certainty 50))                         

    (def-rule
        (if noise-cancelling-attivo is si)
        (then noise-cancelling is si with certainty 90
        and noise-cancelling is no with certainty 20))

    (def-rule
        (if noise-cancelling-attivo is no)
        (then noise-cancelling is no with certainty 90
        and noise-cancelling is si with certainty 20))

    (def-rule
        (if ambienti-rumorosi-pro is no)
        (then apertura is aperta with certainty 90
        and apertura is semiaperta with certainty 80
        and apertura is chiusa with certainty 50))

    (def-rule
        (if ambienti-rumorosi-pro is si)
        (then apertura is chiusa with certainty 90
        and apertura is semiaperta with certainty 40))


    ;regole uso non professionale
    (def-rule
        (if fascia-prezzo-cuffia is a)
        (then fascia-prezzo-cuffie is bassa
        and fascia-prezzo-cuffie is media with certainty 50))

    (def-rule
        (if fascia-prezzo-cuffia is b)
        (then fascia-prezzo-cuffie is media
        and fascia-prezzo-cuffie is alta with certainty 20
        and fascia-prezzo-cuffie is bassa with certainty 20))

    (def-rule
        (if fascia-prezzo-cuffia is c)
        (then fascia-prezzo-cuffie is alta
        and fascia-prezzo-cuffie is media with certainty 50))

    (def-rule
        (if bassa-impedenza is si)
        (then impedenza is bassa))

    (def-rule
        (if alta-impedenza is si)
        (then impedenza is alta))

    (def-rule
        (if alta-impedenza is no)
        (then impedenza is alta with certainty 50
        and impedenza is bassa with certainty 50))

    (def-rule 
        (if apertura-cuffia is a)
        (then apertura is aperta))

    (def-rule 
        (if apertura-cuffia is s)
        (then apertura is semiaperta))

    (def-rule 
        (if apertura-cuffia is c)
        (then apertura is chiusa))

    (def-rule
        (if sensibilita-cuffie is b)
        (then sensibilita is bassa
        and sensibilita is media with certainty 30))

    (def-rule
        (if sensibilita-cuffie is m)
        (then sensibilita is media))

    (def-rule
        (if sensibilita-cuffie is a)
        (then sensibilita is alta
        and sensibilita is media with certainty 30))

    (def-rule
        (if ha-scheda-audio is si)
        (then scheda-audio is si))

    (def-rule
        (if ha-scheda-audio is no)
        (then scheda-audio is no))

    (def-rule
        (if microfono is si)
        (then comandi is si))
            
    (def-rule
        (if microfono is no)
        (then comandi is no))

    (def-rule
        (if tipo-cuffie is a)
        (then tipo is on-ear))

    (def-rule
        (if tipo-cuffie is b)
        (then tipo is over-ear))

    (def-rule
        (if range-freq-ampio-esp is si)
        (then range-freq is ampio))

    (def-rule
        (if freq-basse-esp is si)
        (then range-freq is basso))

    (def-rule
        (if freq-med-alte-esp is si)
        (then range-freq is alto))

    (def-rule
        (if freq-med-alte-esp is no)
        (then range-freq is medio))

    (def-rule
        (if noise-cancelling-esp is si)
        (then noise-cancelling is si))

    (def-rule
        (if noise-cancelling-esp is no)
        (then noise-cancelling is no))

    (def-rule
        (if richiudibili-esp is si)
        (then richiudibili is si
        and richiudibili is no with certainty 25))

    (def-rule
        (if richiudibili-esp is no)
        (then richiudibili is no
        and richiudibili is si with certainty 25))

    ;regole non esperto
    (def-rule
        (if ambienti-rumorosi is si)
        (then apertura is chiusa
        and apertura is semiaperta with certainty 50
        and sensibilita is alta
        and sensibilita is media with certainty 50
        and noise-cancelling is si with certainty 90
        and noise-cancelling is no with certainty 60))

    (def-rule
        (if ambienti-rumorosi is no)
        (then apertura is aperta
        and apertura is semiaperta with certainty 50
        and sensibilita is media
        and sensibilita is bassa with certainty 50
        and noise-cancelling is no))

    (def-rule
        (if lungo-ascolto is si)
        (then tipo is over-ear
        and tipo is on-ear with certainty 30))

    (def-rule
        (if lungo-ascolto is no)
        (then tipo is on-ear
        and tipo is over-ear with certainty 30))

    (def-rule
        (if con-smartphone is si)
        (then comandi is si
        and richiudibili is si
        and richiudibili is no with certainty 70
        and impedenza is bassa
        and scheda-audio is no))

    (def-rule
        (if con-smartphone is no)
        (then comandi is no
        and comandi is si with certainty 30
        and richiudibili is no
        and richiudibili is si with certainty 40
        and impedenza is bassa with certainty 90
        and impedenza is alta with certainty 70
        and scheda-audio is si with certainty 20
        and scheda-audio is no with certainty 90))

    (def-rule 
        (if genere-musica-non-esp is a)
        (then range-freq is basso
        and range-freq is medio with certainty 60))

    (def-rule
        (if genere-musica-non-esp is b)
        (then range-freq is alto
        and range-freq is medio with certainty 60))

    (def-rule
        (if genere-musica-non-esp is c)
        (then range-freq is ampio
        and range-freq is medio with certainty 60))
)    
