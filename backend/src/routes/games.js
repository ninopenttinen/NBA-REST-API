import Router from 'koa-router';
import KoaBody from 'koa-bodyparser';
import Url from 'url';
import pool from '../connection_pool';
import { checkAccept, checkContent } from '../middleware';
import { parseSortQuery, parseQueryParameters } from '../query_parsers';

const games = new Router()
const koaBody = new KoaBody();

// Define API path
const apiPath = '/api/v1';

// Define games paths
const gamesPath = `${apiPath}/games`;
const gamePath = `${gamesPath}/:id`;
  
// GET /resource
games.get(gamesPath, checkAccept, async (ctx) => {
    const url = Url.parse(ctx.url, true);
    const { sort, game_id, home_team_id, guest_team_id, home_team_score, guest_team_score, date } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['game_id', 'home_team_id', 'guest_team_id', 'home_team_score', 'guest_team_score', 'date'] });
    const where = parseQueryParameters({ queryParameters: {game_id: game_id, home_team_id: home_team_id, guest_team_id: guest_team_id, home_team_score: home_team_score, guest_team_score: guest_team_score, date: date } });

    try {
        const data = await pool.query(`
            SELECT *
            FROM games
            ${where}
            ${orderBy};
        `);
  
        // Return all games
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// GET /resource/:id
games.get(gamePath, checkAccept, async (ctx) => {
    const { id } = ctx.params;

    try {
        const data = await pool.query(`
            SELECT *
            FROM games
            WHERE game_id = $1;
            `, [id]);
  
        // Return the resource
        ctx.body = data.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// GET /resource/:id/resource
games.get(`${apiPath}/teams/:id/games`, checkAccept, async (ctx) => {
    const { id } = ctx.params; // id is for teams
    const url = Url.parse(ctx.url, true);
    const { sort } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['game_id', 'home_team_id', 'guest_team_id', 'home_team_score', 'guest_team_score', 'date'] });

    try {
        const data = await pool.query(`
            SELECT *
            FROM games
            WHERE home_team_id = $1 OR guest_team_id = $1
            ${orderBy};
        `, [id]);
  
        // Return all games
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// POST /resource
games.post(gamesPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { game_id, home_team_id, guest_team_id, home_team_score, guest_team_score, date } = ctx.request.body;
  
    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value === 'undefined')
            ctx.throw(400, `body.${key} is required`);
        else if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);
  
    try {
        // Insert a new game
        const status = await pool.query(`
            INSERT INTO games
            VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING *;
            `, [game_id, home_team_id, guest_team_id, home_team_score, guest_team_score, date]);

        // Set the response header to 201 Created
        ctx.status = 201;

        // Set the Location header to point to the new resource
        const newUrl = `${ctx.host}${Router.url(gamePath, { id: status.rows[0].game_id })}`;
        ctx.set('Location', newUrl);

        // Return the new game
        ctx.body = status.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// PUT /resource/:id
games.put(gamePath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { id } = ctx.params;
    const { home_team_id, guest_team_id, home_team_score, guest_team_score, date } = ctx.request.body;

    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);

    try {
        // Update the game
        let status = await pool.query(`
            UPDATE games
            SET 
            home_team_id = COALESCE($2, home_team_id),
            guest_team_id = COALESCE($3, guest_team_id),
            home_team_score = COALESCE($4, home_team_score),
            guest_team_score = COALESCE($5, guest_team_score),
            date = COALESCE($6, date)
            WHERE game_id = $1
            RETURNING *;
            `, [id, home_team_id, guest_team_id, home_team_score, guest_team_score, date] );

        if (status.rowCount === 0) {
            // If the resource does not already exist, create it
            status = await pool.query(`
                INSERT INTO games
                VALUES ($1, $2, $3, $4, $5, $6)
                RETURNING *;
                `, [id, home_team_id, guest_team_id, home_team_score, guest_team_score, date] );
            
                // Set the response header to 201 Created
                ctx.status = 201;
        }

        // Return the resource
        ctx.body = status.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// DELETE /resource/:id
games.del(gamePath, async (ctx) => {
    const { id } = ctx.params;

    try {
        const status = await pool.query(`
            DELETE FROM games
            WHERE game_id = $1;
            `, [id] );
  
        if (status.rowCount === 0) {
            // The row did not exist, return '404 Not found'
            ctx.status = 404;
        } else {
            // Return '204 No Content' status code for successful delete
            ctx.status = 204;
        }
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

export default games;