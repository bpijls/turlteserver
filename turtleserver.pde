import processing.net.*;
import java.net.InetAddress;


String HTTP_GET_REQUEST = "GET /";
String HTTP_HEADER = "HTTP/1.0 200 OK\r\nContent-Type: text/html\r\nAccess-Control-Allow-Origin: *\r\n\r\n";

String ip;
InetAddress inet;    

String ddnsLink = "turlte.ddns.net";
Server server;
Client client;
String input;
int port = 8008;
AssetManager assetManager;
HashMap<String, Turtle> turtles = new HashMap();
Turtle currentTurtle;

StringDict httpHeaders;
StringDict getParameters;
StringDict params = new StringDict();

void setup() 
{   
  fullScreen();
  server = new Server(this, port); // start server on http-alt

  assetManager = new AssetManager();

  params.set("x", "absolute x-coordinate");
  params.set("y", "absolute y-coordinate");
  params.set("r", "line color red component (0-255)");
  params.set("g", "line color green component (0-255)");
  params.set("b", "line color blue component (0-255)");
  params.set("w", "line width (0-200)");
  params.set("u", "Show \"UI\" (true or false)");
  params.set("name", "turtle name");
  params.set("h", "show help");

  String dnsUpdateAddress = "dynupdate.no-ip.com",
    dnsUpdateURL = "/nic/update?hostname=tURLte.ddns.net&myip="+ip;
    
  Client client = new Client(this, dnsUpdateAddress, 80);
  client.write("GET " + dnsUpdateURL +" HTTP/1.0\r\n"); // Use the HTTP "GET" command to ask for a Web page
  client.write("\r\n");
  delay(1000);
  while (client.available() > 0) { // If there's incoming data from the client...
    String data = client.readString(); // ...then grab it and print it
    println(data);
  }
}

void draw() 
{    
  // Receive data from client
  client = server.available();
  if (client != null) {
    input = client.readString();      

    String errorMessage = "";
    String headers = input;
    StringDict httpHeaders = parseHTTPHeaders(headers);
    StringDict getParameters = parseParameters(httpHeaders.get("GET"));

    if (input.indexOf(HTTP_GET_REQUEST) == 0) // starts with ...
    {
      client.write(HTTP_HEADER);  // answer that we're ok with the request and are gonna send html
      try {
        String hostName = client.ip();

        if (!turtles.containsKey(hostName))
          turtles.put(hostName, new Turtle(hostName));

        currentTurtle = turtles.get(hostName);
        currentTurtle.parseCommands(getParameters);
      }
      catch(Exception e) {
        errorMessage = e.toString();
      }

      //      // some html
      if (currentTurtle.showHelp) {
        client.write("<!DOCTYPE html><html><head><title>HTTP Turtle</title></head>"
          +"<style> table { border-collapse: collapse; border: 1px solid #000000}</style>"
          +"<body>");
        client.write(h3("Turtle Graphics Using HTTP"));
        client.write(h3("Possible GET commands") + table(params));
        client.write(h3("HTTP Request Headers") + table(httpHeaders));
        client.write(h3("HTTP GET Parameters") + table(getParameters));

        if (currentTurtle.showUI) 
          client.write(h3("\"UI\"") + form(params));

        client.write(h3("Errors") + p(errorMessage == "" ?  "none" : errorMessage));
        client.write("</body></html>");
      } else
      {
        String link = "http://" + ddnsLink + ":" + port + "/?h=true";
        client.write("For help go to http://" + ddnsLink + ":" + port + " and set the url encoded parameter \"h\" to \"true\".");
      }
    }
    // close connection to client, otherwise it's gonna wait forever
    client.stop();
  }

  background(0);

  for (String turtleKey : turtles.keySet ()) {
    Turtle turtle = turtles.get(turtleKey);
    turtle.update();
    turtle.draw();
  }
}

void mouseClicked() {
  if (currentTurtle != null) {
    if (mouseButton == LEFT)
      currentTurtle.moveTo(new PVector(mouseX, mouseY));

    if (mouseButton == RIGHT) {
      currentTurtle.lineColor = (int)random(0, pow(2, 32));
      currentTurtle.lineWeight = (int)random(2, 20);
    }
  }
}

void keyPressed() {
  if (key == ' ')
    turtles.clear();
}