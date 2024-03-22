package pack;

import java.util.*;

import javax.persistence.*;

@Entity
public class Adresse {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int id;
	String rue;
	String ville;
	
	@OneToOne
	Personne proprietaire = null;
	
	public Adresse() {}

	public void setProprietaire(Personne proprietaire) {
		this.proprietaire = proprietaire;
	}
	
	public Personne getProprietaire() {
		return this.proprietaire;
	}

	public Adresse(String rue, String ville){
		this.rue = rue;
		this.ville = ville;
	}
	
	public void setRue(String rue) {
		this.rue = rue;
	}
	
	public void setVille(String Ville) {
		this.ville = ville;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public String getRue() {
		return this.rue;
	}
	
	public String getVille() {
		return this.ville;
	}
	
	public int getId() {
		return this.id;
	}
}
