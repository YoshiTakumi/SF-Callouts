@isTest
global class OpportunityRestControllerCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request){

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Creation":"Succesfull"}');
        response.setStatusCode(201);
        response.setStatus('Created');

        return response;
    }
}
