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
	
	public void ajoutPersonne(String nom, String prenom) {
		Personne p = new Personne(prenom,nom);
		em.persist(p);
	}
	
	public void ajoutAdresse(String rue, String ville) {
		Adresse a = new Adresse(rue,ville);
		em.persist(a);
	}
	
	public Collection<Personne> listePersonnes(){
		TypedQuery<Personne> req = em.createQuery("from Personne", Personne.class);
		return req.getResultList();
	}
	
	public Collection<Adresse> listeAdresses(){
		TypedQuery<Adresse> req = em.createQuery("from Adresse", Adresse.class);
		return req.getResultList();
	}
	
	public void associer(int personneId, int adresseId) {
		Personne p = em.find(Personne.class, personneId);
		Adresse a = em.find(Adresse.class, adresseId);
		Adresse old = p.getAdresse();
		if(old!=null) {
			old.setProprietaire(null);
		}
		a.setProprietaire(p);
		
		
	}
}
