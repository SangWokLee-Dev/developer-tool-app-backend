export const handler = async(event) => {
    const postcodes = ['SW1A 0AA', 'NW1 4RY', 'E1 6BJ', 'SE1 7TP', 'W1D 7EJ'];
    const providers = ['DHL', 'FedEx', 'UPS', 'TNT'];

    const jobList = [];

    for (let i = 0; i < 20; i++) {
    const job = {
        origin: postcodes[Math.floor(Math.random() * postcodes.length)],
        destination: postcodes[Math.floor(Math.random() * postcodes.length)],
        provider: providers[Math.floor(Math.random() * providers.length)]
    };
    jobList.push(job);
    }

    const response = {
        statusCode: 200,
        body: jobList,
    };
    return response;
};
