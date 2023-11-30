// Time-stamp: <02 mai 2013 14:09 queinnec@enseeiht.fr>

/* Sens.java et Position.java : définition des constantes de sens et position d’un train. */

/** Sens de circulation d'un train */
public enum Sens {

    NS, SN; /* nord->sud et sud->nord */

    /** Sens inverse correspondant à ce sens. */
    public Sens inverse() {
        return (this == SN) ? NS : SN;
    }

    public Position loin() {
        return (this == SN) ? Position.LoinSud : Position.LoinNord;
    }

    public Position demande() {
        return (this == SN) ? Position.AttenteSud : Position.AttenteNord;
    }

    public Position dedans() {
        return (this == SN) ? Position.DedansSud : Position.DedansNord;
    }
}
