@isTest
public class OpportunityRestController_Test {


	@isTest
    static void getTokenTest(){

        String endpoint = 'https://SalesService.com/tokenExample';
        Map<String,Object> body = new Map<String,Object>();
        body.put('grant_type','client_credentials');
        body.put('client_id','qwerty');
        body.put('client_secret','dummySecret');
        body.put('scope','data_extensions_read');

        Test.setMock(HttpCalloutMock.class, new OpportunityRestControllerTokenMock());
        
        HttpResponse response = (HttpResponse)OpportunityRestController.tokenCallout(endpoint,body);
        String token = OpportunityRestController.getToken();
      
        System.assertEquals('{"access_token":"1q2s3c4v","token_type":"Bearer"}',response.getBody());
        System.assertEquals('OK',response.getStatus());
        System.assertEquals(200,response.getStatusCode());
        //Assert getTOken
        System.assertEquals('1q2s3c4v',token);

    }
    
    @isTest
    static void sendRecordsTest(){
        List<Opportunity> oppInsert = new List<Opportunity>();

        Opportunity opp = new Opportunity();
        opp.Name = 'Test opportunity';
        opp.StageName = 'Closed Won';
        opp.CloseDate = System.today();
        oppInsert.add(opp);

        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test opportunity1';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = System.today();
        oppInsert.add(opp1);

        insert oppInsert;
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        List<String> oppIds = new List<String>();
        for(Opportunity opport : oppList){
            oppIds.add(opport.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OpportunityRestControllerCalloutMock());
        OpportunityRestController.sendRecords(oppIds);
        Test.stopTest();
        System.assertEquals(1,Limits.getAsyncCalls());
    }

    @isTest
    static void checkResponseTest404(){
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Error":"404"}');
        response.setStatusCode(404);
        response.setStatus('Page Not Found');

        ApiException pageNotFoundExc;

        try{
            OpportunityRestController.checkResponse(response);
        }
        catch(ApiException ex){
            pageNotFoundExc = ex;
        }
    }

    @isTest
    static void checkResponseTest500(){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Error":"500"}');
        response.setStatusCode(500);
        response.setStatus('Server Error with status code:500');

        ApiException pageNotFoundExc;

        try{
            OpportunityRestController.checkResponse(response);
        }
        catch(ApiException ex){
            pageNotFoundExc = ex;
        }
    }

    @isTest
    static void checkResponseTest403(){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Error":"403"}');
        response.setStatusCode(403);
        response.setStatus('403 Forbiden');

        ApiException pageNotFoundExc;

        try{
            OpportunityRestController.checkResponse(response);
        }
        catch(ApiException ex){
            pageNotFoundExc = ex;
        }
    }

    @isTest
    static void checkResponseTest401(){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Error":"401"}');
        response.setStatusCode(401);
        response.setStatus('401 Unauthorized');

        ApiException pageNotFoundExc;

        try{
            OpportunityRestController.checkResponse(response);
        }
        catch(ApiException ex){
            pageNotFoundExc = ex;
        }
    }

    @isTest
    static void checkResponseTest301(){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Error":"301"}');
        response.setStatusCode(301);
        response.setStatus('Moved Permanently');

        ApiException pageNotFoundExc;

        try{
            OpportunityRestController.checkResponse(response);
        }
        catch(ApiException ex){
            pageNotFoundExc = ex;
        }
    }

    
}