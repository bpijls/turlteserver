// Parse HTTP headers to a stringdict
StringDict parseHTTPHeaders(String headers) {

  StringDict httpHeaders = new StringDict();
  // Split headers in key/value pairs
  for (String headerString : headers.split ("\n")) {
    
    // Split key/Value pair into separate key and value
    String requestParams [] = headerString.split(":");   
    
    // Only if 2 parts are found
    if (requestParams.length > 1) {
      httpHeaders.set(requestParams[0], requestParams[1]);
    } else // Except for GET, which is in a different form 
    if (headerString.indexOf(HTTP_GET_REQUEST) == 0)
      httpHeaders.set("GET", headerString);
  }

  return httpHeaders;
}

// Parse URLEncoded parameters to a StringDict
StringDict parseParameters(String parameterString) {
  
  StringDict getParameters = new StringDict();

  if (parameterString != null) {
    // Remove bits we don't have to parse
    parameterString = parameterString.replaceAll("(HTTP.*)", "");
    String command = parameterString.replaceAll("(^\\w+ )|(\\?.*)", "");
    // Split into key/value pairs    
    for (String pair : parameterString.replaceFirst (".*?\\?", "").split("&"))
      // Split each key/value into separate key and value 
      if (pair.split("=").length > 1)
        getParameters.set(pair.split("=")[0], URLDecoder.decode(pair.split("=")[1]).trim());
  }
  
  return getParameters;
}

// Decodes URL unprintable characters to actual characters (i.e. "%20" to space, etc.)
static class URLDecoder {
  
  static StringDict URLCodeLookupTable;
  
  static String decode(String URLString) {
    
    // generate lookup table once
    if (URLCodeLookupTable == null) {
      URLCodeLookupTable = new StringDict();
        for (int i =  0x20; i<0x7E; i++) {
          URLCodeLookupTable.set("%" + hex(i, 2).toUpperCase(), "" + ((char)i));
        }
    }
    
    String decoded = URLString;

    for (String codeKey : URLCodeLookupTable.keys ()) {      
      decoded = decoded.replace(codeKey, URLCodeLookupTable.get(codeKey));
    }
    return decoded;
  }
}
