package pack;

public class Adresse {
	
	int id;
	String rue;
	String ville;
	
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
