// Time-stamp: <28 oct 2022 09:24 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioRedacteur implements LectRed
{

    public LectRed_PrioRedacteur() {
    }

    public void demanderLecture() throws InterruptedException {
    }

    public void terminerLecture() throws InterruptedException {
    }

    public void demanderEcriture() throws InterruptedException {
    }

    public void terminerEcriture() throws InterruptedException {
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Rédacteurs.";
    }
}
