import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Map;

public class CarnetImpl extends UnicastRemoteObject implements Carnet {

    private Map<String, RFiche> carnet = new HashMap<String, RFiche>();
    private int i;
    private String nom;

    public CarnetImpl(int num) throws RemoteException {
        this.i = num;
        this.nom = "Carnet" + i;
    }

    public String getNom() throws RemoteException {
        return this.nom;
    }

    @Override
    public void Ajouter(SFiche sf) throws RemoteException {
        RFiche rf = new RFicheImpl(sf.getNom(), sf.getEmail());
        carnet.put(rf.getNom(), rf);
        System.out.println("Ajout réussi de " + rf.getNom());
    }

    @Override
    public RFiche Consulter(String n, boolean forward) throws RemoteException {
        RFiche rf = carnet.get(n);
        if (rf == null && forward) {
            try {
                System.out.println("forward de la demande");
                int nbAutreCarnet;
                if (i == 1) {
                    nbAutreCarnet = 2;
                } else {
                    nbAutreCarnet = 1;
                }
                Carnet c = (Carnet) Naming.lookup("//localhost:4000/Carnet" + nbAutreCarnet);
                rf = c.Consulter(n, false);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("pas de forward");
        }
        return rf;
    }

    public static void main(String args[]) {
        try {
            int nbCarnet = Integer.parseInt(args[0]);
            Carnet c = new CarnetImpl(nbCarnet);
            try {
                Registry registry = LocateRegistry.createRegistry(4000);
            } catch (Exception ex) {
                System.out.println("registry déjà créé");
            }
            Naming.rebind("//localhost:4000/Carnet" + nbCarnet, c);
            System.out.println("Carnet " + nbCarnet + " bound in registry");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
