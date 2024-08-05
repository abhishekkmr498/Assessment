/**
 * This class contains unit tests for validating the behavior of Apex classes
 * Main Class: ZipCodeController
 */
@isTest
private class ZipCodeControllerTest {

    @isTest
    static void testsaveNonUSZipcodeResponse(){
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

        Test.startTest();
            String ret = ZipCodeController.saveNonUSZipcodeResponse(json);
            System.assert(ret.equals('Logged details successfully'),'Return message doesn\'t match');
        

            ret = ZipCodeController.saveNonUSZipcodeResponse(''); // send blank 
            System.assert(ret.equals('No response to Store'),'Return message doesn\'t match');
        Test.stopTest();    

    }
    @IsTest
    static void testGetNonUSZipcodeResponses(){
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

        Test.startTest();
            String ret = ZipCodeController.saveNonUSZipcodeResponse(json);
            System.assert(ret.equals('Logged details successfully'),'Return message doesn\'t match');

            //call method to test
            List<Zip_Lookup_Response__c> records= ZipCodeController.getNonUSZipcodeResponses();
            System.assert(records.size()==1,'Record size doesnot match');

        Test.stopTest();
    }

    @IsTest
    static void testGetPickListValues(){
        
        Test.startTest();
            list<ZipCodeController.customValueWrapper> ret = ZipCodeController.getPickListValues('Contact','OtherCountryCode');
            System.assert(ret.size()>0,'Record size doesnot match');
        Test.stopTest();
    }

    @IsTest
    static void testDoZipLookupCallout(){
        
        Test.startTest();
        
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            // Call method 
            String resJson = ZipCodeController.doZipLookupCallout('IN','815353');
            ZipCodeCalloutResponseParser respBody = ZipCodeCalloutResponseParser.parse(resJson);

            System.assert(respBody.statusCode == 200,'Response status code doesnot match');

            String resJsonError = ZipCodeController.doZipLookupCallout('error','815353');
            respBody = ZipCodeCalloutResponseParser.parse(resJsonError);
            System.assert(respBody.statusCode == 404,'Response status code doesnot match');

        Test.stopTest();
        
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('GET', req.getMethod());

            String nonUsResponse = '{'+
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

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');

            if(req.getEndpoint().startsWith('callout:ZipCodeSearch/IN')){
                res.setBody(nonUsResponse);
                res.setStatusCode(200);

            }else if(req.getEndpoint().startsWith('callout:ZipCodeSearch/error')){
                res.setBody('{}');
                res.setStatusCode(404);
            }
            return res;
        }
    }
}