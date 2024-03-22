package pack;

import java.util.*;

import javax.ejb.Singleton;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Singleton
public class Facade {
	
	@PersistenceContext
	private EntityManager em;
	
	//int indexP = 1;
	//int indexA = 1;
	
	
	//HashMap<Integer,Personne> personnes= new HashMap<Integer,Personne>();
	//HashMap<Integer,Adresse> adresses= new HashMap<Integer,Adresse>();
	
	public void ajoutPersonne(String nom, String prenom) {
		Personne p = new Personne(prenom,nom);
		//p.setId(indexP);
		// personnes.put(indexP, p);
		em.persist(p);
		//indexP ++;
	}
	public void ajoutAdresse(String rue, String ville) {
		Adresse a = new Adresse(rue,ville);
		//a.setId(indexA);
		// adresses.put(indexA, a);
		em.persist(a);
		//indexA ++;
	}
	public Collection<Personne> listePersonnes(){
		// return personnes.values();
		TypedQuery<Personne> req = em.createQuery("from Personne", Personne.class);
		return req.getResultList();
	}
	public Collection<Adresse> listeAdresses(){
		// return adresses.values();
		TypedQuery<Adresse> req = em.createQuery("from Adresse", Adresse.class);
		return req.getResultList();
	}
	public void associer(int personneId, int adresseId) {
		// Personne p = personnes.get(personneId);
		// Adresse a = adresses.get(adresseId);
		
		Personne p = em.find(Personne.class, personneId);
		Adresse a = em.find(Adresse.class, adresseId);		
		// em.persist(a);
		a.setProprietaire(p);
		em.persist(p);
	}
}
