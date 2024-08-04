/**
 * Description: Class used for doing callout for Zip Code lookup
 * Developer : Abhishek Prasad
 */
public without sharing class ZipCodeController {
    public ZipCodeController() {

    }

    @AuraEnabled
    public static String saveNonUSZipcodeResponse(String response) {
        if(String.isNotBlank(response)){
            try {
                ZipCodeCalloutResponseParser respBody = ZipCodeCalloutResponseParser.parse(response);
                if(respBody.statusCode==200){
                    Zip_Lookup_Response__c obj = new Zip_Lookup_Response__c();
                    obj.Country__c = respBody.country;
                    obj.Country_Abbreviation__c = respBody.countryAbbreviation;
                    obj.PostCode__c = respBody.postCode;
                    obj.Raw_Response__c = response;
                    obj.State_Name__c= respBody.places.size()>0 ? respBody.places[0].state :'';
                    
                    insert obj;
                    return 'Logged details successfully';
                }else {
                    return 'No response to Store';
                }
            } catch (Exception e) {
                return 'Error while logging details: '+e.getMessage()+'\n'+e.getStackTraceString();
            }
        }else{
            return 'No response to Store';
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Zip_Lookup_Response__c> getNonUSZipcodeResponses(String country, String countryAbb, String postalCode, String StateName, String rawResp) {
        return [SELECT ID,
                            Country_Abbreviation__c ,
                            Country__c,
                            PostCode__c,
                            State_Name__c,
                            format(createdDate)
                    FROM Zip_Lookup_Response__c 
                    WHERE Country__c!='US' AND Country__c!=null AND PostCode__c!=null
                    Order by createdDate Desc];
    }

    //Raw Response
    /*{
        "post code": "815353",
        "country": "India",
        "country abbreviation": "IN",
        "places": [
        {
            "place name": "Madhupur",
            "longitude": "86.65",
            "state": "Jharkhand",
            "state abbreviation": "JH",
            "latitude": "24.25"
        }
        ]
    }
    */
    @AuraEnabled
    public static String doZipLookupCallout(String country,String zipCode){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ZipCodeSearch/'+country+'/'+zipCode);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        if(res.getStatusCode()==200){
            ZipCodeCalloutResponseParser respBody = ZipCodeCalloutResponseParser.parse(res.getBody());
            respBody.statusCode=res.getStatusCode();
            // System.debug(respBody.postCode);
            // System.debug(respBody.country);
            // System.debug(respBody.countryAbbreviation);
            // System.debug(respBody.places);
            // System.debug(respBody.places[0].stateAbbreviation);
            return JSON.serialize(respBody);
        }else{
            ZipCodeCalloutResponseParser erroRes = new ZipCodeCalloutResponseParser();
            erroRes.statusCode=res.getStatusCode();
            return JSON.serialize(erroRes);
        }
       
    }

    @AuraEnabled(cacheable=true)
    public static list<customValueWrapper> getPickListValues(String customObjInfo, String selectPicklistApi){
        Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(customObjInfo).getDescribe();     
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        
        for (Schema.PicklistEntry myCustPick: custPickValues) {
            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }

        return customObjWrapper;
    }
    // wrapper class 
    public with sharing class customValueWrapper {
        @auraEnabled public string custFldlabel {get;set;}
        @auraEnabled public string custFldvalue {get;set;}
    }
}