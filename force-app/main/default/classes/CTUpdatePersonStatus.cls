public with sharing class CTUpdatePersonStatus implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> healthStatus = new List<String>{'Red','Orange','Yellow'};
        Date today = Date.today();
        Date forteendaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Health_Status__c FROM People__c WHERE Status_Update_Date__c = :forteendaysAgo AND  Health_Status__c IN :healthStatus');

    }

    public void execute(Database.BatchableContext bc, List<Person__c> scope) {
        for(Person__c person: scope) {
            person.Health_Status__c = 'Green';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Batch is completed');
    }
}
