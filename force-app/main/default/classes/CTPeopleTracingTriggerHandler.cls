public with sharing class CTPeopleTracingTriggerHandler {
    public static void beforeInset(List<People_Tracing__c> newRecord) {
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecord);
        for(People_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found. Person1 ' + trace.Person_1__c + 'Person2 ' + trace.Person_2__c);
        }
    }
}
