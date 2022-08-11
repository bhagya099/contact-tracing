public with sharing class CTLocationTracingTriggerHandler {
    public static void beforeInsert(List<Location_Tracing__c> newRecords) {
        List<Location_Tracing__c> duplicate = CTLocationTracingController.checkDuplicates(newRecords);

        for(Location_Tracing__c trace: duplicate) {
           trace.addError('duplicates record founds ' + 'location Id ' + trace.Location__c );
        }
    }
}
