public class OpportunityRestController {

    public static void sendRecords(List<String> oppIds){

        String endpoint = [SELECT EndPoint__c FROM SalesServiceRestConfiguration__mdt].EndPoint__c;
        recordsCallout(endpoint,oppIds);
        
    }

    @future(callout=true)
    public static void recordsCallout(String endpoint,List<String> oppIds){

        List<Opportunity> oppList = [SELECT Id,Name FROM Opportunity WHERE Id IN :oppIds];
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint); //The endpoint of sales service
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json;charset=UTF-8'); //NOT SURE ABOUT THE X-SEM-APP AND X-SEM-ENV HEADERS
        req.setHeader('Authorization','X-SEM-TOKEN '+getToken());       
        req.setBody(JSON.serialize(recordBody(oppList)));
        HttpResponse response = http.send(req);

        if(!Test.isRunningTest()){
            checkResponse(response);
        }
        
    }

    private static Map<String,Object> recordBody(List<Opportunity> oppList){
        Map<String,Object> body =  new Map<String,Object>();
        for(Opportunity opp : oppList){
            RecordClass rc = new RecordClass();
            rc.Name = opp.Name;
            rc.Discount = 0;
            body.put('record',rc);
        }
        return body;
    }
    
    @TestVisible
    private static void checkResponse(HttpResponse response){
        Integer statusCode = response.getStatusCode();
        switch on statusCode {
            when 500,504{
                String errorMessage = response.getBody();
                throw new ApiException('Server Error with status code: '+statusCode +' '+errorMessage);
            } 
                
            when 404{
                throw new ApiException('Page not found:404');
            }
                
           
            when 403{
                throw new ApiException('Forbiden access');
            }

            when 401{
                throw new ApiException('Unauthorized access');
            }
                
            when else{
                if (response.getStatusCode() >= 300) {
                    String errorMessage = response.getBody();
                    throw new ApiException('Endpoint return status code: '+statusCode+' with error message '+errorMessage);
                }
            } 
        }
    }
	
    @TestVisible
    private static String getToken(){
     
        Map<String,Object> body = new Map<String,Object>();

        SalesServiceTokenParams__mdt params = [SELECT EndPoint__c,GrantType__c,ClientSecret__c, ClientId__c, Scope__c FROM SalesServiceTokenParams__mdt];
        String endpoint = params.EndPoint__c;
        body.put('grant_type',params.GrantType__c);
        body.put('client_id',params.ClientId__c);
        body.put('client_secret',params.ClientSecret__c);
        body.put('scope',params.Scope__c);

        HttpResponse response = tokenCallout(endpoint,body);

        Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        return (String)responseMap.get('access_token');
    }
	
    @TestVisible
    private static HttpResponse tokenCallout(String endpoint, Map<String,Object> body){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setBody(JSON.serialize(body));
        HttpResponse response = http.send(request);

        return response;
    }



    public class RecordClass{      //OR WRAPPER CLASS
        public String Name {get;set;}
        public Integer Discount{get;set;}
        
    }
}