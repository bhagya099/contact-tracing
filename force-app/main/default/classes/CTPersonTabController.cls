public with sharing class CTPersonTabController {
    @AuraEnabled
    public static String getPersonDetails(String personId){

        Person__c personrecord = CTPersonController.getPersonById(personId);

        List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(personID);

    }

    //wrapper class
    public class UserInformation {
        @AuraEnabled public  String name;
        @AuraEnabled public  String token;
        @AuraEnabled public  String statusUpdateOn;
        @AuraEnabled public  String phone;
        @AuraEnabled public  String status;
    
    }
    public class CloseContacts {
        @AuraEnabled public  String id;
        @AuraEnabled public  Date token;
        @AuraEnabled public  String contactDate;
        @AuraEnabled public  String status;
    }
}