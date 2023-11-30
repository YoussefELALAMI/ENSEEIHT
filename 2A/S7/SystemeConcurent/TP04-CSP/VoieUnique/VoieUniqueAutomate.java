// Time-stamp: <06 jui 2023 11:58 Philippe Queinnec>

/* VoieUniqueCondition.java et VoieUniqueAutomate.java : squelettes pour deux implantations de cette interface. */


import CSP.*;

/** Réalisation de la voie unique avec des canaux JCSP. */
/* Version par automate d'états */
public class VoieUniqueAutomate implements VoieUnique {

    enum ChannelId { EntrerNS, EntrerSN, Sortir };
    
    private Channel<ChannelId> entrerNS;
    private Channel<ChannelId> entrerSN;
    private Channel<ChannelId> sortir;
    
    public VoieUniqueAutomate() {
        this.entrerNS = new Channel<>(ChannelId.EntrerNS);
        this.entrerSN = new Channel<>(ChannelId.EntrerSN);
        this.sortir = new Channel<>(ChannelId.Sortir);
        (new Thread(new Scheduler())).start();
    }

    public void entrer(Sens sens) {
        System.out.println("In  entrer " + sens);
        switch (sens) {
          case NS:
            entrerNS.write(true);
            break;
          case SN:
            entrerSN.write(true);
            break;
        }
        System.out.println("Out entrer " + sens);
    }

    public void sortir(Sens sens) {
        System.out.println("In  sortir " + sens);
        sortir.write(true);
        System.out.println("Out sortir " + sens);
    }

    public String nomStrategie() {
        return "Automate";
    }

    /****************************************************************/

    enum Etat { Libre, sensSN, sensNS};
    class Scheduler implements Runnable {
        private Etat etat = Etat.Libre;
        private int nbTrains;
        public void run() {
            var altLibre = new Alternative<>(entrerSN, entrerNS);
            var altEnterSN = new Alternative<>(entrerSN, sortir);
            var altEnterNS = new Alternative<>(entrerNS, sortir);
            while (true) {
                if (etat == Etat.Libre){
                    switch (altLibre.select()) {
                        case EntrerSN:
                            entrerSN.read();
                            etat = Etat.sensSN;
                            nbTrains = 1;
                            break;

                        case EntrerNS:
                            entrerNS.read();
                            etat = Etat.sensNS;
                            nbTrains = 1;
                            break;
                    }
                }else if (etat == Etat.sensSN){
                    switch (altEnterSN.select()) {
                        case EntrerSN:
                            entrerSN.read();
                            nbTrains++;
                            break;

                        case Sortir:
                            sortir.read();
                            nbTrains--;
                            if (nbTrains == 0) {
                                etat = Etat.Libre;
                            }
                            break;
                    }
                } else {
                    switch (altEnterNS.select()) {
                        case EntrerNS:
                            entrerNS.read();
                            nbTrains++;
                            break;

                        case Sortir:
                            sortir.read();
                            nbTrains--;
                            if (nbTrains == 0) {
                                etat = Etat.Libre;
                            }
                            break;
                    }
                }
            }
        }
    } // class Scheduler
}

