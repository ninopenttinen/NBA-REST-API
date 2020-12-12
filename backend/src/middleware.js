// Middleware for checking accept headers
const checkAccept = async (ctx, next) => {
    // If client does not accept 'application/json' as response type, throw '406 Not Acceptable'
    if (!ctx.accepts('application/json')) {
        ctx.throw(406);
    }
    // Set the response content type
    ctx.type = 'application/json; charset=utf-8';
    // Move to next middleware
    await next();
};
  
// Middleware for checking request body content
const checkContent = async (ctx, next) => {
    // Check that the request content type is 'application/json'
    if (!ctx.is('application/json')) {
        ctx.throw(415, 'Request must be application/json');
    }
    // Move to next middleware
    await next();
};

export { checkAccept, checkContent };