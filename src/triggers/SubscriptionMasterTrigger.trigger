trigger SubscriptionMasterTrigger on Subscription__c ( 
    before insert, after insert,
    before update, after update,
    before delete, after delete
    ) {
    
    
    // Insert
    if (Trigger.isInsert) {

        //Before
        if (Trigger.isBefore) {
          SubscriptionTriggerHelper.CreateSubscription(trigger.New);
        }
    }

}