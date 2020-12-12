const parseSortQuery = ({ urlSortQuery, whitelist }) => {
    let query = '';
    if (urlSortQuery) {
        const sortParams = urlSortQuery.split(',');

        query = 'ORDER BY ';
        sortParams.forEach((param, index) => {
            let trimmedParam = param;
            let desc = false;
    
            if (param[0] === '-') {
                // Remove the first character
                trimmedParam = param.slice(1);
                // Set descending to true
                desc = true;
            }
    
            // If parameter is not whitelisted, ignore it
            // This also prevents SQL injection even without statement preparation
            if (!whitelist.includes(trimmedParam)) return;

            // If this is not the first sort parameter, append ', '
            if (index > 0) query = query.concat(', ');

            // Append the name of the field
            query = query.concat(trimmedParam);

            if (desc) query = query.concat(' DESC');
        });
    }
return query;
};

const parseQueryParameters = ({ queryParameters }) => {
    let query = 'WHERE';

    for (let [key, value] of Object.entries(queryParameters)) {
        if (value != null)
            if (!value.match("^$|^[A-Za-z0-9-_ ]+$")) { // Validate
                return '';
            } else
                query += ` ${key} = '${value}' AND `;
    }

    if (query == 'WHERE')
        query = '';
    else 
        query = query.slice(0, -5);
        
    //console.log('query: ' + query);
    
    return query;
};

export { parseSortQuery, parseQueryParameters };