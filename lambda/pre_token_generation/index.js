const handler = async (event) => {
    // Set the custom claim
    const customClaims = { 'location': 'Canary Wharf' };
  
    // Add the custom claim to the ID token and access token
    event.response = {
      ...event.response,
      'claimsOverrideDetails': {
        'claimsToAddOrOverride': customClaims
      }
    };
  
    return event;
  };
  
export { handler };
  