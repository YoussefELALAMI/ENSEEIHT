// Time-stamp: <06 jui 2023 11:59 Philippe Queinnec>

/* VoieUniqueCondition.java et VoieUniqueAutomate.java : squelettes pour deux implantations de cette interface. */

import CSP.*;

/** Réalisation de la voie unique avec des canaux JCSP. */
/* Version avec condition d'acceptation */
public class VoieUniqueCondition implements VoieUnique {

    enum ChannelId { EntrerNS, EntrerSN, Sortir };
    
    private Channel<ChannelId> entrerNS;
    private Channel<ChannelId> entrerSN;
    private Channel<ChannelId> sortir;
    
    public VoieUniqueCondition() {
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

    public String nomStrategie () {
        return "Condition";
    }

    /****************************************************************/
    class Scheduler implements Runnable {
        private int nbTrainsSN = 0;
        private int nbTrainsNS = 0;
        private boolean sensSN = false;
        private boolean sensNS = false;
        public void run() {
            var gentrersn = new GuardedChannel<>(entrerSN, () -> ((nbTrainsNS == 0) && (nbTrainsNS < 3) && !(sensSN)));
            var gentrerns = new GuardedChannel<>(entrerNS, () -> ((nbTrainsSN == 0) && (nbTrainsSN < 3) && !(sensNS)));
            var gsortir = new GuardedChannel<>(sortir, Predicate::True);
            var alt = new Alternative<>(gentrersn, gentrerns, gsortir);
            while (true) {
                switch (alt.select()) {
                    case EntrerSN:
                        if (nbTrainsSN < 3) {
                            entrerSN.read();
                            nbTrainsSN++;
                            break;
                        } else {
                            break;
                        }

                    case EntrerNS:
                        if (nbTrainsNS < 3) {
                            entrerNS.read();
                            nbTrainsNS++;
                            break; 
                        } else {
                            break;
                        }
                        
                    
                    case Sortir:
                        sortir.read();
                        if (nbTrainsNS > 0){
                            nbTrainsNS--;
                        } else {
                            nbTrainsSN--;
                        }
                }
            }
        }
    } // class Scheduler
}