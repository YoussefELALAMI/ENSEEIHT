package pack;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Serv
 */
@WebServlet("/Serv")
public class Serv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	@EJB
	Facade facade;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Serv() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String op = request.getParameter("op");
		
		if(op==null) {
			request.getRequestDispatcher("index.html").forward(request, response);
			return;
		}
		if(op.equals("ajoutpersonne")) {
			String nom = request.getParameter("nom");
			String prenom = request.getParameter("prenom");
			facade.ajoutPersonne(nom, prenom);
			request.getRequestDispatcher("index.html").forward(request, response);
		}
		if(op.equals("ajoutadresse")) {
			String rue = request.getParameter("rue");
			String ville = request.getParameter("ville");
			facade.ajoutAdresse(rue, ville);
			request.getRequestDispatcher("index.html").forward(request, response);
		}
		if(op.equals("associer")) {
			request.setAttribute("listepersonnes", facade.listePersonnes());
			request.setAttribute("listeadresses", facade.listeAdresses());
			request.getRequestDispatcher("choix.jsp").forward(request, response);
		}
		if(op.equals("choix")) {
			String idpersonne = request.getParameter("idpersonne");
			String idadresse = request.getParameter("idadresse");
			facade.associer(Integer.parseInt(idpersonne), Integer.parseInt(idadresse));
			request.getRequestDispatcher("index.html").forward(request, response);
		}
		if(op.equals("lister")) {
			request.setAttribute("listepersonnes", facade.listePersonnes());
			request.getRequestDispatcher("liste.jsp").forward(request, response);
		}
		if(op.equals("retour")) {
			request.getRequestDispatcher("index.html").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
