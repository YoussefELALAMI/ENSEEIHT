package pack;

import javax.persistence.*;

@Entity
public class Adresse {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	int id;
	String rue;
	String ville;
	
	@ManyToOne
	Personne proprietaire;
	
	public Adresse() {}
	
	public Personne getProprietaire() {
		return proprietaire;
	}

	public void setProprietaire(Personne proprietaire) {
		this.proprietaire = proprietaire;
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
