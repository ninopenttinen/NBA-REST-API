import 'babel-polyfill';
import Koa from 'koa';
import teams from './routes/teams';
import players from './routes/players';
import games from './routes/games';
import results from './routes/results';

// The port that this server will run on, defaults to 9000
const port = process.env.PORT || 9000;

// Instantiate a Koa server
const app = new Koa();

// Set the routes
app.use(teams.routes());
app.use(teams.allowedMethods());
app.use(players.routes());
app.use(players.allowedMethods());
app.use(games.routes());
app.use(games.allowedMethods());
app.use(results.routes());
app.use(results.allowedMethods());

// Start the server and keep listening on port until stopped
app.listen(port);
console.log(`App listening on port ${port}`);
