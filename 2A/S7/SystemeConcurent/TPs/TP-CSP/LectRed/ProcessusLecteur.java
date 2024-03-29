// Time-stamp: <28 oct 2022 10:24 queinnec@enseeiht.fr>

import Synchro.Simulateur;
import Synchro.ProcId;

public class ProcessusLecteur extends Thread {
    private int no;
    private LectRed lr;
    private Simulateur simu;
    private IHMLectRed ihm;

    public ProcessusLecteur(LectRed lr, Simulateur simu, IHMLectRed ihm) {
        super (simu.getThreadGroup(), "");
    	this.no = no;
    	this.lr = lr;
        this.simu = simu;
        this.ihm = ihm;
    }

    public void run() {
        setName("Lecteur-"+ProcId.getSelf());
        ihm.ajouterLecteur();
        try {
            simu.sleep(0, Main.MaxDelayLRien/2);
            while (true) {
                // demande à lire
                ihm.changerEtat(LectRedEtat.Lecteur_Demande);
                lr.demanderLecture();
                ihm.changerEtat(LectRedEtat.Lecteur_Lit);
                
                // utilise
                simu.sleep(Main.MinDelayLit, Main.MaxDelayLit);
                
                lr.terminerLecture();
                ihm.changerEtat(LectRedEtat.Lecteur_Rien);
                
                // pense
                simu.sleep(Main.MinDelayLRien, Main.MaxDelayLRien);
            }
        } catch (Synchro.Suicide e) {
            // nothing
        } catch (InterruptedException e2) {
            // nothing
        } finally {
            ihm.enlever();
        }
    }
}

