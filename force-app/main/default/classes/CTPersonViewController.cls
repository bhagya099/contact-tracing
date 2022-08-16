public with sharing class CTPersonViewController {
    @AuraEnabled
    public static void updateHealthStatus(String personID){
        Person__c person = new Person__c(Id=personID);
        person.Health_Status__c = 'Red';
       update person;        
    }
}
