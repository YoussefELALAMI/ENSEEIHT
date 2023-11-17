import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;

public class RFicheImpl extends UnicastRemoteObject implements RFiche {

	private String Nom;
	private String Email;
	
	RFicheImpl(String Nom, String Email) throws RemoteException {
		this.Nom = Nom;
		this.Email = Email;
	}

	@Override
	public String getNom() {
		return this.Nom;
	}

	@Override
	public String getEmail() {
		return this.Email;
	}
	
}