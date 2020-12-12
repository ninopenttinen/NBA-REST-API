import Router from 'koa-router';
import KoaBody from 'koa-bodyparser';
import Url from 'url';
import pool from '../connection_pool';
import { checkAccept, checkContent } from '../middleware';
import { parseSortQuery, parseQueryParameters } from '../query_parsers';

const players = new Router()
const koaBody = new KoaBody();

// Define API path
const apiPath = '/api/v1';

// Define players paths
const playersPath = `${apiPath}/players`;
const playerPath = `${playersPath}/:id`;
  
// GET /resource
players.get(playersPath, checkAccept, async (ctx) => {
    const url = Url.parse(ctx.url, true);
    const { sort, player_id, team_id, name, born, height } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['player_id', 'team_id', 'name', 'born', 'height'] });
    const where = parseQueryParameters({ queryParameters: {player_id: player_id, team_id: team_id, name: name, born: born, height: height} });

    try {
        const data = await pool.query(`
            SELECT *
            FROM players
            ${where}
            ${orderBy};
        `);
  
        // Return all players
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// GET /resource/:id
players.get(playerPath, checkAccept, async (ctx) => {
    const { id } = ctx.params;

    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'player_id must be int');

    try {
        const data = await pool.query(`
            SELECT *
            FROM players
            WHERE player_id = $1;
            `, [id]);
  
        // Return the resource
        ctx.body = data.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// GET /resource/:id/resource
players.get(`${apiPath}/teams/:id/players`, checkAccept, async (ctx) => {
    const { id } = ctx.params; // id is for teams
    const url = Url.parse(ctx.url, true);
    const { sort } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['player_id', 'team_id', 'name', 'born', 'height'] });

    try {
        const data = await pool.query(`
            SELECT *
            FROM players
            WHERE team_id = $1
            ${orderBy};
        `, [id]);
  
        // Return all players
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// POST /resource
players.post(playersPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { team_id, name, born, height } = ctx.request.body;
  
    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value === 'undefined')
            ctx.throw(400, `body.${key} is required`);
        else if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);
  
    try {
        // Insert a new player
        const status = await pool.query(`
            INSERT INTO players
            VALUES (DEFAULT, $1, $2, $3, $4)
            RETURNING *;
            `, [team_id, name, born, height]);

        // Set the response header to 201 Created
        ctx.status = 201;

        // Set the Location header to point to the new resource
        const newUrl = `${ctx.host}${Router.url(playerPath, { id: status.rows[0].player_id })}`;
        ctx.set('Location', newUrl);

        // Return the new player
        ctx.body = status.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// PUT /resource/:id
players.put(playerPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { id } = ctx.params;
    const { team_id, name, born, height } = ctx.request.body;

    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'player_id must be int');

    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);

    try {
        // Update the player
        let status = await pool.query(`
            UPDATE players
            SET 
            team_id = COALESCE($2, team_id),
            name = COALESCE($3, name),
            born = COALESCE($4, born),
            height = COALESCE($5, height)
            WHERE player_id = $1
            RETURNING *;
            `, [id, team_id, name, born, height] );

        if (status.rowCount === 0) {
            // If the resource does not already exist, create it
            status = await pool.query(`
                INSERT INTO players
                VALUES (DEFAULT, $1, $2, $3, $4)
                RETURNING *;
                `, [team_id, name, born, height] );
            
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
players.del(playerPath, async (ctx) => {
    const { id } = ctx.params;

    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'player_id must be int');
  
    try {
        const status = await pool.query(`
            DELETE FROM players
            WHERE player_id = $1;
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

export default players;