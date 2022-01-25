exports.handler = function(event, context, callback) {
  const outputmsg = `Welcome to our demo API, here are the details of your request:
  Headers: ${JSON.stringify(event.headers)}
  Method: ${JSON.stringify(event.method)}
  Body: ${JSON.stringify(event.body)}`;
  
  callback(null, outputmsg);
};
