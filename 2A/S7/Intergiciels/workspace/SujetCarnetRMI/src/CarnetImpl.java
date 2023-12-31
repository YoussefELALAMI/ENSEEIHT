import java.net.InetAddress;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;

public class CarnetImpl extends UnicastRemoteObject implements Carnet{

	HashMap<String, RFiche> listRFiche;
	String nom;
	
	public CarnetImpl() throws RemoteException {
		this.listRFiche = new HashMap<String, RFiche>();
	}

	@Override
	public void Ajouter(SFiche sf) throws RemoteException {
		this.listRFiche.put(sf.getNom(), new RFicheImpl(sf.getNom(),sf.getEmail()));	
	}

	@Override
	public RFiche Consulter(String n, boolean forward) throws RemoteException {
		return this.listRFiche.get(n);
	}
	
	public static void main(String args[]) {
		int port = 8000;
		try {
			// Launching the naming service – rmiregistry – within the JVM
			Registry registry = LocateRegistry.createRegistry(port);
			// Create an instance of the server object
			Carnet c = new CarnetImpl();
			String URL = "//localhost:"+
					port+"/my_server";
			Naming.rebind(URL, c);
		} catch (Exception exc) {
			exc.printStackTrace();
		}
	}
}