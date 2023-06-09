@isTest
private class accountTriggerTest{
    @testSetup
    static void makeData(){
		Account acc = new Account();
        acc.Name = 'test Account';
        acc.Type = 'Customer';
        acc.Active__c = true;
        insert acc;
        
        Account testAccount = new Account(
            Name = 'new Account',
            Type = 'Customer',
            Active__c = false,
            Account_Activation_Summary__c = 'thk'
        );
        insert testAccount;                
    }
    
    @isTest
    static void positiveTest(){
            List<Account> accList = [select id, Name, Type, Active__c from Account];
            List<Contact> conList = [select id, Name, LastName from Contact];
            system.assert(!conList.isEmpty());       
    }
    
      
    @isTest
    static void negativeTest(){
        Set<Id> accid = new Set<Id>();
        List<Account> accList = [select id, Name, Type, Active__c from Account];
        for(Account a: accList){
            system.debug(a.Id);
            if(!a.Active__c){
                accid.add(a.Id);
            }
        }
        List<Contact> conList = [select id, Name, LastName from Contact where AccountId in: accid];
        
        system.assert(conList.isEmpty());
    }
    
    @isTest
    static void updateTest(){
		List<Account> accList = [select id, Name, Active__c, Account_Activation_Summary__c from Account where Active__c = false];     
        Set<Id> accId = new Set<Id>();
        for(Account a: accList){
            a.Active__c = true;
            accId.add(a.Id);
            
        }
        update accList;
        
        List<Contact> conList = [select id, Name, LastName from Contact where AccountId in: accId];
		system.assert(!conList.isEmpty());
    }
}