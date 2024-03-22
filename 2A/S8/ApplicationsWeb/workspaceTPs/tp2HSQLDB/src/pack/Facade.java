package pack;

import java.sql.*;
import java.util.*;

import javax.annotation.PostConstruct;
import javax.ejb.Singleton;

@Singleton
public class Facade {
	
	int indexP = 1;
	int indexA = 1;
	
	HashMap<Integer,Personne> personnes= new HashMap<Integer,Personne>();
	HashMap<Integer,Adresse> adresses= new HashMap<Integer,Adresse>();
	
	Connection con;
	
	@PostConstruct
	public void init() {
		try {
			String db_url = "jdbc:hsqldb:hsql://localhost/xdb";
			String db_user = "sa";
			Class.forName("org.hsqldb.jdbcDriver");
			con = DriverManager.getConnection(db_url, db_user, null);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	

	public void ajoutPersonne(String nom, String prenom) {
		try {
			PreparedStatement ps;
			ps = con.prepareStatement("INSERT INTO Personne VALUES(?,?,?)");
			ps.setNull(1, Types.INTEGER);
			ps.setString(2, nom);
			ps.setString(3, prenom);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		//Personne p = new Personne(prenom,nom);
		//p.setId(indexP);
		//personnes.put(indexP, p);
		//indexP ++;
	}
	public void ajoutAdresse(String rue, String ville) {
		try {
			PreparedStatement ps;
			ps = con.prepareStatement("INSERT INTO Adresse VALUES(?,?,?,?)");
			ps.setNull(1, Types.INTEGER);
			ps.setString(2, rue);
			ps.setString(3, ville);
			ps.setNull(4, Types.INTEGER);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		//Adresse a = new Adresse(rue,ville);
		//a.setId(indexA);
		//adresses.put(indexA, a);
		//indexA ++;
	}
	public Collection<Personne> listePersonnes(){
		Statement stmt;
		Collection<Personne> listeP = new ArrayList<Personne>();
		try {
			stmt = con.createStatement();
			ResultSet res = stmt.executeQuery("SELECT * FROM Personne");
			while(res.next()) {
						
				int id = res.getInt("id");
				String nom = res.getString("nom");
				String prenom = res.getString("prenom");
				Personne p = new Personne(prenom, nom);
				p.setId(id);
				listeP.add(p);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return listeP;
		// return personnes.values();
	}
	public Collection<Adresse> listeAdresses(){
		Statement stmt;
		Collection<Adresse> listeA = new ArrayList<Adresse>();
		try {
			stmt = con.createStatement();
			ResultSet res = stmt.executeQuery("SELECT * FROM Adresse");
			while(res.next()) {
						
				int id = res.getInt("id");
				String rue = res.getString("rue");
				String ville = res.getString("ville");
				Adresse a = new Adresse(rue, ville);
				a.setId(id);
				listeA.add(a);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//return adresses.values();
		return listeA;
	}
	
	/* Méthode pour re-associer les personnes avec leurs adresses dans la base de donnees car on n'a pas Collection dans BD*/
	public Collection<Personne> associerPersonnesAvecAdresses(){
		Collection<Personne> listeP = listePersonnes();
		int id;
		String rue;
		String ville;
		Adresse a;
		for (Personne p : listeP) {
			try {
				PreparedStatement ps;
				ps = con.prepareStatement("SELECT * FROM Adresse WHERE personneid=?");
				ps.setInt(1, p.getId());
				ResultSet res = ps.executeQuery();
				while(res.next()) {
					id = res.getInt("id");
					rue = res.getString("rue");
					ville = res.getString("ville");
					a = new Adresse(rue, ville);
					a.setId(id);
					p.addAdresse(a);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return listeP;
	}
	
	public void associer(int personneId, int adresseId) {
		PreparedStatement ps;
		try {
			ps = con.prepareStatement("UPDATE Adresse SET personneid=? WHERE id=?");
			ps.setInt(1, personneId);
			ps.setInt(2, adresseId);
			ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// Personne p = personnes.get(personneId);
		// Adresse a = adresses.get(adresseId);
		// p.getAdresse().add(a);
	}
}
