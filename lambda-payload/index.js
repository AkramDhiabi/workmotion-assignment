exports.handler = function(event, context) {
    console.log("Welcome to our demo API, here are the details of your request:");
    console.log('Headers: ', event.headers);
    console.log('Method: ', event.method);
    console.log('Body: ', event.body);
    
    context.succeed(event);
    
  };