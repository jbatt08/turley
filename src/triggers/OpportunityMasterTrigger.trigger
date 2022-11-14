trigger OpportunityMasterTrigger on Opportunity (before insert, after insert,
    before update, after update,
    before delete, after delete
    ) {
    
    // Insert
    if(Trigger.isInsert) {

        //Before
        if(Trigger.isBefore) {
            for (Opportunity o: Trigger.new){
                o.CloseDate = system.today();
            }
            OpportunityTriggerHelper.doCreateOpportunity(trigger.New);
       }
    }
    
    if(Trigger.isUpdate){
         for (Opportunity o: Trigger.new){
            if (Trigger.isBefore){
                Opportunity oldCloseDate = Trigger.oldMap.get(o.ID);
                if (o.CloseDate != oldCloseDate.CloseDate){
                    Integer Oldday = Integer.valueOf(oldCloseDate.CloseDate.Day()); 
                    Integer day = Integer.valueOf(o.CloseDate.Day());
                    Integer month = Integer.valueOf(o.CloseDate.Month());
                    Integer year = Integer.valueOf(o.CloseDate.Year());                 
                    Integer DayDiff = day - Oldday;

                    OpportunitySchedulingHandler.ScheduleDateUpdate(o.id, day, month, year, DayDiff);
                }
            }

            if (Trigger.isAfter){
                OpportunitySchedulingHandler.ScheduleServiceDateUpdate(o.id);   
            }
        }
    }
}