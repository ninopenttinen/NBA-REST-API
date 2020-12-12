import Router from 'koa-router';
import KoaBody from 'koa-bodyparser';
import Url from 'url';
import pool from '../connection_pool';
import { checkAccept, checkContent } from '../middleware';
import { parseSortQuery, parseQueryParameters } from '../query_parsers';

const teams = new Router()
const koaBody = new KoaBody();

// Define API path
const apiPath = '/api/v1';

// Define teams paths
const teamsPath = `${apiPath}/teams`;
const teamPath = `${teamsPath}/:id`;
  
// GET /resource
teams.get(teamsPath, checkAccept, async (ctx) => {
    const url = Url.parse(ctx.url, true);
    const { sort, team_id, name, wins, losses } = url.query;

    const orderBy = parseSortQuery({ urlSortQuery: sort, whitelist: ['team_id', 'name', 'wins', 'losses'] });
    const where = parseQueryParameters({ queryParameters: {team_id: team_id, name: name, wins: wins, losses: losses} });

    try {
        const data = await pool.query(`
            SELECT *
            FROM teams
            ${where}
            ${orderBy};
        `);
  
        // Return all teams
        ctx.body = data.rows;
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }
});

// GET /resource/:id
teams.get(teamPath, checkAccept, async (ctx) => {
    const { id } = ctx.params;

    try {
        const data = await pool.query(`
            SELECT *
            FROM teams
            WHERE team_id = $1;
            `, [id]);
  
        // Return the resource
        ctx.body = data.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// POST /resource
teams.post(teamsPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { team_id, name, wins, losses } = ctx.request.body;
  
    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value === 'undefined')
            ctx.throw(400, `body.${key} is required`);
        else if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);
  
    try {
        // Insert a new team
        const status = await pool.query(`
            INSERT INTO teams
            VALUES ($1, $2, $3, $4)
            RETURNING *;
            `, [team_id, name, wins, losses]);

        // Set the response header to 201 Created
        ctx.status = 201;

        // Set the Location header to point to the new resource
        const newUrl = `${ctx.host}${Router.url(teamPath, { id: status.rows[0].team_id })}`;
        ctx.set('Location', newUrl);

        // Return the new team
        ctx.body = status.rows[0];
    } catch (error) {
        console.error('Error occurred:', error);
        ctx.throw(500, error);
    }  
});

// PUT /resource/:id
teams.put(teamPath, checkAccept, checkContent, koaBody, async (ctx) => {
    const { id } = ctx.params;
    const { name, wins, losses } = ctx.request.body;
  
    for (let [key, value] of Object.entries(ctx.request.body))
        if (typeof value !== 'string')
            ctx.throw(400, `body.${key} must be string`);

    try {
        // Update the team
        let status = await pool.query(`
            UPDATE teams
            SET 
            name = COALESCE($2, name),
            wins = COALESCE($3, wins),
            losses = COALESCE($4, losses)
            WHERE team_id = $1
            RETURNING *;
            `, [id, name, wins, losses] );
  
        if (status.rowCount === 0) {
            // If the resource does not already exist, create it
            status = await pool.query(`
                INSERT INTO teams
                VALUES ($1, $2, $3, $4)
                RETURNING *;
                `, [id, name, wins, losses] );
            
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
teams.del(teamPath, async (ctx) => {
    const { id } = ctx.params;

    try {
        const status = await pool.query(`
            DELETE FROM teams
            WHERE team_id = $1;
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

export default teams;