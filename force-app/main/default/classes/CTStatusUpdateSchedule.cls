public with sharing class CTStatusUpdateSchedule implements Schedulable{
    public static final String CRON = '0 0 2 * * ?';
    public void execute(SchedulableContext sc) {
         CTUpdatePersonStatus updatePersonStatus =  new CTUpdatePersonStatus();

         Database.executeBatch(updatePersonStatus,2000);

          CTUpdateLocationStatusBatch updateLocationBatch =  new CTUpdateLocationStatusBatch();

         Database.executeBatch(updateLocationBatch ,2000);
    }
}
