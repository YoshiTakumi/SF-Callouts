@isTest
global class OpportunityRestControllerTokenMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request){

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setBody('{"access_token":"1q2s3c4v","token_type":"Bearer"}');
        response.setStatus('OK');
        response.setStatusCode(200);

        return response;
    }
}