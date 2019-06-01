package com.google.codeu.servlets;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Handles fetching all users for the community page.
 */
@WebServlet("/user-list")
public class UserListServlet extends HttpServlet {

  @Override
  public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    response.getOutputStream().println("this will be my user list");
  }

  public Set<String> getUsers(){
      Set<String> users = new HashSet<>();
      Query query = new Query("Message");
      PreparedQuery results = datastore.prepare(query);
      for(Entity entity : results.asIterable()) {
          users.add((String) entity.getProperty("user"));
      }
      return users;
  }

 // System.out.println(getUsers());
}
