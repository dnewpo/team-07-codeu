package com.google.codeu.servlets;

import com.google.gson.Gson;
import com.google.gson.JsonArray;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Scanner;

/**
 * Returns Boba data as a JSON array, e.g. [{"lat": 38.4404675, "lng": -122.7144313}]
 */
@WebServlet("/bayarea_boba_spots") //ufo-data
public class BobaDataServlet extends HttpServlet {

  private JsonArray bobaSightingArray; //ufoSightingArray

  @Override
  public void init() {
    bobaSightingArray = new JsonArray(); //ufoSightingArray
    Gson gson = new Gson();
    Scanner scanner = new Scanner(getServletContext().getResourceAsStream("/WEB-INF/bayarea_boba_spots.csv"));
    while(scanner.hasNextLine()) {
      String line = scanner.nextLine();
      String[] cells = line.split(",");

      double lat = Double.parseDouble(cells[0]);
      double lng = Double.parseDouble(cells[1]);

      bobaSightingArray.add(gson.toJsonTree(new BobaSighting(lat, lng)));
    }
    scanner.close();
  }

  @Override
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("application/json");
    response.getOutputStream().println(bobaSightingArray.toString());
  }

  // This class could be its own file if we needed it outside this servlet
  private static class BobaSighting{
    double lat;
    double lng;

    private BobaSighting(double lat, double lng) {
      this.lat = lat;
      this.lng = lng;
    }
  }
}
