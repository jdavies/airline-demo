const { createClient } = require("@astrajs/rest");
const { ContactsOutlined } = require("@material-ui/icons");

exports.handler = async function (event, context, callback) {
    const baggagetagnumber = event.queryStringParameters.baggagetagnumber;
    //const baggagetagnumber = encodeURI(event.queryStringParameters.baggagetagnumber);
    //creates an {astra_db} client
    const astraClient = await createClient({
        astraDatabaseId: process.env.ASTRA_DB_ID,
        astraDatabaseRegion: process.env.ASTRA_DB_REGION,
        applicationToken: process.env.ASTRA_DB_APPLICATION_TOKEN,
    });
    
    //If successful, prints astraClient to console
    console.log(astraClient)

    const basePath = `/api/rest/v2/keyspaces/${process.env.ASTRA_DB_KEYSPACE}/baggage`
    //const passenger_id = '33330000-1111-1111-1111-000011110000'

    try {
        const {data, status} = await astraClient.get(`${basePath}`, {
            params: {
                where: {
                    passenger_id: { $eq: `${baggagetagnumber}`}
                }
            }
        });
        //console.log();
        return {
            statusCode: status,
            body: JSON.stringify(Object.keys(data).map((i) => data[i])),
        };

    } catch (e) {
        console.error(e);
        return {
            statusCode: 500,
            body: JSON.stringify(e),
        }
    }
}



