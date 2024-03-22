package pack;

import java.util.*;

import javax.ejb.Singleton;

@Singleton
public class Facade {
	
	int indexP = 1;
	int indexA = 1;
	
	HashMap<Integer,Personne> personnes= new HashMap<Integer,Personne>();
	HashMap<Integer,Adresse> adresses= new HashMap<Integer,Adresse>();
	
	public void ajoutPersonne(String nom, String prenom) {
		Personne p = new Personne(prenom,nom);
		p.setId(indexP);
		personnes.put(indexP, p);
		indexP ++;
	}
	public void ajoutAdresse(String rue, String ville) {
		Adresse a = new Adresse(rue,ville);
		a.setId(indexA);
		adresses.put(indexA, a);
		indexA ++;
	}
	public Collection<Personne> listePersonnes(){
		return personnes.values();
	}
	public Collection<Adresse> listeAdresses(){
		return adresses.values();
	}
	public void associer(int personneId, int adresseId) {
		Personne p = personnes.get(personneId);
		Adresse a = adresses.get(adresseId);
		p.getAdresse().add(a);
	}
}
