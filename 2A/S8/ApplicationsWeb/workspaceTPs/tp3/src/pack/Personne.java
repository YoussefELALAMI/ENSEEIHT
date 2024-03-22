package pack;

import java.util.*;

import javax.persistence.*;

@Entity
public class Personne {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int id;
	String prenom;
	String nom;
	
	@OneToMany(mappedBy="proprietaire", fetch = FetchType.EAGER)
	Collection<Adresse> listeAdresses = new ArrayList<Adresse>();
	
	public Personne() {}
	
	public Personne(String prenom, String nom) {
		this.nom = nom;
		this.prenom = prenom;
	}
	
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}
	
	public void setNom(String nom) {
		this.nom = nom;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getPrenom() {
		return this.prenom;
	}
	
	public String getNom() {
		return this.nom;
	}
	
	public int getId() {
		return this.id;
	}
	
	public Collection<Adresse> getAdresse(){
		return this.listeAdresses;
	}
}
