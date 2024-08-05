@isTest
public with sharing class ZipCodeCalloutResponseParserTest {
    static testMethod void testResponseParser() {
		String json = '{'+
		'  \"post code\": \"815353\",'+
		'  \"country\": \"India\",'+
		'  \"statusCode\":200,'+
		'  \"country abbreviation\": \"IN\",'+
		'  \"places\": ['+
		'    {'+
		'      \"place name\": \"Madhupur\",'+
		'      \"longitude\": \"86.65\",'+
		'      \"state\": \"Jharkhand\",'+
		'      \"state abbreviation\": \"JH\",'+
		'      \"latitude\": \"24.25\"'+
		'    }'+
		'  ]'+
		'}';
		ZipCodeCalloutResponseParser r = ZipCodeCalloutResponseParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZipCodeCalloutResponseParser objJSON2Apex = new ZipCodeCalloutResponseParser(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.postCode == null);
		System.assert(objJSON2Apex.country == null);
		System.assert(objJSON2Apex.countryAbbreviation == null);
		System.assert(objJSON2Apex.places == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ZipCodeCalloutResponseParser.Places objPlaces = new ZipCodeCalloutResponseParser.Places(System.JSON.createParser(json));
		System.assert(objPlaces != null);
		System.assert(objPlaces.placeName == null);
		System.assert(objPlaces.longitude == null);
		System.assert(objPlaces.state == null);
		System.assert(objPlaces.stateAbbreviation == null);
		System.assert(objPlaces.latitude == null);
	}
}