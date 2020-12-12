import Router from 'koa-router';
import KoaBody from 'koa-bodyparser';
import Url from 'url';
import pool from '../connection_pool';
import { checkAccept, checkContent } from '../middleware';
import { parseSortQuery, parseQueryParameters } from '../query_parsers';

const results = new Router()
const koaBody = new KoaBody();

// Define API path
const apiPath = '/api/v1';

// Define results paths
const resultsPath = `${apiPath}/results`;
const resultPath = `${resultsPath}/:id`;
  
// GET /resource
results.get(resultsPath, checkAccept, async (ctx) => {
    const url = Url.parse(ctx.url, true);
    const { sort, result_id, game_id, player_id, points, rebounds, assists } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['result_id', 'game_id', 'player_id', 'points', 'rebounds', 'assists'] });
    const where = parseQueryParameters({ queryParameters: { result_id: result_id, game_id: game_id, player_id: player_id, points: points, rebounds: rebounds, assists: assists } });

    try {
        const data = await pool.query(`
            SELECT *
            FROM results
            ${where}
            ${orderBy};
        `);
  
        // Return all results
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// GET /resource/:id
results.get(resultPath, checkAccept, async (ctx) => {
    const { id } = ctx.params;

    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'result_id must be int');

    try {
        const data = await pool.query(`
            SELECT *
            FROM results
            WHERE result_id = $1;
            `, [id]);
  
        // Return the resource
        ctx.body = data.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// GET /resource/:id/resource
results.get(`${apiPath}/games/:id/results`, checkAccept, async (ctx) => {
    const { id } = ctx.params; // id is for games
    const url = Url.parse(ctx.url, true);
    const { sort } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['result_id', 'game_id', 'player_id', 'points', 'rebounds', 'assists'] });

    try {
        const data = await pool.query(`
            SELECT *
            FROM results
            WHERE game_id = $1
            ${orderBy};
        `, [id]);
  
        // Return all results
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// GET /resource/:id/resource
results.get(`${apiPath}/players/:id/results`, checkAccept, async (ctx) => {
    const { id } = ctx.params; // id is for players
    const url = Url.parse(ctx.url, true);
    const { sort } = url.query;

    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'player_id must be int');

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['result_id', 'game_id', 'player_id', 'points', 'rebounds', 'assists'] });

    try {
        const data = await pool.query(`
            SELECT *
            FROM results
            WHERE player_id = $1
            ${orderBy};
        `, [id]);
  
        // Return all results
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// POST /resource
results.post(resultsPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { game_id, player_id, points, rebounds, assists } = ctx.request.body;
  
    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value === 'undefined')
            ctx.throw(400, `body.${key} is required`);
        else if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);
  
    try {
        // Insert a new result
        const status = await pool.query(`
            INSERT INTO results
            VALUES (DEFAULT, $1, $2, $3, $4, $5)
            RETURNING *;
            `, [game_id, player_id, points, rebounds, assists]);

        // Set the response header to 201 Created
        ctx.status = 201;

        // Set the Location header to point to the new resource
        const newUrl = `${ctx.host}${Router.url(resultPath, { id: status.rows[0].result_id })}`;
        ctx.set('Location', newUrl);

        // Return the new result
        ctx.body = status.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// PUT /resource/:id
results.put(resultPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { id } = ctx.params;
    const { game_id, player_id, points, rebounds, assists } = ctx.request.body;
  
    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'result_id must be int');

    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value === 'undefined')
            ctx.throw(400, `body.${key} is required`);
        else if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);

    try {
        // Update the result
        let status = await pool.query(`
            UPDATE results
            SET 
            game_id = COALESCE($2, game_id),
            player_id = COALESCE($3, player_id),
            points = COALESCE($4, points),
            rebounds = COALESCE($5, rebounds),
            assists = COALESCE($6, assists)
            WHERE result_id = $1
            RETURNING *;
            `, [id, game_id, player_id, points, rebounds, assists] );

        if (status.rowCount === 0) {
            // If the resource does not already exist, create it
            status = await pool.query(`
                INSERT INTO results
                VALUES (DEFAULT, $1, $2, $3, $4, $5)
                RETURNING *;
                `, [game_id, player_id, points, rebounds, assists] );
            
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
results.del(resultPath, async (ctx) => {
    const { id } = ctx.params;
    
    if (isNaN(id) || id.includes('.'))
        ctx.throw(400, 'result_id must be int');

    try {
        const status = await pool.query(`
            DELETE FROM results
            WHERE result_id = $1;
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

export default results;