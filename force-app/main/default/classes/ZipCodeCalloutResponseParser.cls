public with sharing class ZipCodeCalloutResponseParser {
    public String postCode {get;set;} 
	public String country {get;set;} 
	public String countryAbbreviation {get;set;} 
	public List<Places> places {get;set;} 
    public Integer statusCode {get;set;} 
    public ZipCodeCalloutResponseParser(){}

	public ZipCodeCalloutResponseParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'post code' || text == 'postCode') {
						postCode = parser.getText();
					} else if (text == 'country') {
						country = parser.getText();
					} else if (text == 'country abbreviation' || text == 'countryAbbreviation') {
						countryAbbreviation = parser.getText();
					}  else if (text == 'statusCode') {
						statusCode = Integer.valueOf(parser.getText());
					} 
                    else if (text == 'places') {
						places = arrayOfPlaces(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Places {
		public String placeName {get;set;} 
		public String longitude {get;set;} 
		public String state {get;set;} 
		public String stateAbbreviation {get;set;} 
		public String latitude {get;set;} 

		public Places(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'place name') {
							placeName = parser.getText();
						} else if (text == 'longitude') {
							longitude = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'state abbreviation') {
							stateAbbreviation = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Places consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ZipCodeCalloutResponseParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ZipCodeCalloutResponseParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<Places> arrayOfPlaces(System.JSONParser p) {
        List<Places> res = new List<Places>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Places(p));
        }
        return res;
    }
}