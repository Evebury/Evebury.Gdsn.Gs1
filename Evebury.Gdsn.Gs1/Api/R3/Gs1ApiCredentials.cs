namespace Evebury.Gdsn.Gs1.Api.R3
{
    /// <summary>
    /// Api credentials
    /// </summary>
    public struct Gs1ApiCredentials(string baseUri, string apiKey)
    {

        /// <summary>
        /// Base uri of the Gs1 Api
        /// </summary>
        public string BaseUri { get; set; } = baseUri;

        /// <summary>
        /// Set to your Gs1 Api Key
        /// </summary>
        public string ApiKey { get; set; } = apiKey;
    }
}
