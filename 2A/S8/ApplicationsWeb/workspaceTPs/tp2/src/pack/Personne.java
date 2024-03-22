package pack;

import java.util.*;

public class Personne {
	
	int id;
	String prenom;
	String nom;
	Collection<Adresse> listeAdresses = new ArrayList<Adresse>();
	
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
