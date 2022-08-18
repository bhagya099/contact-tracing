public with sharing class CTUpdateLocationStatusBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> healthStatus = new List<String>{'Red','Orange','Yellow'};
        Date today = Date.today();
        Date forteendaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status_Update_Date__c = :forteendaysAgo AND  Status__c IN :healthStatus');

    }

    public void execute(Database.BatchableContext bc, List<Location__c> scope) {
        for(Location__c location: scope) {
            location.Status__c = 'Green';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Batch is completed');
    }
}