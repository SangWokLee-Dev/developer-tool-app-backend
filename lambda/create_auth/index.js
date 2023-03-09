const handler = async (event) => {
    if (event.request.challengeName !== "CUSTOM_CHALLENGE") {
      return event;
    }
  
    if (event.request.session.length === 2) {
      event.response.publicChallengeParameters = {};
      event.response.privateChallengeParameters = {};
      event.response.publicChallengeParameters.captchaUrl = "url/123.jpg";
      event.response.privateChallengeParameters.answer = "5";
    }
  
    if (event.request.session.length === 3) {
      event.response.publicChallengeParameters = {};
      event.response.privateChallengeParameters = {};
      event.response.publicChallengeParameters.securityQuestion =
        "Who is your favorite team mascot?";
      event.response.privateChallengeParameters.answer = "Peccy";
    }
  
    return event;
  };
  
  export { handler }
  