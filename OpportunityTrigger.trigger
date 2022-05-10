trigger OpportunityTrigger on Opportunity (after insert, after update) {

    List<String> oppIds = new List<String>();
    for(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Closed Won'){
            oppIds.add(opp.Id);
        }
    }
    OpportunityRestController.sendRecords(oppIds);

}